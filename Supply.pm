package Supply;

use strict;
use warnings;
use Encode;
use utf8;

sub new {
  my $obj = shift;
  my $self = {};

  $self->{id} = shift;
  $self->{date} = shift;
  $self->{seller} = shift;
  $self->{description} = shift;
  $self->{price} = shift;
  $self->{quantity} = shift;

  return bless($self, $obj);
}

sub getId {
  my $self = shift;
  return $self->{id};
}

sub getDate {
  my $self = shift;
  return $self->{date};
}

sub getSeller {
  my $self = shift;
  return $self->{Seller};
}

sub getDescription {
  my $self = shift;
  return $self->{Description};
}

sub getPrice {
  my $self = shift;
  return $self->{Price};
}

sub getQuantity {
  my $self = shift;
  return $self->{quantity};
}

sub getTotalPrice {
  my $self = shift;
  return ($self->{price} * $self->{quantity});
}



1;


__END__
