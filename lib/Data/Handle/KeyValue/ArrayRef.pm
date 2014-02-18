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
