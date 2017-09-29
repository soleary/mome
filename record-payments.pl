#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;
use Math::Currency;
use Term::ReadKey;

$|++;

my $TEST = 1;

Math::Currency->format('USD');

my $DBFILE = 'sjm-2017-2018.sqlite';

my $dbh = DBI->connect("dbi:SQLite:dbname=$DBFILE",'','', { RaiseError => 1 });

my $email_search = $dbh->prepare( qq{ select email, first_name, last_name from parents where first_name like ? or last_name like ? or email like ?; } );
#my $payment =

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

    my $email = prompt( 'Select parent for payment:', build_parent_hash(@search));

    next unless $email;

    use Data::Dumper;
    print Dumper $email;

    my %payment_types = (
        p => { d => 'PayPal' },
        k => { d => 'Check' },
        c => { d => 'Cash', c   => sub { print 'Enter Check Numnber; '; return 'check #' . <STDIN>; }
    );

    my $type = prompt( 'Payment type:', %payment_types);
}

sub prompt {
    my $prompt = shift;

    # Don't actually prompt if there's only one prompt and value
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
        foreach my $k (keys %items) {
            printf "%2d. %s\n", $k, $items{$k}{d};
        }
        while (not defined ($key = ReadKey(-1))) {}
    } until
        ($items{$key}{v} or $key eq 'q');

    ReadMode 0;

    if ($items{$key}{c}) {
        $items{$key}{v} = $items{$keys}{c}->($items{$key}{v});
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
        $values{$i}{v} = $rent->[0];
    }

    return %values;
}
