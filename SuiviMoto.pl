#!/usr/bin/env perl

use v5.28;
use strict;
use warnings;

use DBI;
use lib '.';

use DBHandler;
use Constructor;
use Motorcycle;
use TypeOperation;

use Data::Dumper;

my $selectedMotorcycle;

my $DBHandler = DBHandler->new('comms', 'sulvul', 'marion', 'R4tonL@veur', '5432');
#$DBHandler->fetchConstructors();
#$DBHandler->fetchMotorcycles();

sub getMotorcycleName {
  my $motorcycle = shift;
  my $immat = '';
  $immat = ' '.$motorcycle->{registration} if (defined $motorcycle->{registration});
  return "$motorcycle->{name}$immat";
}


sub printMotorcycleOperations {
  my $motorcycle = shift;
  my $immat = '';
  $immat = ' '.$motorcycle->{registration} if (defined $motorcycle->{registration});
  print "Listes des entretiens pour ".getMotorcycleName($selectedMotorcycle)." :\n";

  state @keys = qw/date mileage type comment/;
  printf(" %-4s  %-12s%-8s%-30s%-45s\n",' ' , @keys);
  for (my $i = 0; $i < scalar @{$motorcycle->{operation}}; $i++) {
    printf("[%4d] %-12s%-8d%-30s%-45s\n",$i, $motorcycle->{operation}->[$i]->@{@keys});
  }
}

foreach my $motorcycle (@{$DBHandler->{motorcycles}}) {
  $DBHandler->fetchOperationByMotorcycle($motorcycle);
  #print Dumper $motorcycle;
}


sub askTypeOpe {
  my $input = undef;

  while (!$input) {
    print "Type d’opération: \n";
    foreach my $tOpe(keys @{$DBHandler->{typeOperation}}) {
      printf "[%3d] %-40s", $tOpe, $DBHandler->{typeOperation}[$tOpe]->getName();
      if ($tOpe % 3 == 0) { print "\n"; }

    }
    $input = <STDIN>; chop $input;
    $input = '' if ($input !~ /^\d+$/);

    if ((! $input eq '') and defined($DBHandler->{typeOperation}[$input])) {
      print "Opération ".$DBHandler->{typeOperation}[$input]->getName()."\n";
    } else {
      $input = undef;
      print "Opération invalide. ";
    }
  }

  return $DBHandler->{typeOperation}[$input];
}

sub askMileage {
  my $mileage = 0;

  while ($mileage <= 0) {
    print "Kilométrage: ";
    $mileage = <STDIN>; chop $mileage;
    if ($mileage !~ /^\d+$/) {
      print "Kilométrage invalide. ";
      $mileage = 0;
    }
  }

  return $mileage;
}

sub askSupply {
  my $motorcycle = shift;
  my $input = undef;

  while (!$input) {
    print "Stock utilisé: \n";

    my $supply = $DBHandler->fetchUnusedSupplies();
    my @keys = qw/date description quantity/;
    printf("%-13s %-60s %-12s\n", @keys, "total");
    foreach my $s(@{$supply}) {
      printf("%-13s %-60s %12d\n", $s->@{@keys});
    }

    foreach my $tOpe(keys @{$DBHandler->{typeOperation}}) {
      printf "[%3d] %-40s", $tOpe, $DBHandler->{typeOperation}[$tOpe]->getName();
      if ($tOpe % 3 == 0) { print "\n"; }

    }
    $input = <STDIN>; chop $input;
    $input = '' if ($input !~ /^\d+$/);

    if ((! $input eq '') and defined($DBHandler->{typeOperation}[$input])) {
      print "Opération ".$DBHandler->{typeOperation}[$input]->getName()."\n";
    } else {
      $input = undef;
      print "Opération invalide. ";
    }
  }

  return $DBHandler->{typeOperation}[$input];
}

sub addOperation {
  print "Adding operation\n";
  my $motorcycle = shift;

  my $typeOperation = askTypeOpe();
  print Dumper $typeOperation;
  print "Commentaire: "; my $comment = <STDIN>; chop $comment;
  #my @stock = askSupply($motorcycle);
  my $mileage = askMileage($motorcycle);

  my $operation = new Operation(undef,$motorcycle,undef,$typeOperation,$comment,$mileage);
  $DBHandler->addOperation($operation);
}

sub addSupply {
  my $seller = '';
  my $description = '';
  my $price = 0;
  my $quantity = '';

  print "Vendeur: ";
  $seller = <STDIN>; chop $seller;

  while ($description eq '') {
    print "Description: ";
    $description = <STDIN>; chop $description;
  }

  while ($price == 0) {
    print "Prix: ";
    my $p = <STDIN>; chop $p;
    $price = sprintf("%.2f", $p);
    $price = 0 if ($price < 0);
  }

  while ($quantity !~ /^\d+$/) {
    print "Quantity: ";
    my $p = <STDIN>; chop $p;
    $quantity = sprintf("%d", $p);
  }

  my $newSupply = new Supply(undef, undef, $seller, $description, $price, $quantity);
  $DBHandler->addSupply($newSupply);
}

