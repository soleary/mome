#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use lib 'lib';

use My::Google::Sheets;

my $service = My::Google::Sheets->new();

