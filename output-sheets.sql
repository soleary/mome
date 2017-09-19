.mode csv
.header on
.output parents-export.csv
select * from parent_export;
.output students-export.csv
select * from student_export;
