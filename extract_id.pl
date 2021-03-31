#!/usr/bin/perl
use strict;
use warnings;
use Bio::DB::Fasta;
use Bio::SeqIO;
use Bio::Index::Fasta;
$ENV{BIOPERL_INDEX_TYPE} = "SDBM_File";

#look for the index in the current directory

$ENV{BIOPERL_INDEX} = ".";

my $file_name = "gap.fa";
my $inx = Bio::Index::Fasta->new( -filename => $file_name . ".idx",
                                  -write_flag => 1 );

# pass a reference to the critical function to the Bio::Index object
$inx->id_parser(&get_id);
