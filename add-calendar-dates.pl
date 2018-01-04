#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DateTime;
use DBI;

my $dbfile = 'sjm-2017-2018.sqlite';
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile",'','', { RaiseError => 1 });

my @fields = qw( date type note );

$" = ',';
my $add_cal_sth = $dbh->prepare(qq{insert into calendar (@fields) values (?,?,?);});


my $year = DateTime->today()->year();

while (1) {
    my @date = ();

    foreach my $field (@fields) {
        my $val;
        do {
            print ucfirst "$field: ";
            $val = <STDIN>;
            chomp $val;
        } while ( $val eq '' );

        if ($field eq 'date') {
            $val = "$year-$val" unless $val =~ /^\d{4}/;
        }

        push @date, $val;
    }

    $add_cal_sth->execute(@date);
}
