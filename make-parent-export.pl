#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;

my $dbfile = 'sjm-2017-2018.sqlite';

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile",'','');

my $parents_st = qq{
    select distinct
        parent_first_name,
        parent_last_name,
        parent_email,
        parent_phone_number,
        parent_address,
        payment_schedule
    from
        signups
    order by
        rowid
};

# Set up fields for cleanup subroutine
my $fnum = 0;
my @fields = qw(first last email phone address payment);
my %f = map { $_ => $fnum++ } @fields;

my $parents = $dbh->selectall_arrayref($parents_st);

#use Data::Dumper;
#print Dumper $parents;
#die;

my $ins_parents_st = qq{
    insert into parent_export(
        first_name,
        last_name,
        email,
        phone_number,
        address,
        payment_schedule
    ) values ( ?, ?, ?, ?, ?, ? );
};

my $ins_parents = $dbh->prepare($ins_parents_st);

foreach my $parent ($parents->@*) {
    $parent = process_parent($parent);
    $ins_parents->execute($parent->@*);
}

sub process_parent {
    my @rent = $_[0]->@*;

    foreach (@rent) {
        s/^\s+//;
        s/\s+$//;
    }

    $rent[$f{email}]   =   fix_email($rent[$f{email}]);
    $rent[$f{phone}]   =   fix_phone($rent[$f{phone}]);
    $rent[$f{payment}] = fix_payment($rent[$f{payment}]);

    return [ @rent ];
}

sub fix_email {
    my $email = lc($_[0]);
    return qq{=HYPERLINK("mailto:$email", "$email")};
}

sub fix_phone {
    my $num = $_[0];
    $num =~ s/\D//g;
    return substr($num, 0, 3) . '-' . substr($num, 3, 3) . '-' . substr($num, 6);
}

sub fix_payment {
    $_[0] =~ /^(\d)/;
    return $1;
}
