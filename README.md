# tic-tac-toe-bot-in-bash
Bash's tic tac toe code that translates the code from perl's bot:

I got inspiration from http://curtisquarterly.blogspot.com/2005/04/writing-tic-tac-toe-bot-in-perl.html

The challenge was to 
- find corresponding functionality for grep and substitution in bash
- update the variables, since they don't get automatically changed like in perl.  E.g. in Perl the expression 
grep { /$piece/ && /$move/ && /\d${piece}?\d/ } @wins would at the same time filter @wins and alter it.

To-do:
The performance of the bash program is slow.  Please wait for up to 15 seconds after the first move and 10 or less for
subsequent moves.
