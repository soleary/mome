drop table if exists lesson_groups;
create table lesson_groups (
     id INTEGER PRIMARY KEY
    ,name text not null
    ,query text not null
    ,testing text
    ,notes text
);

insert into lesson_groups (id, name, query) values
     (1,  "4th Grade Violin", "grade = 4 and instrument = 'Violin'")
    ,(2,  "6th-8th Grade Violin", "grade > 5 and instrument = 'Violin'")
    ,(3,  "4th Grade Ukulele", "grade = 4 and instrument = 'Ukulele'")
    ,(4,  "5th Grade Ukulele", "grade = 5 and instrument = 'Ukulele'")
    ,(5,  "6th Grade Ukulele", "grade = 6 and instrument = 'Ukulele'")
    ,(6,  "4th Grade Flute", "grade = 4 and instrument = 'Flute'")
    ,(7,  "4th Grade Clarinet", "grade = 4 and instrument = 'Clarinet'")
    ,(8,  "4th Grade Alto Sax", "grade = 4 and instrument = 'Alto Saxophone'")
    ,(9,  "4th Grade Trumpet", "grade = 4 and instrument = 'Trumpet'")
    ,(10, "4th Grade Trombone", "grade = 4 and instrument = 'Trombone'")
    ,(11, "4th Grade Percussion", "grade = 4 and instrument = 'Percussion'")
    ,(12, "5th Grade Flute", "grade = 5 and instrument = 'Flute'")
    ,(13, "5th Grade Clarinet and Alto Sax", "grade = 5 and (instrument = 'Clarinet' or instrument = 'Alto Saxophone')")
    ,(14, "5th Grade French Horn", "grade = 5 and instrument = 'French Horn'")
    ,(15, "5th Grade Trumpet", "grade = 5 and instrument = 'Trumpet'")
    ,(16, "5th Grade Percussion", "grade = 5 and instrument = 'Percussion'")
    ,(17, "Advanced Band Flute", "class = 'Advanced Band' and instrument = 'Flute'")
    ,(18, "Advanced Band Clarinet", "class = 'Advanced Band' and instrument = 'Clarinet'")
    ,(19, "Advanced Band Alto and Tenor Sax", "(class = 'Advanced Band' and instrument in ('Alto Saxophone', 'Tenor Saxophone')) or momefid = 100")
    ,(20, "Advanced Band Trumpet", "class = 'Advanced Band' and instrument = 'Trumpet'")
    ,(21, "Advanced Band Percussion", "class = 'Advanced Band' and instrument = 'Percussion'")
;
