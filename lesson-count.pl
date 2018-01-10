#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;
use Date::Simple;

my $dbfile = 'sjm-2017-2018.sqlite';
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile",'','', { RaiseError => 1 });

my $start = (get_dates($dbh, 'start'))[0];
my $end   = (get_dates($dbh, 'end'  ))[0];

my @off_days = get_dates($dbh, 'holiday');
push @off_days, get_dates($dbh, 'sick');

my @added_days = get_dates($dbh, 'add');

my @days = qw( Sunday Monday Tuesday Wednesday Thursday Friday Saturday );

my %days = map { $_ => 0 } @days;

my $date = Date::Simple->new($start);

while ($date <= $end) {
    my $day = $date->day_of_week();
    next if $day == 0 or $day == 6;
    next if grep { $_ == $date } @off_days;
    next if $day == 5 and not grep { $_ == $date } @added_days;

    $days{$days[$day]}++;
} continue {
    $date = $date->next();
}

# Trim off weekends, since we don't need 'em
shift @days;
pop @days;

foreach my $day (@days) {
    printf "% 9s:%s\n", $day, $days{$day};
}

sub get_dates {
    my $dbh  = shift;
    my $type = shift;

    my @ret = map { @$_ } $dbh->selectall_arrayref(qq{select date from calendar where type = '$type'});

    return map { @$_ } @ret;
}
