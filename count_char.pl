use warnings;
use strict;

my $str = "ATTTG";
my $count = () = $str =~ /([AT])/g;
print "count<$count> in <$str>\n";
