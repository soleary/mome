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
/* Weekday numbers to names */
('dow', 0, 'Sunday'   ),
('dow', 1, 'Monday'   ),
('dow', 2, 'Tuesday'  ),
('dow', 3, 'Wednesday'),
('dow', 4, 'Thursday' ),
('dow', 5, 'Friday'   ),
('dow', 6, 'Saturday' ),

/* English affirmative-negative */
('a-n', 'yes', 'Yes'),
('a-n', 'no', 'No'  ),

/* Billing statuses */
('bill', 'B', 'Both'          ),
('bill', 'R', "Don't Rate"    ),
('bill', 'I', "Don't Invoice" ),
('bill', '', 'Normal'         ),

/* Payment plans */
('plan', 1, 'One Payment'  ),
('plan', 2, 'Two Payments' ),
('plan', 5, 'Five Payments'),
('plan', 9, 'Nine Payments'),

/* Ledger entry types */
('ledger', 'debit',      'Debit'     ),
('ledger', 'credit',     'Credit'    ),
('ledger', 'adjustment', 'Adjustment'),
('ledger', 'check',      'Check'     ),
('ledger', 'cash',       'Cash'      ),
('ledger', 'paypal',     'PayPal'    ),

/* Garbage line, but I don't have to remember that
 * the last line above should end with a ';' */
('foo', 'bar', 'baaz');
