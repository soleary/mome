create table family(
     id INTEGER PRIMARY KEY
    ,momefid integer not null
    ,session integer not null
    ,name text not null
    ,tuition integer
    ,plan integer
    ,permission text
    ,nobill text not null
    ,notes text
    ,testing text
);

/*
 * nobill values:
 * I  - Do not invoice
 * R  - Do not rate (free lessons)
 * B  - Don't do either
 * '' - Normal billing (nulls caused problems with looking up a value for statement generation)
 */

create table family_member(
     id INTEGER PRIMARY KEY
    ,momefid integer not null
    ,personid integer not null
    ,notes text
    ,testing text
);
