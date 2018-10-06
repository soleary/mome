
/*
 * paid-up
 * payment
 */

create table notification(
     id integer primary key
    ,momefid integer not null
    ,type text not null
    ,date text not null
    ,sentdate text
    ,superseded text
    ,notes text
    ,testing text
);
