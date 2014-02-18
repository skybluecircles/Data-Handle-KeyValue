package TestFor::Data::Handle::KeyValue::ArrayRef;

use Data::Handle::KeyValue::ArrayRef;
use Test::Class::Moose;

with 'TestRole::Data::Handle';

sub test_arrayref {
    my $self = shift;

    my $travel_log = [
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

    my $data_handle = Data::Handle::KeyValue::ArrayRef->new( array_ref => $travel_log );

    $self->_test_data_handle( $data_handle, 'arrayref' );
}

1;
