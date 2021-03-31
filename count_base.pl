#!/usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;
my $string;
my %count;
my $length;
my $seqin = Bio::SeqIO ->new('-format' => 'fasta' , -file => 'gap.fa');
while(my $seq = $seqin->next_seq) {
    $string = uc($seq->seq);
    # do stuff with $string
    print "$string\n";

    # check length of sequece
    $length = $seq->length;
    $count{$_}++ foreach split //, $string; # count bases
    print "$_\n" for @count{qw(A C G T)};
    undef %count;
}

#print %count;
#print "$_\n" for @count{qw(A C G T)};
