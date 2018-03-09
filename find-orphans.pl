#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;

my $DBFILE = 'sjm-2017-2018.sqlite';

my $dbh = DBI->connect("dbi:SQLite:dbname=$DBFILE",'','', { RaiseError => 1 });

# Key tables
# Each email address should occur at least once in each.
# If they aren't something is lost and will need to be linked.
my @list = (
    qq{ select distinct email from parents; },
    qq{ select distinct "Email Address" from invoices; },
    qq{ select distinct email from payments; },
);

@list = map { $dbh->prepare($_) } @list;

my %counts = ();
foreach my $sth (@list) {
    my $x = $dbh->selectcol_arrayref($sth);

    map { $counts{$_}++ } $x->@*;
}

my @orphans = grep { $counts{$_} < @list } sort keys %counts;

if (@orphans) {
    print "Found these orphans:\n";
    use Data::Dumper;
    print Dumper \@orphans;
} else {
    exit 0;
}
