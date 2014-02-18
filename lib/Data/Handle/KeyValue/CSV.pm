package Data::Handle::KeyValue::CSV;

use v5.16;

use strict;
use warnings;

use autodie qw(:all);
use namespace::autoclean;

use Carp;
use Text::CSV;

use Moose;

with 'Data::Handle::Role::KeyValue';

has file => (
    is  => 'ro',
    isa => 'Str',
);

has _file_handle => (
    is       => 'ro',
    builder  => '_build_file_handle',
    lazy     => 1,
    init_arg => undef,
);

has csv_params => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
);

has column_names => (
    is  => 'ro',
    isa => 'ArrayRef',
);

has header => (
    is      => 'ro',
    default => 0,
);

has _csv => (
    is       => 'ro',
    isa      => 'Text::CSV',
    builder  => '_build_csv',
    init_arg => undef,
    lazy     => 1,
    handles  => { _getline_hr => 'getline_hr', },
);

sub _build_file_handle {
    my $self = shift;

    open( my $fh, '<', $self->file ) or die "Could not open csv file: $!";

    return $fh;
}

sub _build_csv {
    my $self = shift;

    my $csv = Text::CSV->new( $self->csv_params ) or die "Could not create new Text::CSV object: $!";

    my $column_names;
    if ( $self->header ) {
        $column_names = $csv->getline( $self->_file_handle );
    }
    elsif ( $self->column_names ) {
        $column_names = $self->column_names;
    }
    else {
        die
            "Please pass either the CSV's column names or a true value for the 'header' attribute.";
    }

    $csv->column_names( @{$column_names} );

    return $csv;

# I should really check at construction to make sure that either header or column_names is passed rather than here in the builder
}

sub next_row {
    my $self = shift;

    return $self->_getline_hr( $self->_file_handle );
}

__PACKAGE__->meta()->make_immutable();

1;
