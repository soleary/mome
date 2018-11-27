drop view if exists payment;
create view payment as
    select * from ledger
    where (type != 'debit' or type != 'adjustment')
        and validated is not null;

drop view if exists debit;
create view debit as
    select * from ledger
    where type = 'debit';

drop view if exists clean_ledger;
create view clean_ledger as
    select * from ledger
    where
        (type != 'debit' and validated is not null)
        or type = 'debit';

drop view if exists balance;
create view balance as
    select l.momefid, f.name, round(sum(l.amount), 8) as balance
    from clean_ledger as l, family as f
    where l.momefid = f.momefid
    group by l.momefid;

drop view if exists family_balance;
create view family_balance as
    select l.momefid, f.name, f.nobill, printf("%.2f", sum(l.amount))
    from ledger as l, family as f
    where
        ((l.type != 'debit' and l.validated is not null)
        or l.type = 'debit')
        and l.momefid = f.momefid
        group by l.momefid;

drop view if exists deposits;
create view deposits as
        select id, type, momefid, checknum, amount
        from clean_ledger
        where depositdate is null and type != 'debit'
    union
        select id, type, '0', checknum, amount
        from additional_deposits
        where depositdate is null;

drop view if exists deposit_slip;
create view deposit_slip as
        select type, count(type) as count, printf("%.2f", sum(amount)) as amount
        from deposits
        group by type
    union
        select 'Total', count(*), printf("%.2f", sum(amount))
        from deposits
        where type != 'paypal'
    union
        select 'Grand Total', count(*), printf("%.2f", sum(amount))
        from deposits
        order by type desc;

drop view if exists student_roster;
create view student_roster as
    select f.momefid, cm.id as classid, p.id, p.firstname, p.lastname, p.grade, cm.class, cm.instrument, cm.experience
    from person as p, class_member as cm, family as f, family_member as fm
    where p.id = cm.personid
        and f.momefid = fm.momefid
        and fm.personid = p.id
    order by p.lastname, p.firstname;

drop view if exists parent_roster;
create view parent_roster as
    select f.momefid, p.id, p.firstname, p.lastname, p.phone, p.email
    from person as p, family as f, family_member as fm
    where p.id = fm.personid
        and fm.momefid = f.momefid
        and p.type = 'parent'
        and (p.email is not null or p.phone is not null)
    order by p.lastname, p.id;

drop view if exists paid_vs_tuition;
create view paid_vs_tuition as
    select f.momefid, f.name, sum(a.amount) as paid, f.tuition
    from family as f, adjusted_payment as a
    where f.momefid = a.momefid group by a.momefid;

drop view if exists tuition_remaining;
create view tuition_remaining as
    select *, paid - tuition as owed from paid_vs_tuition;

drop view if exists paid_up;
create view paid_up as
    select * from tuition_remaining
    where owed = 0
    order by name;

drop view if exists total;
create view total as
      select 01 as Num, 'Tuition         ' as Item, printf("%.2f", sum(tuition)) as 'Total' from family
union select 02, 'Owed', printf("%.2f", sum(owed)) from tuition_remaining
union select 03, 'Paid', printf("%.2f", sum(amount)) as 'Total' from payment
union select 04, 'Billed', printf("%.2f", sum(amount)) from debit
union select 05, 'Balance', printf("%.2f", sum(amount)) from clean_ledger
union select 06, 'High', printf("%.2f", max(balance)) from balance
union select 07, 'Low', printf("%.2f", min(balance)) from balance
union select 08, 'Families', count(id) from family where session = (select id from session where active is not null)
union select 09, 'Parents', count(id) from person where type = 'parent'
union select 10, 'Students', count(id) from person where type = 'student'
union select 11, 'Payers', count(id) from person where type = 'payer'
union select 12, 'Paid Up', count(*) from paid_up
union select 13, 'Zero Balance', count(*) from balance where balance = 0
union select 14, 'Negative Balance', count(*) from balance where balance < 0
union select 15, 'Positive Balance', count(*) from balance where balance > 0
union select 16, 'Invoices', count(id) from invoice
union select 17, 'Notifications', count(id) from notification where sentdate is not null
union select 18, 'Payments', count(id) from ledger where type != 'adjustment' and type != 'debit'
union select 19, 'Debits', count(id) from ledger where type = 'debit'
union select 20, 'Transactions', count(id) from ledger
order by Num;
