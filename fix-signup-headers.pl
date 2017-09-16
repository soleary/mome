#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

our $^I = '.bak';

my $headers = 1;

while (<ARGV>) {
    chomp;
    if ($headers) {
        print fix_headers($_);
        $headers = 0;
    } else {
        print "$_\n";
    }
}

sub fix_headers {
    my @fields = split /\t/, $_[0];

    # Last field is unused
    delete $fields[-1];

    $fields[-1] = 'student section';

    foreach (@fields) {
        tr/[A-Z]/[a-z]/;
        s/\(.+\)//;
        s/\s+$//;
        s/^\s+//;
        s/ /_/g;
    }

    $fields[-1] = $fields[-1] . "\n";

    return join "\t", @fields
}
