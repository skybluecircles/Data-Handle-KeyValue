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

has statement => (
    is  => 'ro',
    isa => 'Str',
);

has bind => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef',
    handles => { _all_bind => 'elements' },
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

    my $sth = $self->_prepare( $self->statement );
    $sth->execute( $self->_all_bind );

    return $sth;
}

__PACKAGE__->meta()->make_immutable();

1;
