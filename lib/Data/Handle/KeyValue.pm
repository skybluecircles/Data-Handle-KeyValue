package Data::Handle::KeyValue;

use namespace::autoclean;

use Moose;
use MooseX::StrictConstructor;

__PACKAGE__->meta()->make_immutable();

1;

=pod

=head1 SYNOPSIS

=head1 DESCRIPTION

The subclasses of Data::Handle::KeyValue provide a consistent interface to fetch rows of hash refs from disparate data sources. This provide two main benefits:

=over 4

=item * Downstream code need not know about the source of your data

=item * You only need to remember one method: C<next_row>

=back

It also does most of the initial set up for you which you'd otherwise do with a module like Text::CSV or DBI.

For example, if you have a csv file whose header contains the column names, you just need to pass Data::Handle::KeyValue::CSV the path to your csv file and set header to true. It will read in first line and parse it for you.

The coding style uses self-explanatory attributes and variable names. Anyone reading your code should have a sense of what is going on. The code itself also aims to be straightforward.

Feedback and improvements are welcomed.

=head1 SUBCLASSES

=head2 ArrayRef

See L<Data::Handle::KeyValue::ArrayRef>

=head2 CSV

See L<Data::Handle::KeyValue::CSV>

=head2 SQLStatement

See L<Data::Handle::KeyValue::SQLStatement>

=cut
