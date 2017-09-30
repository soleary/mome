#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;

my $DBFILE = 'sjm-2017-2018.sqlite';

my $dbh = DBI->connect("dbi:SQLite:dbname=$DBFILE",'','', { RaiseError => 1 });

my $payments_st = q{
    select rowid, email, type, amount, date from payments where testing is null and validation is null order by rowid;
};

my $emails_st = q{ select email from payments where testing is null and validation is null order by rowid; };

my $parents = $dbh->selectall_hashref('select * from parents', 'email');
my $payments = $dbh->selectall_hashref($payments_st, 'email');
my $validate = $dbh->prepare('update payments set validation = 1 where rowid = ?');

foreach my $email ($dbh->selectcol_arrayref($emails_st)->@*) {
    my @parent_fields = qw[ email first_name last_name ];
    my @payment_fields = qw[ type amount ];
    printf "%s %s %s : %s \$%.2f [Y/N]: ", @{$parents->{$email}}{@parent_fields}, @{$payments->{$email}}{@payment_fields};

    chomp( my $key = <STDIN> );
    if ($key =~ /y/i) {
        $validate->execute($payments->{$email}{rowid});
    }
}
