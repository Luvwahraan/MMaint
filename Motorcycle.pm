package Motorcycle;

use strict;
use warnings;
use Encode;
use utf8;

use Constructor;
use Operation;


sub new {
  my $obj = shift;
  my $self = {};

  $self->{id} = shift;
  $self->{constructor} = shift;
  $self->{name} = shift; # Nom commercial. Ex: CB750 Sevenfifty
  $self->{ref} = shift; # type mine
  $self->{registration} = shift; # Immatriculation
  $self->{mileage} = shift; # kilométrage

  return bless($self, $obj);
}

sub setLastOperation {
  my $self = shift;
  my $operation = shift;
  $self->{lastOperation} = $operation;
}

sub addOperation {
  my $self = shift;
  my $operation = shift;
  push @{$self->{operation}}, $operation;
}

sub getLastOperation {
  my $self = shift;
  return @{$self->{lastOperation}};
}

sub getOperations {
  my $self = shift;
  return @{$self->{operation}};
}

sub getRef {
  my $self = shift;
  return $self->{ref};
}

sub getRegistration {
  my $self = shift;
  return $self->{registration};
}

sub getName {
  my $self = shift;
  return $self->{name};
}

sub getFullName {
  my $self = shift;
  return join(' ', $self->{constructor}->getName(), $self->{name}, $self->{ref});
}

sub getConstructor {
  my $self = shift;
  return $self->{constructor};
}

sub getId {
  my $self = shift;
  return $self->{id};
}

sub getMileage {
  my $self = shift;
  return $self->{mileage};
}
sub setMileage {
  my $self = shift;
  my $nMileage = shift;
  if ($nMileage > $self->{mileage}) {
    $self->{mileage} = $nMileage;
  }
}

sub addMileage {
  my $self = shift;
  my $add = shift;

  my $nMileage = $self->{mileage} + $add;
  if ( $nMileage > $self->{mileage}) {
    $self->{mileage} = $nMileage;
    return 1;
  } else { return 0; }
}

1;


__END__

