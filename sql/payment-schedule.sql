create table payment_schedule(
     schedule integer not null
    ,date text not null
    ,number integer not null
);

insert into payment_schedule (schedule, date, number)
values
     (1, '2018-09', 1)
    ,(2, '2018-09', 1)
    ,(2, '2019-02', 2)
    ,(5, '2018-09', 1)
    ,(5, '2018-11', 2)
    ,(5, '2019-01', 3)
    ,(5, '2019-03', 4)
    ,(5, '2019-05', 5)
    ,(9, '2018-09', 1)
    ,(9, '2018-10', 2)
    ,(9, '2018-11', 3)
    ,(9, '2018-12', 4)
    ,(9, '2019-01', 5)
    ,(9, '2019-02', 6)
    ,(9, '2019-03', 7)
    ,(9, '2019-04', 8)
    ,(9, '2019-05', 9)
;
