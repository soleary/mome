/*
 * Person types -
 * parent
 * student
 * payer
 */

create table person(
     id INTEGER PRIMARY KEY
    ,type text not null
    ,firstname text not null
    ,lastname text not null
    ,phone integer
    ,email text
    ,address text
    ,homeroom text
    ,grade text
    ,notes text
    ,testing text
);
