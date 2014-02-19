package TestFor::Data::Handle::KeyValue::SQLStatement;

use Data::Handle::KeyValue::SQLStatement;
use DBD::SQLite;
use DBI;

use Test::Class::Moose;
with 'TestRole::Data::Handle';

sub test_sql_statement {
    my $self = shift;

    my $database = 't/test-data/travel-log.db';
    my $dbh
        = DBI->connect( "dbi:SQLite:dbname=$database", q{}, q{},
        { RaiseError => 1 },
        ) or die "Could not connect to $database: $DBI::errstr";
    my $statement = 'SELECT date, distance FROM travel_log';

    my $data_handle = Data::Handle::KeyValue::SQLStatement->new( dbh => $dbh, statement => $statement );

    $self->_test_data_handle( $data_handle, 'sql statement' );
}

1;
