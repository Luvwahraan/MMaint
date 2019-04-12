package TypeOperation;

use strict;
use warnings;

sub new {
  my $obj = shift;
  my $self = {};

  $self->{id} = shift;
  $self->{name} = shift;

  return bless($self, $obj);
}

sub getName {
  my $self = shift;
  return $self->{name};
}


sub getId {
  my $self = shift;
  return $self->{id};
}

1;
