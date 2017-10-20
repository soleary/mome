select 
     "Email Address"
    ,total_tuition 
from invoices 
where "Email Address" in (
    select 
        "Email Address" 
    from invoices 
    group by "Email Address" 
    having count(distinct(total_tuition)) > 1) 
order by "Email Addess";
