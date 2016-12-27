use utf8;

my @n;
my %p;
my %c;
my %r;
my %s;

sub addLink {
  my ($a, $b) = @_;
  if ($b =~ /([~<>])(.*)/) {
      my $t = $1;
      my $n = $2;
      $a =~ s/^\s+//;
      $n =~ s/^\s+//;
      $a =~ s/\s+$//;
      $n =~ s/\s+$//;
      $p{$a} = 1;
      $p{$n} = 1;
      if ($t eq '~') {
          if ($r{$a}) {
              $r{$a} .= ',';
          }
          $r{$a} .= $n;
      }
      if ($t eq '<') {
          if ($c{$a}) {
              $c{$a} .= ',';
          }
          $c{$a} .= $n;
      }
      if ($t eq '>') {
          if ($c{$n}) {
              $c{$n} .= ',';
          }
          $c{$n} .= $a;
      }
  }
}

while (<>) {
   chomp;
   s/&/&amp;/;
   if (/^([^[]+)(\[[^<>~]+)(.*)$/) {
       my @names    = split /\//, $1;
       my $scope    = $2;
       my $links    = $3;
       my %node     = {};
       $node{names} = \@names;
       my $nm;
       foreach my $name(@names) {
          $name =~ s/^\s+//;
          $name =~ s/\s+$//;
          if (!$nm) {
              $nm = $name;
          } else {
              $s{$name} = $nm;
          }
       }
       if ($scope =~ /\[(\D[^\]]+)\]/) {
           my @regions = split /\/|,|;/, $1;
           $node{regions} = \@regions;
       }
       if ($scope =~ /\[\s*(\d+),\s*([^]]+)\]/) {
           $node{date}      = $1;
           $node{described} = $2;
       }
       if ($scope =~ /\((\d+x\S+)\s*([^)]*)\)/) {
           $node{setup}     = $1;
           $node{type}      = $2;
       }
       if ($scope =~ /\((\d(-\d)?)\)/) {
           $node{players}   = $1;
       }
       $links =~ s/\s~/;~/g;
       $links =~ s/\s</;</g;
       $links =~ s/\s>/;>/g;
       my @links = split /;/, $links;
       foreach my $l (@links) {
          addLink($names[0], $l);
       }
       $n[@n] = \%node;
   }
}

print "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
print "<games>\n";

foreach my $node (@n) {
   my $nr = @$node{names};
   my $fl;
   foreach my $name(@$nr) {
       $name =~ s/^\s+//;
       $name =~ s/\s+$//;
       if ($p{$name}) { $fl = 1; }
   }
   if (!$fl) { next; }
   my $pr = "";
   my $rl = "";
   print " <game>\n";
   foreach my $name(@$nr) {
       $name =~ s/^\s+//;
       $name =~ s/\s+$//;
       print "  <name>$name</name>\n";
       if ($c{$name}) {
           $pr = $c{$name};
       }
       if ($r{$name}) {
           $rl = $r{$name};
       }
   }
   if ($pr) {
       my @l = split /,/, $pr;
       foreach my $l(@l) {
          $l =~ s/^\s+//;
          $l =~ s/\s+$//;
          if ($s{$l}) {
              $l = $s{$l};
          }
          print "  <parent>$l</parent>\n";
       }
   }
   if ($rl) {
       my @l = split /,/, $rl;
       foreach my $l(@l) {
          $l =~ s/^\s+//;
          $l =~ s/\s+$//;
          if ($s{$l}) {
              $l = $s{$l};
          }
          print "  <related>$l</related>\n";
       }
   }
   my $rr = @$node{regions};
   foreach my $name(@$rr) {
       $name =~ s/^\s+//;
       $name =~ s/\s+$//;
       print "  <region>$name</region>\n";
   }
   if ($node->{described}) {
       print "  <described>$node->{described}</described>\n";
       print "  <date>$node->{date}</date>\n";
   }
   if ($node->{type}) {
       print "  <type>$node->{type}</type>\n";
   }
   if ($node->{setup}) {
       print "  <setup>$node->{setup}</setup>\n";
   }
   if ($node->{players}) {
       print "  <players>$node->{players}</players>\n";
   }
 
   print " </game>\n";
}

print "</games>\n";
