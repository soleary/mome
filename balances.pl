#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;
use Math::Currency;

Math::Currency->format('USD');

my $DBFILE = 'sjm-2017-2018.sqlite';

my $dbh = DBI->connect("dbi:SQLite:dbname=$DBFILE",'','', { RaiseError => 1 });

my $parents_st = qq{ select first_name, last_name, email, tuition, payment_schedule from parents order by last_name; };
my $parents = $dbh->prepare($parents_st);
$parents->execute();

my $invoice_total = $dbh->prepare(qq{ select sum(debit) from invoices where "Email Address" = ?; });
my $payment_total = $dbh->prepare(qq{ select sum(amount) from payments where email = ? and validation is not null; });

my $invoices = $dbh->prepare(qq{ select count(debit) from invoices where "Email Address" = ?; });
my $payments = $dbh->prepare(qq{ select count(amount) from payments where email = ? and validation is not null and type != 'adjustment'; });

$ARGV[0] //= '';

no warnings 'qw';
printf "%21s %9s %s %10s %s %10s %s %8s %s %s\n", qw[ Name Tuition P Invoiced # Paid # Balance S Email ];
use warnings;

foreach my $p ($parents->fetchall_arrayref()->@*) {
    my $email = $p->[2];
    my $plan = $p->[4];
    my $tuition = Math::Currency->new($p->[3]);
    my $name = $p->[1];

    $name =~ s/ /_/;

    my ($paid, $owe) = get_totals($email);
    my $balance = $paid - $owe;

    my ($pmts, $invs) = get_counts($email);

    next if $ARGV[0] eq 'n' and $balance >= 0;
    next if $ARGV[0] eq 'p' and $balance <= 0;
    next if $ARGV[0] eq 'z' and $balance != 0;

    my $status;
    if ($paid == $tuition) {
        $status = '*';
    } elsif ($owe > $paid) {
        $status = '-';
    } elsif ($owe < $paid) {
        $status = '+';
    } elsif ($owe == $paid) {
        $status = '=';
    } else {
        # Can't happen
        die "I don't know how I got here\n";
    }

    printf "%21s %9s %s %10s %s %10s %s %8s %s %s\n", $name, $tuition, $plan, $owe, $invs, $paid, $pmts, $balance, $status, $email;
}

sub get_totals {
    my $email = shift;

    $invoice_total->execute($email);
    $payment_total->execute($email);

    my $owe  = Math::Currency->new( ($invoice_total->fetchrow_array())[0] );
    my $paid = Math::Currency->new( ($payment_total->fetchrow_array())[0] );

    return $paid, $owe;
}

sub get_counts {
    my $email = shift;

    $invoices->execute($email);
    $payments->execute($email);

    return $payments->fetchrow_array(), $invoices->fetchrow_array();
}
