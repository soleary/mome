drop view if exists payment;
create view payment as
    select * from ledger
    where (type != 'debit' or type != 'adjustment')
        and validated is not null;

drop view if exists adjusted_payment;
create view adjusted_payment as
    select * from ledger
    where type != 'debit'
        and validated is not null;

drop view if exists debit;
create view debit as
    select * from ledger
    where type = 'debit';

drop view if exists clean_ledger;
create view clean_ledger as
        select * from adjusted_payment
    union
        select * from debit;

drop view if exists balance;
create view balance as
    select l.momefid, f.name, sum(l.amount) as balance
    from clean_ledger as l, family as f
    where l.momefid = f.momefid
    group by l.momefid;

drop view if exists deposits;
create view deposits as
        select type, momefid, checknum, amount
        from clean_ledger
        where depositdate is null and type != 'debit'
    union
        select type, '0', checknum, amount
        from additional_deposits
        where depositdate is null;

drop view if exists deposit_slip;
create view deposit_slip as
        select type, count(type) as count, sum(amount) as amount
            from deposits
            group by type
    union
        select 'Total', count(*), sum(amount) from deposits where type != 'paypal'
    union
        select 'Grand Total', count(*), sum(amount) from deposits
    order by type desc;

drop view if exists student_roster;
create view student_roster as
    select p.firstname, p.lastname, p.grade, p.id, c.class, c.instrument, c.experience
    from person as p, class_member as c
    where p.id = c.personid
    order by p.lastname, p.firstname;

drop view if exists paid_vs_tuition;
create view paid_vs_tuition as
    select f.momefid, f.name, sum(a.amount) as paid, f.tuition
        from family as f, adjusted_payment as a 
        where f.momefid = a.momefid group by a.momefid;

drop view if exists tuition_left;
create view tuition_left as
    select *, paid - tuition as owed from paid_vs_tuition;

drop view if exists paid_up;
create view paid_up as
    select * from tuition_left
        where owed = 0;

drop view if exists total;
create view total as
      select '01' as Num, 'Paid' as Item, sum(amount) as 'Total' from payment
union select '02', 'Billed', sum(amount) from debit
union select '03', 'Balance', sum(amount) from clean_ledger
union select '04', 'High', max(balance) from balance
union select '05', 'Low', min(balance) from balance
union select '06', 'Paid Up', count(*) from paid_up
union select '07', 'Zero Balance', count(*) from balance where balance = 0
union select '08', 'Negative Balance', count(*) from balance where balance < 0
union select '09', 'Positive Balance', count(*) from balance where balance > 0
union select '10', 'Invoices', count(id) from invoice order by Num;
