create table payment_schedule(
     id integer primary key
    ,schedule integer not null
    ,date text not null
    ,number integer not null
);

insert into payment_schedule (schedule, date, number)
values
     (1, '2018-09-25', 1)
    ,(2, '2018-09-25', 1)
    ,(2, '2019-02-15', 2)
    ,(5, '2018-09-25', 1)
    ,(5, '2018-11-15', 2)
    ,(5, '2019-01-15', 3)
    ,(5, '2019-03-15', 4)
    ,(5, '2019-05-15', 5)
    ,(9, '2018-09-25', 1)
    ,(9, '2018-10-15', 2)
    ,(9, '2018-11-15', 3)
    ,(9, '2018-12-15', 4)
    ,(9, '2019-01-15', 5)
    ,(9, '2019-02-15', 6)
    ,(9, '2019-03-15', 7)
    ,(9, '2019-04-15', 8)
    ,(9, '2019-05-15', 9)
;
