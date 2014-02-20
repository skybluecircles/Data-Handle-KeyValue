package Data::Handle::KeyValue::SQLStatement;

use v5.16;

use strict;
use warnings;

use autodie qw(:all);
use namespace::autoclean;

use Moose;

has dbh => (
    is      => 'ro',
    isa     => 'DBI::db',
    handles => { _prepare => 'prepare' },
);

has sql_statement => (
    is  => 'ro',
    isa => 'Str',
);

has bind_values => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef',
    handles => { _all_bind_values => 'elements' },
    default => sub { [] },
);

has _sth => (
    is      => 'ro',
    isa     => 'DBI::st',
    builder => '_build_sth',
    lazy    => 1,
    handles => { next_row => 'fetchrow_hashref' },
);

with 'Data::Handle::Role::KeyValue';

sub _build_sth {
    my $self = shift;

    my $sth = $self->_prepare( $self->sql_statement );
    $sth->execute( $self->_all_bind_values );

    return $sth;
}

__PACKAGE__->meta()->make_immutable();

1;

=pod

=head1 SYNOPSIS

  use Data::Handle::SQLStatement;
  use DBD::SQLite;
  use DBI;

  my $database = '/path/to/foo.db';
  my $dbh = DBI->connect( "dbi:SQLite:dbname=$database", q{}, q{}, );
  my $sql_statement
      = 'SELECT date, distance FROM travel_log WHERE date > ? AND distance < ?';
  my $bind_values = [ '2013-10-22', 50 ];

  my $data_handle = Data::Handle::KeyValue::SQLStatement->new(
      dbh           => $dbh,
      sql_statement => $sql_statement,
      bind_values   => $bind_values,
  );

  while ( my $row = $data_handle->next_row() ) {
      ...;
  }

  # can use any DBD module for DBI - SQLite is just an example

=head1 DESCRIPTION

The modules in Data::Handle::KeyValue provide a consistent interface for fetching rows of hash refs. In particular Data::Handle::KeyValue::SQLStatement does so for a SQL table in a RDBMS.

=head1 CONSTRUCTION

=head2 new

Takes two required paramaters: dbh and sql_statement. dbh is a DBI database handle and sql_statement is just your sql statement as a string. It can have placeholders.

Also takes one optional parameter as an array reference: bind_values.

=head1 METHODS

=head2 next_row

Fetches the next row from your table and returns it as a hash ref.

=cut
