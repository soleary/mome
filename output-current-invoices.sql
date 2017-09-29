.mode tabs
.headers on
.output "current-invoices.tsv"
select * from invoices where testing is not '1' and invoice_date is null;
