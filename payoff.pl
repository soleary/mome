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

#my $total_tution = $dbh->prepare(qq{ select sum(tution) from parents; });
#my $total_paymets = $dbh->prepare(qq{ select sum(amount) from payments where validation is not null; });

$ARGV[0] //= '';

no warnings 'qw';
printf "%21s %9s %s %10s %10s %10s %s\n", qw[ Name Tuition P Invoiced Paid Payoff Email ];
use warnings;

foreach my $p ($parents->fetchall_arrayref()->@*) {
    my $email = $p->[2];
    my $plan = $p->[4];
    my $tuition = Math::Currency->new($p->[3]);
    my $name = $p->[1];

    $name =~ s/ /_/;

    my ($paid, $owe) = get_totals($email);
    my $payoff = $tuition - $paid;

    next if $ARGV[0] eq 'p' and $payoff <= 0;
    next if $ARGV[0] eq 'z' and $payoff > 0;

    printf "%21s %9s %s %10s %10s %10s %s\n", $name, $tuition, $plan, $owe, $paid, $payoff, $email;
}

sub get_totals {
    my $email = shift;

    $invoice_total->execute($email);
    $payment_total->execute($email);

    my $owe  = Math::Currency->new( ($invoice_total->fetchrow_array())[0] );
    my $paid = Math::Currency->new( ($payment_total->fetchrow_array())[0] );

    return $paid, $owe;
}
