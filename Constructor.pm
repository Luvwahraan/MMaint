package Constructor;

use strict;
use warnings;
use Encode;
use utf8;

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


__END__
