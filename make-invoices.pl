#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;
use Math::Currency;

Math::Currency->format('USD');

my $DBFILE = 'sjm-2017-2018.sqlite';

my $DBH = DBI->connect("dbi:SQLite:dbname=$DBFILE",'','', { RaiseError => 1 });

my $BASE_URL = 'https://www.paypal.me/mrsolearymusic/';
# When not testing, $TESTING should be undef, so we get null's in the database
my $TESTING = 1;
my $DEBUG = 1;
my $DATE;

my $mk_invoice = $DBH->prepare(qq{
    insert into invoices(
        "First Name", "Last Name", "Email Address", total_tuition, payment_plan, amount, cash_amount, debit, paypal_amount, paypal_url, billing_date, testing, adjust
    ) values (?,?,?,?,?,?,?,?,?,?,?,?,?)
});

my $schedule_st = qq{ select payment_date, schedule from payment_schedule; };

my @sch_to_bill = prompt_for_schedules(build_schedule($schedule_st));

my $parents_st = qq{ select first_name, last_name, email, tuition, payment_schedule from parents; };
my $parents = $DBH->prepare($parents_st);
$parents->execute();

my $invoice_total = $DBH->prepare(qq{ select sum(debit) from invoices where "Email Address" = ?; });
my $payment_total = $DBH->prepare(qq{ select sum(amount) from payments where email = ? and validation is not null; });

my $last_invoice = $DBH->prepare(qq{ select total_tuition, payment_plan from invoices where "Email Address" = ? order by billing_date desc; });

printf "%25s, %9s %s %8s %7s %8s %8s %7s\n", qw[ Name Tuition P Balance Bill Total Paypal Fee ] if $DEBUG;
foreach my $p ($parents->fetchall_arrayref()->@*) {
    my $email = $p->[2];
    my $plan = $p->[4];

    my $balance = get_balance($email);
    my $bill_now = grep { $plan eq $_ } @sch_to_bill;

    # Negative balance means they owe, bill now means they are on a payment
    # plan that has a payment due now.
    unless ($balance < 0 or $bill_now) {
        next;
    }

    my $tuition = Math::Currency->new($p->[3]);
    my $cash = Math::Currency->new(0);

    if ($bill_now) {
        $cash = $tuition / $plan;
    }

    # A positive balance will be subtracted from the amount billed (cash)
    # A negative balance will be added to the amount billed.
    my $total = $cash - $balance;

    my $flag = $balance != 0 or check_last_invoice($email, $tuition, $plan);

    my $paypal = get_paypal_amount($total);
    my $url = $BASE_URL . $paypal->as_float();

    printf "%25s, %9s %s %8s %7s %8s %8s %7s\n", $p->[1], $tuition, $plan, $balance, $cash, $total, $paypal, $paypal - $total if $DEBUG;

    my @inv = @{$p}[0..2];

    push @inv, $tuition, $plan, $total->as_float(), $total, $cash->as_float(), $paypal, $url, $DATE, $TESTING, $flag;

    $last_invoice->finish();
    $mk_invoice->execute(@inv) unless $DEBUG;
}

sub check_last_invoice {
    my $email = shift;
    my $old_tuition = shift;
    my $old_plan = shift;

    $last_invoice->execute($email);
    my $inv = $last_invoice->fetchrow_hashref();

    $last_invoice->finish();

    return '' unless $inv;

    return $inv->{total_tuition} != $old_tuition or
           $inv->{payment_plan}  != $old_plan;
}

sub get_balance {
    my $email = shift;

    $invoice_total->execute($email);
    $payment_total->execute($email);

    my $owe  = Math::Currency->new( ($invoice_total->fetchrow_array())[0] );
    my $paid = Math::Currency->new( ($payment_total->fetchrow_array())[0] );

    # Positive balance means they owe, negative means they are ahead
    return $paid - $owe;
}

sub get_paypal_amount {
    my $cash = $_[0];

    my %amounts = (
        55.56 => Math::Currency->new(57.53),
    );

    if ($amounts{$cash->as_float}) {
        return $amounts{$cash->as_float()};
    } else {
        $cash += .30;
        return $cash / ( 1 - .029 );
    }
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
