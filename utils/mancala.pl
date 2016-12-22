use utf8;

my @n;

while (<>) {
   chomp;
   s/&/&amp;/;
   if (/^([^[]+)(\[[^<>~]+)(.*)$/) {
       my @names    = split /\//, $1;
       my $scope    = $2;
       my $links    = $3;
       my %node     = {};
       $node{names} = \@names;
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
       $links =~ s/\s~/;~/;
       $links =~ s/\s</;</;
       $links =~ s/\s>/;>/;
       my @links = split /;/, $links;
       $node{links} = \@links;
       $n[@n] = \%node;
   }
}

print "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
print "<games>\n";

foreach my $node (@n) {
   my $nr = @$node{names};
   print " <game>\n";
   foreach my $name(@$nr) {
       $name =~ s/^\s+//;
       $name =~ s/\s+$//;
       print "  <name>$name</name>\n";
   }
   my $rr = @$node{regions};
   foreach my $name(@$rr) {
       $name =~ s/^\s+//;
       $name =~ s/\s+$//;
       print "  <region>$name</region>\n";
   }
   my $lr = @$node{links};
   foreach my $name(@$lr) {
       $name =~ s/^\s+//;
       $name =~ s/\s+$//;
       if ($name =~ /^<\s*(.*)$/) {
           print "  <parent>$1</parent>\n";
       }
       if ($name =~ /^>\s*(.*)$/) {
           print "  <child>$1</child>\n";
       }
       if ($name =~ /^~\s*(.*)$/) {
           print "  <related>$1</related>\n";
       }
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
