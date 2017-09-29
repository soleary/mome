drop table payment_schedule;

create table payment_schedule(
     schedule INTEGER NOT NULL
    ,payment_date TEXT NOT NULL
);

insert into payment_schedule (schedule, payment_date)
values
     (1, '2017-09-25')
    ,(2, '2017-09-25')
    ,(2, '2018-02-15')
    ,(5, '2017-09-25')
    ,(5, '2017-11-15')
    ,(5, '2018-01-15')
    ,(5, '2018-03-15')
    ,(5, '2018-05-15')
    ,(9, '2017-09-25')
    ,(9, '2017-10-15')
    ,(9, '2017-11-15')
    ,(9, '2017-12-15')
    ,(9, '2018-01-15')
    ,(9, '2018-02-15')
    ,(9, '2018-03-15')
    ,(9, '2018-04-15')
    ,(9, '2018-05-15')
;
