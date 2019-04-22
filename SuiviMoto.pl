#!/usr/bin/env perl

use v5.28;
use strict;
use warnings;

use DBI;
use lib '.';
use Curses::UI;


use DBHandler;
use Constructor;
use Motorcycle;
use TypeOperation;

use Data::Dumper;

my $selectedMotorcycle;

my $DBHandler = DBHandler->new('comms', 'sulvul', 'marion', 'R4tonL@veur', '5432');
my $cui = new Curses::UI( -mouse_support => 1, -color_support => 1, -debug => 0);

sub exit_dialog {
  my $return = $cui->dialog(
    -message   => "Voulez-vous quitter ?",
    -title     => "Quitter",
    -buttons   => ['yes', 'no']
  );
  exit(0) if $return;
}


my $window = $cui->add(
    'win1', 'Window',
    -border => 0,
    -y    => 1,
  );

my $menu;
my %motoSub;
my $motoListMenu;
my $container;
my $addOperationValue = sub {};
my $motoMenu = [];
my $form;

sub addMenu {
  $menu = $cui->add(
      'menu', 'Menubar', -menu => [
        {-label => 'Choix moto', -submenu => $motoListMenu},
        {-label => 'Moto', -submenu => $motoMenu},
        {-label => 'Stock', -submenu => [
            {-label => "Ajout", -value => ''},
            {-label => "Liste", -value => ''},
          ]},
        {-label => 'Quitter ^Q', -submenu => \&exit_dialog},
      ]
    );
}


# listing moto, creating submenu foreach.
foreach my $moto(@{$DBHandler->{motorcycles}}) {

  $motoSub{$moto->{id}}{motoMenu} = sub {
    my @values;
    my $labelsList;
    # list operations types
    foreach my $type( @{$DBHandler->{typeOperation}} ) {
      $labelsList->{$type->getId()} = $type->getName();
      push( @values, $type->getId());
    }

    my $opeType;
    my $comment;
    my $mileage;
    my $nextForm;

    my $typeOpeSub = {
      # Removing operations type
      $window->delete('container') if $container;

      $container = $window->add(
          'container', 'Listbox',
          -values     => \@values,
          -labels     => $labelsList,
          -title      => 'Choix type opérations',
          -height     => 45,
          -border     => 1,
          -onchange   => $nextForm,
        );
    };

    my $commentSub = sub {
      $opeType = $container->get();
      $window->delete('container') if $container;

      $window->add(
          'container', 'TextViewer',
          -border          => 1,
          -padtop          => 0,
          -padbottom       => 3,
          -hscrollbar      => 1,
          -singleline      => 1
          -text            => 'nothing insrtaienrstaie t',
          -columnScroll    => 0,
          -addBlankColumns => 1,
          #~ -fieldSeparator  => "*",
        );
    };

    my $mileageSub = sub {
    };
    #~ $container->focus();


  };

  $motoSub{$moto->{id}}{listMenu} = sub {
    my $moto = shift;
    #$cui->status($moto->getFullName());

    $DBHandler->fetchOperationByMotorcycle($moto);

    my @values;
    my $labelsList;
    foreach my $operation( @{$moto->{operation}}) {
      my $id = $operation->getId();
      my $date = $operation->getDate();
      my $mileage = $operation->getMileage();
      my $type = $operation->getType();
      my $comment = $operation->getComment();
      #$labelsList->{$operation->getId()} = join (' ', $operation->{date}, $operation->mileage,$operation->{type},$operation->{comment});
      $labelsList->{$operation->getId()} = sprintf("%-6d %-12s %-8d %-30s %-45s" ,$id, $date, $mileage, $type, $comment);
      push( @values, $operation->getId());
    }

    # Remplacing menu
    $cui->delete('menu');
    $motoMenu = [{-label => 'Ajout entretien', -value => $motoSub{$moto->{id}}{motoMenu} }];
    #$addOperationValue = $motoSub{$moto->{id}}->{motoMenu};
    addMenu();

    # Listing operations
    $window->delete('container') if $container;
    $container = $window->add(
        'container', 'Listbox',
        -values     => \@values,
        -labels     => $labelsList,
        -title      => sprintf("%-6s %-12s %-8s %-30s %-45s", qw/id date mileage type comment/),
        -height     => 45, -border => 1,
      );
    $container->focus();
  };

  my $immat = ''; $immat = " [$moto->{registration}]" if (defined $moto->{registration});
  push(@$motoListMenu, {-label => $moto->getName().$immat, -value => sub {$motoSub{$moto->{id}}{listMenu}->($moto)}} );
};

#~ $menu = $cui->add(
    #~ 'menu', 'Menubar', -menu => [
      #~ {-label => 'Choix moto', -submenu => $motoListMenu},
      #~ {-label => 'Moto', -submenu => $motoMenu},
      #~ {-label => 'Stock', -submenu => [
          #~ {-label => "Ajout", -value => ''},
          #~ {-label => "Liste", -value => ''},
        #~ ]},
      #~ {-label => 'Quitter ^Q', -submenu => \&exit_dialog},
    #~ ]
  #~ );
addMenu();

$cui->set_binding(sub {$menu->focus()}, "\cX");
$cui->set_binding( \&exit_dialog , "\cQ");

$menu->focus();
$cui->mainloop();

__END__



