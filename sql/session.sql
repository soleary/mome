/*
 * Active should only be set for the "current" session
 */

drop table if exists session;

create table session(
     id INTEGER PRIMARY KEY
    ,name text not null
    ,active integer
);

insert into session (name, active) values ('2018-2019 School Year', null);
insert into session (name, active) values ('2019-2020 School Year', 1);
