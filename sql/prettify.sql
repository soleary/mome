/*
 * A table to translate data in this database to
 * pretty printable strings for nicer output.
 * i column = input value
 * o column = output value
 */

drop table if exists prettify;

create table prettify(
     id integer primary key
    ,type string not null
    ,i string
    ,o string
);

insert into prettify (type, i, o)
values
/* Weekday numbers to names, day-of-week */
('dow', 0, 'Sunday'   ),
('dow', 1, 'Monday'   ),
('dow', 2, 'Tuesday'  ),
('dow', 3, 'Wednesday'),
('dow', 4, 'Thursday' ),
('dow', 5, 'Friday'   ),
('dow', 6, 'Saturday' ),

/* Month Names */
('month', 01, 'January'),
('month', 02, 'February'),
('month', 03, 'March'),
('month', 04, 'April'),
('month', 05, 'May'),
('month', 06, 'June'),
('month', 07, 'July'),
('month', 08, 'August'),
('month', 09, 'September'),
('month', 10, 'October'),
('month', 11, 'November'),
('month', 12, 'December'),

/* English affirmative-negative */
('a-n', 'yes', 'Yes'),
('a-n', 'no', 'No'  ),

/* Billing statuses */
('bill', 'B', 'Both'          ),
('bill', 'F', "Don't Followup"),
('bill', 'R', "Don't Rate"    ),
('bill', 'I', "Don't Invoice" ),
('bill', '', 'Normal'         ),

/* Payment plans */
('plan', 1, 'One Payment'  ),
('plan', 2, 'Two Payments' ),
('plan', 5, 'Five Payments'),
('plan', 9, 'Nine Payments'),

/* Ledger entry types */
('ledger', 'debit',  'Debit' ),
('ledger', 'credit', 'Credit'),
('ledger', 'check',  'Check' ),
('ledger', 'cash',   'Cash'  ),
('ledger', 'paypal', 'PayPal'),
('ledger', 'refund', 'Refund'),
('ledger', 'venmo',  'Venmo' ),

/* Ledger entry types for customer statements */
('statement', 'debit',  'Tuition Charge'),
('statement', 'credit', 'Account Credit'),
('statement', 'check',  'Check Payment' ),
('statement', 'cash',   'Cash Payment'  ),
('statement', 'paypal', 'PayPal Payment'),
('statement', 'refund', 'Refund'        ),
('statement', 'venmo',  'Venmo'         ),

/* Garbage line, but I don't have to remember that
 * the last line above should end with a ';' */
('foo', 'bar', 'baaz');
