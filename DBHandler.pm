package DBHandler;

use strict;
use warnings;

use Encode;
use utf8;
use DBI;

use Constructor;
use Motorcycle;
use Supply;
use TypeOperation;

my $bd    = 'comms';
my $serveur = 'sulvul';
my $identifiant = 'marion';
my $motdepasse  = 'R4tonL@veur';
my $port  = '5432';


sub new {
  my $obj = shift;
  my $self = {};
  my $bd    = shift;
  my $serveur = shift;
  my $identifiant = shift;
  my $motdepasse  = shift;
  my $port  = shift;

  # Connection à la base de données.
  $self->{dbh} = DBI->connect( "DBI:Pg:database=$bd;host=$serveur;port=$port", $identifiant, $motdepasse, {RaiseError => 1}) ;
  #$self->{dbh}->do(qq{SET NAMES 'utf8';});

  $self->{name} = [];

  my $new = bless($self, $obj);

  $self->fetchConstructors();
  $self->fetchMotorcycles();
  $self->fetchTypesOperation();

  return $new;
}

sub addOperation {
  my $self = shift;
  my $operation = shift;

  my $id_oper = $operation->{motorcycle}->getId();
  my $comment = $operation->{comment};
  my $mileage = $operation->{mileage};
  my $id_type = $operation->{type}->getId();

  my $sql = <<EOF;
WITH rows AS (
    INSERT INTO operation (id_motorcycle,comment,mileage)
    VALUES ($id_oper, '$comment', $mileage)
    RETURNING $id_type, id_oper
)
INSERT INTO oper_type (id_type,id_oper)
    (SELECT * FROM rows );
EOF
  print "$sql";

  my $prep = $self->{dbh}->prepare($sql);
  $prep->execute();
}

sub addSupply {
  my $self = shift;
  my $supply = shift;

  my $c = 'seller,description,price,quantity';
  my @col = split(',', $c);

  my $sql = "INSERT INTO supply ($c) VALUES (";
  my @values;
  foreach my $cname(@col) {
    push @values, "'$supply->{$cname}'";
  }
  $sql .= join(",", @values).");";

  my $prep = $self->{dbh}->prepare($sql);
  $prep->execute();
}

sub checkView {
  my $self = shift;
  my $viewName = shift;

  my $prep = $self->{dbh}->prepare("select viewname from pg_catalog.pg_views where schemaname NOT IN ('pg_catalog', 'information_schema');");
  $prep->execute();

  while (my $v = $prep->fetchrow_array()) {
    if ("$v" eq "$viewName") {
      return 1;
    }
  }
  return 0;
}

sub fetchOperationByMotorcycle {
  my $self = shift;
  my $motorcycle = shift;
  my $name = $motorcycle->getName();
  my $lastOpeMileage = 0;

  my $operationsPrep;
  $operationsPrep = $self->{dbh}->prepare("SELECT * FROM $name ORDER BY id_oper ASC;");
  $operationsPrep->execute();

  my $operation;
  while (my ($id_oper,$id_motorcycle,$date,$type,$comment,$mileage) = $operationsPrep->fetchrow_array()) {
    my $operation = Operation->new($id_oper,$id_motorcycle,$date,$type,$comment,$mileage);
    $motorcycle->addOperation($operation);
  }
  $motorcycle->setLastOperation($operation);
}

sub fetchUnusedSupplies {
  my $self = shift;
  my $supplyArrayRef;
  my $prep;
  my $sql = <<EOF;
SELECT id_supply,date,seller,description,price,quantity
FROM unused_supply;
EOF
  $prep = $self->{dbh}->prepare($sql);
  $prep->execute();

  while (my ($id,$date,$seller,$description,$price,$quantity) =  $prep->fetchrow_array()) {
    push(@{$supplyArrayRef}, Supply->new($id,$date,$seller,$description,$price,$quantity));
    #print "$id,$date,$seller,$description,$price,$quantity\n";
  }

  return $supplyArrayRef;
}

sub fetchTypesOperation {
  my $self = shift;
  my $prep = $self->{dbh}->prepare("SELECT id_type,name FROM type_operation;");
  $prep->execute();
  while (my ($id,$name) = $prep->fetchrow_array()) {
    push(@{$self->{typeOperation}}, new TypeOperation($id, $name));
  }
}

sub fetchSuppliesByOperation {
  my $self = shift;
  my $operationId;
  my $viewName = "Operation_$operationId";
  my $prep;
  my $supplyView = <<EOF;
CREATE VIEW Operation_$operationId AS
SELECT supply.id_supply,supply.date,supply.seller,supply.description,supply.price,supply.quantity
  FROM supply,oper_supply
  WHERE oper_supply.id_oper = $operationId AND supply.id_supply = oper_supply.id_supply;
EOF
  $self->makeView($viewName, $supplyView);

  $prep = $self->{dbh}->prepare();
  $prep->execute();
}

sub makeView {
  my $self = shift;
  my $viewName = shift;
  my $sql = shift;
  my $prep;

  if ($self->checkView($viewName) == 1) {
    $prep = $self->{dbh}->prepare($sql);
    $prep->execute();
  }
}

sub fetchMotorcycles {
  my $self = shift;
  my $prep;
  my $operationView = '';
  $prep = $self->{dbh}->prepare("SELECT id_motorcycle,id_constructor,name,ref,registration,mileage FROM motorcycle;");
  $prep->execute();
  while (my ($id_motorcycle,$id_constructor,$name,$ref,$registration,$mileage) =  $prep->fetchrow_array()) {
    $operationView = <<EOF;
CREATE VIEW $name AS
SELECT operation.id_oper, operation.id_motorcycle, operation.date, type_operation.name AS type,
    operation.comment, operation.mileage
  FROM operation,type_operation,oper_type
  WHERE oper_type.id_type = type_operation.id_type
    AND oper_type.id_oper = operation.id_oper
    AND operation.id_motorcycle = $id_motorcycle
  ORDER BY operation.date;

EOF
    $self->makeView($name,$operationView);
    my $constructor = $self->searchConstructorById($id_constructor);
    push(@{$self->{motorcycles}}, Motorcycle->new($id_motorcycle,$constructor,$name,$ref,$registration,$mileage));
    push(@{$self->{view}}, $name);
  }
}

sub searchConstructorById {
  my $self = shift;
  my $id = shift;
  foreach my $constructor (@{$self->{constructors}}) {
    return $constructor if ($constructor->getId() == $id);
  }
}

sub searchConstructorByName {
  my $self = shift;
  my $name = shift;
  foreach my $constructor (@{$self->{constructors}}) {
    return $constructor if ($constructor->getName() == $name);
  }
}

sub fetchConstructors {
  my $self = shift;
  my $prep;
  $prep = $self->{dbh}->prepare("SELECT id_constructor, name FROM constructor;");
  $prep->execute();
  while (my @row =  $prep->fetchrow_array()) {
    push(@{$self->{constructors}}, Constructor->new($row[0],$row[1]));
  }
}

sub getConstructors {
  my $self = shift;
  return $self->{constructors};
}

sub getMotorcyclesName {
  my $self = shift;
  my @name;
  foreach my $m (@{$self->{motorcycles}}) {
    push @name, $m->getName();
  }
  return @name;
}



1;
