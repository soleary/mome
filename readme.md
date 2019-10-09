# mome
Accounting software for Mrs. O'Leary's Music Education

This is a suite of command line utilities that I use to manage my wife's
music education business.

We track families and the students and parents within them, send out
invoices and record payment information. There's a flexible set of
billing schedules and flexibility for how each family is contacted.

These tools used to be directly integrated with Google Drive, but the
module I was using for that has not been maintained for some time.
Google recently made some significant API changes and after several
hours of trying to get that to work again, I fell back to CSV files,
which aren't too much worse. There's an annoying manual upload or
download step, but it's really not that bad.

There are a number of small utilities that work together to accomplish my
work flow. I considered putting them into a web front end and may still
do that in the future to make things more user-friendly and operating
system agnostic.

The database is SQLite, which turned out to be a pleasure to work with.
Had I not made one design blunder (storing dollar values as decimal
amounts of dollars instead of integer amounts of cents or 10ths or
100ths of cents) this would have all worked beautifully. But SQLite has
good sprintf support, so a little rounding chicanery was all that was
necessary.  I would have been really afraid of this in a large system,
but here it seems to have worked out fine.

For more information about this blunder, read this:
https://perl.plover.com/yak/Moonpig/

I really should have done all the things mentioned here, but I didn't.
Part false laziness, part hubris, part impatience.  I did need something
kind of immediately when the Mrs. was getting her business off the ground,
but I could have done better to make things easier on myself.

I will likely be using this software for at least one more school year.
I don't know if it will undergo any significant changes as it performed
quite well this year and I have a pretty short list of complaints.
