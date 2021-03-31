#!/usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;

my @seq_array=();
my $line_rm;
my $i;
my $j;
my $k;
my $base;
my $length;
my $string;
my $count;
my $countA;
my $N_seq;
my @col=();
my @colA=();
my $nt;
my $seqin = Bio::SeqIO ->new('-format' => 'fasta' , -file => 'hmmSnf2-E-120-trim.fa');
while(my $seq = $seqin->next_seq) {
    $string = uc($seq->seq);
    # do stuff with $string
    #print "$string\n";

    # number of sequences
    $N_seq++;
    # check length of sequece
    $length = $seq->length;
    for $i (0..length($string)-1){
      $base = substr($string, $i, 1);
      #print "Index: $i, Text: $base \n";
      push(@seq_array,$base);
    }
}
# number of sequences
#print $N_seq;
# print "@seq_array\n";
# add base to array
for ($j = 0; $j < $length; $j++){
  $count = 0;
  $countA = 0;
  for ($i = $j; $i < scalar(@seq_array); $i+=$length){
        #print "$seq_array[$i]";
        if ("$seq_array[$i]" eq "-"){
          ++$count;
        }
        elsif ("$seq_array[$i]" =~ /([GPAVLIMCFYWHKRQNEDST])/g){
          ++$countA;
        }
    }

  #print "$count\n";
  #print "$countA\n";
  if ($count == 1){
    for ($i = $j; $i < scalar(@seq_array); $i+=$length){
        push(@col,$seq_array[$i]);
    }
  }
  elsif ($countA == 1){
    for ($i = $j; $i < scalar(@seq_array); $i+=$length){
        push(@colA,$seq_array[$i]);
  }
  }
}
#print "@col\n";
#print "@colA\n";
#print scalar(@col);
#change line remove to 0
for ($k = 0; $k < scalar(@col); $k+=$N_seq){
    #print $k;
    for $i (0..$N_seq-1){
        #print $i;
        if ($col[$i] eq "."){
          splice (@seq_array, $i*$length,$length,("0")x20);
        }
    }
}

for ($k = 0; $k < scalar(@colA); $k+=$N_seq){
    #print $k;
    for $i (0..$N_seq-1){
        #print $i;
        if ($colA[$i+$k] =~ /([GPAVLIMCFYWHKRQNEDST])/g){
          #print $colA[$i+$k];
          #print $i;
          splice (@seq_array, $i*$length,$length,("0")x20);
        }
    }
}
#print "@seq_array\n";
@seq_array = grep !/0/, @seq_array;
#print "@seq_array\n";


for ($i = 0; $i < scalar(@seq_array); $i+=$length){
  print (">\n");
  print join ("",@seq_array[$i..$i+$length-1],"\n");
}
