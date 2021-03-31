use strict;
use warnings;

use List::MoreUtils qw(part);

use Data::Dumper;

my @array = 1..9;
my $partitions = 3;

my $i = 0;

print Dumper part {$partitions * $i++ / @array} @array;
