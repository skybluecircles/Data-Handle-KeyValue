package Data::Handle::KeyValue::CSV;

use v5.16;

use strict;
use warnings;

use autodie qw(:all);
use namespace::autoclean;

use Text::CSV;

use Moose;
extends 'Data::Handle::KeyValue';
with 'Data::Handle::Role::KeyValue';

has path_to_csv => (
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

    open( my $fh, '<', $self->path_to_csv )
        or die "Could not open csv file: $!";

    return $fh;
}

sub _build_csv {
    my $self = shift;

    my $csv = Text::CSV->new( $self->csv_params )
        or die "Could not create new Text::CSV object: $!";

    my $column_names;
    if ( $self->header ) {
        $column_names = $csv->getline( $self->_file_handle );
    }
    elsif ( $self->column_names ) {
        $column_names = $self->column_names;
    }
    else {
        die
            "Please pass either the CSV's column names or a true value for the 'header' attribute."
            ; # I should really check at construction to make sure that either header or column_names is passed rather than here in the builder
    }

    $csv->column_names( @{$column_names} );

    return $csv;

}

sub next_row {
    my $self = shift;

    return $self->_getline_hr( $self->_file_handle );
}

__PACKAGE__->meta()->make_immutable();

1;

=pod

=head1 SYNOPSIS

  use Data::Handle::KeyValue::CSV;

  my $path_to_csv = '/path/to/foo.csv';
  my $csv_params  = { ... };

  my $header      = 1;
  my $data_handle = Data::Handle::KeyValue::CSV->new(
      path_to_csv => $path_to_csv,
      csv_params  => $csv_params,
      header      => $header,
  );

  my $column_names = [ ... ];
  my $data_handle  = Data::Handle::KeyValue::CSV->new(
      path_to_csv  => $path_to_csv,
      csv_params   => $csv_params,
      column_names => $column_names,
  );

=head1 DESCRIPTION

The modules in L<Data::Handle::KeyValue> provide a consistent interface for fetching rows of hash refs. In particular Data::Handle::KeyValue::CSV does so for a CSV file.

=head1 CONSTRUCTION

=head2 C<new>

Takes one required parameter: C<path_to_csv> which, as you can see, is the path to the csv file you would like to read.

Also requires one of the following two parameters: C<header> or C<column_names>. If Perl evaluates C<header> to be true, this module uses the first line of the file to get the keys for the columns. If C<header> is false, this module expects you to pass the column names explicitly as an array ref for the C<column_names> attribute.

Optionally, you may pass a hash ref for C<csv_params>. This module uses L<Text::CSV> to read the csv file, so C<csv_params> is passed directly to Text::CSV. If C<csv_params> is not passed, the defaults for Text::CSV are used.

=head1 METHODS

=head2 C<next_row>

Fetches the next row of your csv file and returns it as a hash ref.

=head1 SEE ALSO

L<Data::Handle::KeyValue::ArrayRef>
L<Data::Handle::KeyValue::SQLStatement>

=cut
