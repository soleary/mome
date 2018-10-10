create table invoice(
     id INTEGER PRIMARY KEY
    ,personid integer not null
    ,session integer not null
    ,amount text not null
    ,paypal text not null
    ,date text not null
    ,duedate text not null
    ,sentdate text
    ,donotsend text
    ,notes text
    ,testing text
);
