select first_name, last_name, parents.email, invoices.billing_date, invoices.amount, payments.date, payments.amount, payments.type from invoices left join payments on invoices."Email Address" = payments.email outer left join parents on parents.email = invoices."Email Address" where payments.amount is null;
