@string = ("ATTTG");
foreach $a (@string) {
  print $_;
  if ($a =~ /([AT])/g){
    print $a;
  }
}
