package TestRole::Data::Handle;

use Moose::Role;
use Test::More;

has expected_values => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef',
    builder => '_build_expected_values',
    handles => { get_expected_row => 'get' },
);

sub _build_expected_values {
    return [
        { date => '2013-07-05', distance => 20, },
        { date => '2013-07-06', distance => 15, },
        { date => '2013-07-07', distance => 17, },
        { date => '2013-07-08', distance => 19, },
        { date => '2013-07-09', distance => 32, },
        { date => '2013-07-10', distance => 55, },
        { date => '2013-07-11', distance => 14, },
        { date => '2013-07-12', distance => 12, },
        { date => '2013-07-13', distance => 9, },
        { date => '2013-07-14', distance => 84, },
    ];
}

sub _test_data_handle {
    my $self        = shift;
    my $data_handle = shift;
    my $type        = shift;

    for ( my $i = 0; my $row = $data_handle->next_row(); $i++ ) {
        my $expected_row = $self->get_expected_row( $i );
        is_deeply( $row, $expected_row, "Got expected row for $type" );
    }
}

1;

