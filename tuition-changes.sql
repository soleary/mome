select 
     "Email Address"
    ,invoice_date
    ,total_tuition 
from invoices 
where "Email Address" in (
    select 
        "Email Address" 
    from invoices 
    where invoice_date > '2017-10-01'
    group by "Email Address" 
    having count(distinct(total_tuition)) > 1) 
order by "Email Addess";
