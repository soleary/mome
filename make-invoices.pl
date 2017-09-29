#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;
use Math::Currency;

Math::Currency->format('USD');

my $DBFILE = 'sjm-2017-2018.sqlite';

my $DBH = DBI->connect("dbi:SQLite:dbname=$DBFILE",'','', { RaiseError => 1 });

my $BASE_URL = 'https://www.paypal.me/mrsolearymusic/';
my $TESTING = 1;
my $DATE;

my $mk_invoice = $DBH->prepare(qq{
    insert into invoices(
        "First Name", "Last Name", "Email Address", total_tuition, payment_plan, cash_amount, paypal_amount, paypal_url, billing_date, testing
    ) values (?,?,?,?,?,?,?,?,?,?)
});

my $schedule_st = qq{ select payment_date, schedule from payment_schedule; };

my %schedule = build_schedule($schedule_st);

#my $sch = $DBH->quote( join ',',  prompt_for_schedules(%schedule) );
my $sch = join ',',  prompt_for_schedules(%schedule);

my $parents_st = qq{ select first_name, last_name, email, tuition, payment_schedule from parents where payment_schedule in ($sch); };
my $parents = $DBH->prepare($parents_st);
$parents->execute();

#my $TODAY = DateTime->now()->ymd();

foreach my $p ($parents->fetchall_arrayref()->@*) {
    my $tuition = Math::Currency->new($p->[3]);
    my $plan = $p->[4];

    my $cash = $tuition / $plan;
    my $paypal = get_paypal_amount($cash);
    my $url = $BASE_URL . $paypal->as_float();
    #printf "%15s, %9s %s %7s %7s %5s\n", $p->[1], $tuition, $plan, $cash, $paypal, $paypal - $cash;

    my @inv = @{$p}[0..2];

    push @inv, $tuition, $plan, $cash, $paypal, $url, $DATE, $TESTING;

    #$mk_invoice->execute(@inv);
}

sub get_paypal_amount {
    my $cash = $_[0];
    my $surcharge = $cash * .029 + .3;
    return $cash + $surcharge;
}

sub prompt_for_schedules {
    my %schedule = @_;

    my @dates = sort keys %schedule;
    my ($i, $ans);

    say "Invoice which date?";
    foreach my $date (@dates) {
        printf "%2d. %s\n", ++$i, $date;
    }
    print "? ";

    chomp( $ans = <STDIN> );
    die unless $ans;

    #XXX: HACK
    $DATE = $dates[$ans - 1];

    return $schedule{$dates[ $ans - 1 ]}->@*;
}

sub build_schedule {
    my $st = $DBH->prepare($_[0]);

    $st->execute();

    my %schedule = ();
    foreach my $sh ($st->fetchall_arrayref()->@*) {
        my ($date, $sch) = $sh->@*;
        push $schedule{$date}->@*, $sch;
    }

    return %schedule;
}