sub listOperations {
  my $opeNb = shift;
  print "List operation $opeNb\n";

}

sub listSupply {
  my $supply = $DBHandler->fetchUnusedSupplies();
  my @keys = qw/date seller description price quantity/;
  printf("%-13s %-25s %-60s %-13s %-12s %-13s\n", @keys, "total");
  foreach my $s(@{$supply}) {
    printf("%-13s %-25s %-60s %-10.2f %12d %10.2f\n", $s->@{@keys}, ($s->{price}*$s->{quantity}));
  }
}



sub getMotorcycleNb {
  print  "Motocyclettes dans la base de données :\n";
  my $m = "";
  my $nb = -1;

  foreach ($DBHandler->getMotorcyclesName()) {
    $nb++;
    print "[$nb] $_\n";
  }

  while ($m !~ /\d+/ or $m < 0 or $m > $nb) {
    print "Choisissez une moto : ";
    $m = <STDIN>;
    $m = 1 if ($m eq "\n");
    print "Moto invalide. " if ($m < 0 or $m > $nb or $m !~ /\d+/);
  }

  return $m;
}


use Curses::UI;
my $cui = new Curses::UI( -mouse_support => 1, -color_support => 1 );

sub exit_dialog()
{
        my $return = $cui->dialog(
                -message   => "Do you really want to quit?",
                -title     => "Are you sure???",
                -buttons   => ['yes', 'no'],

        );

exit(0) if $return;
}

sub listMotorcycleOperations {
  my $motorcycle = shift;
  my $immat = '';
  $immat = ' '.$motorcycle->{registration} if (defined $motorcycle->{registration});
  print "Listes des entretiens pour ".getMotorcycleName($selectedMotorcycle)." :\n";

  state @keys = qw/date mileage type comment/;
  printf(" %-4s  %-12s%-8s%-30s%-45s\n",' ' , @keys);
  for (my $i = 0; $i < scalar @{$motorcycle->{operation}}; $i++) {
    printf("[%4d] %-12s%-8d%-30s%-45s\n",$i, $motorcycle->{operation}->[$i]->@{@keys});
  }
}

my $motoMenu;
foreach my $moto(@{$DBHandler->{motorcycles}}) {
  my @values;
  my $labels;
  state @keys = qw/date mileage type comment/;

  foreach my $ope(@{$moto->{operation}}) {
    push(@values, $ope->{id});
    $labels->{$ope->{id}} = sprintf("%-12s%-8d%-30s%-45s\n", $moto->{operation}->@{@keys});
  }

  my $immat = ''; $immat = " [$moto->{registration}]" if (defined $moto->{registration});
  push(@$motoMenu, {-label => "$moto->{name}$immat", -value => $moto} );
};


my $menu = $cui->add(
    'menu', 'Menubar', -menu => [
      {-label => 'Moto', -submenu => $motoMenu},
      {-label => 'Stock', -submenu => [
          {-label => "Ajout", -value => ''},
          {-label => "Liste", -value => ''},
        ]},
      {-label => 'Quitter', -submenu => \&exit_dialog},
    ]
  );

$cui->set_binding(sub {$menu->focus()}, "\cX");
$cui->set_binding( \&exit_dialog , "\cQ");

$menu->focus();
$cui->mainloop();

__END__


my $motorcycleNb = getMotorcycleNb();
$selectedMotorcycle = $DBHandler->{motorcycles}->[$motorcycleNb];
printMotorcycleOperations($selectedMotorcycle);

use Switch;

while (1) {
  print "\n";
  my $c; my $valid = 0;
  while ($valid == 0) {
    print "Ajout entretien:a";
    print "\tAjout stock:s";
    print "\tListe stock:l";
    print "\tListe matériel opération:o";
    print "\n";
    $c = <STDIN>;
    if ($c =~ /^([aslo])( ?\d+)?/) {
      switch($1) {
        case 'a' { addOperation($selectedMotorcycle); $valid++; }
        case 's' { addSupply(); $valid++; }
        case 'l' { listSupply(); $valid++; }
        case 'o' { if (defined $2) { listOperations($2); $valid++; } }
      }
    }
  }
}

__END__
print Dumper $DBHandler->{motorcycles}[$nb];

# 2 - Choix de l'utilisateur
my $term = Term::ReadLine->new('Motorcycle> ');
$selectedMotorcycle = $term->get_reply(
  print_me =>,
  prompt   => 'Choisissez une moto : ',
  choices  =>
  #default  => 'PICARDIE',
);

print Dumper $DBHandler;
foreach my $obj ($DBHandler->getMotorcycles()) {
  $DBHandler->fetchOperationByMotorcycle(\$obj);
}



