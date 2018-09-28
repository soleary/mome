/*
 * Active should only be set for the "current" session
 */

create table session(
     id INTEGER PRIMARY KEY
    ,name text not null
    ,active integer
);

insert into session (name, active) values ('2018-2019 School Year', 1);
insert into session (name, active) values ('Summer 2019', null);
