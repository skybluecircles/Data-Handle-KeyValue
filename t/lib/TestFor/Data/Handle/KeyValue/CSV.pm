package TestFor::Data::Handle::KeyValue::CSV;

use Data::Handle::KeyValue::CSV;
use Test::Class::Moose;
use Test::Fatal;

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
    my $path_to_csv = 'foo.csv';
    my $column_names = [ 'date', 'distance' ];

    my $expected
        = "You must pass one of 'column_names' or 'header' but not both\n";
    my $message
        = "Raised exception when both 'column_names' and 'header' are passed";

    is( exception {
            Data::Handle::KeyValue::CSV->new(
                path_to_csv  => $path_to_csv,
                column_names => $column_names,
                header       => 1,
            );
        },
        $expected,
        $message,
    );
}

sub test_empty_file {
    my $path_to_csv = 't/test-data/empty.csv';
    my $header      = 1;

    my $expected
        = "Your csv file at '$path_to_csv' contains no header - is your file empty?\n";
    my $message
        = 'Raised exception when asked to parse header for an empty file';

    is( exception {
            Data::Handle::KeyValue::CSV->new(
                path_to_csv => $path_to_csv,
                header      => $header,
            );
        },
        $expected,
        $message,
    );
}

1;
