#!/bin/perl -l

my @array = (1,2,3,4,5,6,7,8,9);

print join ",", @array[0..2];
print join ",", @array[3..5];
print join ",", @array[6..$#array];
