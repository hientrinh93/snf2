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

my $seqin = Bio::SeqIO ->new('-format' => 'fasta' , -file => 'hmmSnf2-E-120-trim.fa');
while(my $seq = $seqin->next_seq) {
    $string = uc($seq->seq);
    # do stuff with $string
    # number of sequences
    $N_seq++;
    # check length of sequece
    $length = $seq->length;
    for $i (0..length($string)-1){
      $base = substr($string, $i, 1);
      push(@seq_array,$base);
    }
}

# add base to array
for ($j = 0; $j < $length; $j++){
  $count = 0;
  $countA = 0;
  for ($i = $j; $i < scalar(@seq_array); $i+=$length){
        if ("$seq_array[$i]" eq "-"){
          ++$count;
        }
        elsif ("$seq_array[$i]" =~ /([GPAVLIMCFYWHKRQNEDST])/g){
          ++$countA;
        }
    }

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

for ($k = 0; $k < scalar(@col); $k+=$N_seq){
    for $i (0..$N_seq-1){
        if ($col[$i] eq "."){
          splice (@seq_array, $i*$length,$length,("0")x20);
        }
    }
}

for ($k = 0; $k < scalar(@colA); $k+=$N_seq){
    for $i (0..$N_seq-1){
        if ($colA[$i+$k] =~ /([GPAVLIMCFYWHKRQNEDST])/g){
          splice (@seq_array, $i*$length,$length,("0")x20);
        }
    }
}

@seq_array = grep !/0/, @seq_array;
for ($i = 0; $i < scalar(@seq_array); $i+=$length){
  print (">\n");
  print join ("",@seq_array[$i..$i+$length-1],"\n");
}
