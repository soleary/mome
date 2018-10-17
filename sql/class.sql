/*
 * Band
 * Advanced Band
 * Jazz Band
 * Ukulele 
 * Orchestra
 */

create table class_member(
     id INTEGER PRIMARY KEY
    ,personid integer not null
    ,class text not null
    ,instrument text not null
    ,scheduled text
    ,experience text
    ,day integer not null
    ,testing text
);
