#!/usr/bin/env perl

use Modern::Perl '2017';
use autodie;

use DBI;

my $dbfile = 'sjm-2017-2018.sqlite';

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile",'','');

my $fnum = 0;
my @fields = qw(first last homeroom ins1 class1 ins2 class2 ins3 class3);
my %f = map { $_ => $fnum++ } @fields;

my $students_st = qq{
    select
        student_first_name,
        student_last_name,
        student_section,
        instrument_1,
        class_1,
        instrument_2,
        class_2,
        instrument_3,
        class_3
    from
        signups
};

my $students = $dbh->selectall_arrayref($students_st);

#use Data::Dumper;
#print Dumper $students;
#die;

my $ins_student_st = qq{
    insert into students(
        first_name,
        last_name,
        homeroom,
        class,
        instrument
        ) values (?, ?, ?, ?, ?);
};

my $ins_student = $dbh->prepare($ins_student_st);

# my @fields = qw(first last homeroom ins1 class1 ins2 class2 ins3 class3);
foreach my $student ($students->@*) {
    $student = clean_student($student);
    foreach my $sec (1..3) {
        if ( $student->[$f{"ins$sec"}] or $student->[$f{"class$sec"}] ) {
            my $stu = [
                $student->[$f{first}],
                $student->[$f{last}],
                $student->[$f{homeroom}],
                $student->[$f{"class$sec"}],
                $student->[$f{"ins$sec"}],
            ];
            $ins_student->execute($stu->@*);
        }
    }
}

sub clean_student {
    my @st = $_[0]->@*;

    foreach (@st) {
        s/\(.+\)//;
        s/^\s+//;
        s/\s+$//;
    }

    return [ @st ];
}
