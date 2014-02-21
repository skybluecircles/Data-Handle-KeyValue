package TestFor::Data::Handle::KeyValue::SQLStatement::Abstract;

use Data::Handle::KeyValue::SQLStatement::Abstract;
use DBD::SQLite;
use DBI;

use Test::Class::Moose;
with 'TestRole::Data::Handle';

sub test_abstract_sql_statement {
    my $self = shift;

    my $database = 't/test-data/travel-log.db';
    my $dbh
        = DBI->connect( "dbi:SQLite:dbname=$database", q{}, q{},
        { RaiseError => 1 },
        ) or die "Could not connect to $database: $DBI::errstr";
    my $table = 'travel_log';
    my $columns = [ 'date', 'distance' ];

    my $data_handle = Data::Handle::KeyValue::SQLStatement::Abstract->new(
        dbh     => $dbh,
        table   => $table,
        columns => $columns,
    );

    $self->_test_data_handle( $data_handle, 'abstract sql statement' );
}

1;
