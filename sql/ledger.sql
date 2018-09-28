/*
 * Ledger types -
 * debit
 * check
 * cash
 * paypal
 * adjustment
 */

create table ledger(
     id INTEGER PRIMARY KEY
    ,momefid integer not null
    ,amount text not null
    ,type text not null
    ,checknum text
    ,date text not null
    ,depositdate text
    ,validated text
    ,notes text
    ,testing text
);

create table additional_deposits(
     id INTEGER PRIMARY KEY
    ,amount text not null
    ,type text not null
    ,checknum text
    ,date text not null
    ,depositdate text
    ,validated text
);

