package Data::Handle::KeyValue::ArrayRef;

use v5.16;

use strict;
use warnings;

use autodie qw(:all);
use namespace::autoclean;

use Moose;

has array_ref => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef',
    handles => { next_row => 'shift', },
);

with 'Data::Handle::Role::KeyValue';

__PACKAGE__->meta()->make_immutable();

1;

=pod

=head1 SYNOPSIS

  use Data::Handle::KeyValue::ArrayRef;

  my $array_ref = [ ... ];
  my $data_handle = Data::Handle::KeyValue::ArrayRef->new( array_ref => $array_ref );

  while ( my $row = $data_handle->next_row() ) {
      ...
  }

=head1 DESCRIPTION

The modules in Data::Handle::KeyValue provide a consistent interface for fetching rows of hashrefs. In particular Data::Handle::KeyValue::ArrayRef does so for an arrayref which already exists in Perl.

=head1 CONSTRUCTOR

=head2 new

Takes a single required attribute called array_ref which must be a reference to an array.

=head1 METHODS

=head2 next_row

Fetches the next element from the array ref which was passed at construction. This element is expected to be a hash ref.

=cut
