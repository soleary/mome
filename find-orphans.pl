#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;

my $DBFILE = 'sjm-2017-2018.sqlite';

my $dbh = DBI->connect("dbi:SQLite:dbname=$DBFILE",'','', { RaiseError => 1 });

# Key tables
# Each email address should occur at least once in each.
# If they aren't something is lost and will need to be linked.
my @lists = (
    qq{ select distinct email from parents; },
    qq{ select distinct "Email Address" from invoices; },
    qq{ select distinct email from payments; },
);

@lists = map { $dbh->prepare($_) } @lists;

my %counts = ();
foreach my $sth (@lists) {
    my $addrs = $dbh->selectcol_arrayref($sth);

    map { $counts{$_}++ } $addrs->@*;
}

my @orphans = grep { $counts{$_} < @lists } sort keys %counts;

if (@orphans) {
    print "Found these orphans:\n";
    use Data::Dumper;
    print Dumper \@orphans;
} else {
    exit 0;
}
