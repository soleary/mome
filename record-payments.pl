#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;
use Math::Currency;
use Term::ReadKey;
use DateTime;

$|++;

my $TESTING;
my $TODAY = DateTime->now()->ymd();

Math::Currency->format('USD');

my $DBFILE = 'sjm-2017-2018.sqlite';

my $dbh = DBI->connect("dbi:SQLite:dbname=$DBFILE",'','', { RaiseError => 1 });

my $email_search = $dbh->prepare( qq{ select email, first_name, last_name from parents where first_name like ? or last_name like ? or email like ?; } );
my $payment = $dbh->prepare(qq{ insert into payments( email, type, amount, date, testing ) values (?,?,?,?,?); });

while (1) {
    print "Search term: ";

    my $term = <STDIN>;
    chomp $term;

    last if $term =~ /^q$/i;
    next if $term eq '';

    my @terms = ("%$term%") x 3;

    $email_search->execute(@terms);

    my @search = $email_search->fetchall_arrayref()->@*;

    if (@search == 0) {
        print "No results returned.\n";
        next;
    }

    my $parent = prompt( 'Select parent for payment:', build_parent_hash(@search));

    my ($email, $fname, $lname) = $parent->@*;

    next unless $email;

    my %payment_types = (
        p => { d => 'PayPal' },
        c => { d => 'Cash' },
        k => { d => 'Check', c => sub {print 'Enter Check Numnber; '; chomp(my $r = <STDIN>); return "check $r";} },
    );

    my $type = prompt( 'Payment type:', %payment_types);

    print "Amount: ";
    chomp(my $amount = <STDIN>);
    $amount = Math::Currency->new($amount);

    say "Payment OK?";
    printf "%s %s %s : %s \$%.2f\n", $email, $fname, $lname, $type, $amount->as_float();
    print "[Y/N]: ";
    chomp( my $resp = <STDIN> );

    next unless $resp =~ /y/i;

    $payment->execute($email, $type, $amount->as_float(), $TODAY, $TESTING);
}

sub prompt {
    my $prompt = shift;

    # Don't actually prompt if there's only one value
    if (@_ == 2) {
        return $_[1]->{v};
    }

    my %items = @_;

    # Add values if they aren't in %items
    foreach my $k (keys %items) {
        next if $items{$k}{v};
        $items{$k}{v} = lc $items{$k}{d};
    }

    ReadMode 4;

    my $key;
    do {
        say $prompt;
        foreach my $k (sort keys %items) {
            printf "%2s. %s\n", $k, $items{$k}{d};
        }
        while (not defined ($key = ReadKey(-1))) {}
    } until
        ($items{$key}{v} or $key eq 'q');

    ReadMode 0;

    if ($items{$key}{c}) {
        $items{$key}{v} = $items{$key}{c}->($items{$key}{v});
    }

    return $items{$key}{v};
}

sub build_parent_hash {
    my @rents = @_;

    my %values = ();

    my $i;
    foreach my $rent (@rents) {
        $i++;
        $values{$i}{d} = sprintf '%-28s %s %s', $rent->@*;
        $values{$i}{v} = [ $rent->@* ];
    }

    return %values;
}
