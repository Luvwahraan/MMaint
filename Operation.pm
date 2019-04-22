package Operation;

use strict;
use warnings;
use Motorcycle;
use Supply;

sub new {
  my $obj = shift;
  my $self = {};

  $self->{id} = shift;
  $self->{motorcycle} = shift;
  $self->{date} = shift;
  $self->{type} = shift;
  $self->{comment} = shift;
  $self->{mileage} = shift;
  #$self->{suppliesTabref} = shift;

  return bless($self, $obj);
}


sub getId {
  my $self = shift;
  return $self->{id};
}

sub getMotorcycle {
  my $self = shift;
  return $self->{motorcycle};
}

sub getDate {
  my $self = shift;
  return $self->{date};
}

sub getComment {
  my $self = shift;
  return $self->{comment};
}

sub getType {
  my $self = shift;
  return $self->{type};
}

sub getMileage {
  my $self = shift;
  return $self->{mileage};
}

sub getSupplies {
  my $self = shift;
  return $self->{suppliesTabref};
}

1;
