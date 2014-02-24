package TestFor::Data::Handle::KeyValue::CSV;

use Data::Handle::KeyValue::CSV;
use Test::Class::Moose;
use Try::Tiny;

with 'TestRole::Data::Handle::KeyValue';

sub test_csv_with_header {
    my $self = shift;

    my $path_to_csv = 't/test-data/travel-log.with-header.csv';
    my $header      = 1;

    my $data_handle = Data::Handle::KeyValue::CSV->new(
        path_to_csv => $path_to_csv,
        header      => $header
    );

    $self->_test_data_handle( $data_handle, 'csv with header' );
}

sub test_csv_without_header {
    my $self = shift;

    my $path_to_csv = 't/test-data/travel-log.without-header.csv';
    my $column_names = [ 'date', 'distance' ];

    my $data_handle = Data::Handle::KeyValue::CSV->new(
        path_to_csv  => $path_to_csv,
        column_names => $column_names
    );

    $self->_test_data_handle( $data_handle, 'csv without header' );
}

sub test_column_names_xor_header {
    my $path_to_csv  = 'foo.csv';
    my $column_names = [ 'date', 'distance' ];
    my $header       = 1;

    my $fatal_error;
    try {
        my $data_handle = Data::Handle::KeyValue::CSV->new(
            path_to_csv  => $path_to_csv,
            column_names => $column_names,
            header       => $header
        );
    }
    catch {
        $fatal_error = $_;
    }
    finally {
        my $expected_error
            = "You must pass one of 'column_names' or 'header' but not both\n";
        is( $fatal_error, $expected_error,
            "Raised exception when both 'column_names' and 'header' are passed"
        );
    };
}

1;
