create table family(
     id INTEGER PRIMARY KEY
    ,momefid integer not null
    ,session integer not null
    ,name text not null
    ,tuition integer
    ,plan integer
    ,permission text
    ,nobill text
    ,notes text
    ,testing text
);

create table family_member(
     id INTEGER PRIMARY KEY
    ,momefid integer not null
    ,personid integer not null
    ,testing text
);
