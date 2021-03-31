#!/usr/bin/perl
import collections
from Bio import SeqIO
from Bio.SeqUtils.ProtParam import ProteinAnalysis

all_aas = collections.defaultdict(int)
