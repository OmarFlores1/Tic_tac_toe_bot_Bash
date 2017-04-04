# tic-tac-toe-bot-in-bash
Bash's tic tac toe code that translates the code from perl's bot:

I got inspiration from http://curtisquarterly.blogspot.com/2005/04/writing-tic-tac-toe-bot-in-perl.html

Basically the bash code recreates the strategies for:
Make a winning move.
Prevent opponent from making a winning move
Obtain a "fork"
Prevent opponent from being able to fork
Take the center square

The challenges I faces are briefly summarized below: 
- finding corresponding functionality in bash for grep and substitution in perl
- updating the variables, since they don't get automatically changed like in perl.  E.g. in Perl the expression 
grep { /$piece/ && /$move/ && /\d${piece}?\d/ } @wins would at the same time filter @wins and alter it.
- place the returns in the appropriate places and to clear the variables used for accumulation.

To-do:
The performance of the bash program is slow.  Please wait for up to 15 seconds in the second player's move and 10 or less for
subsequent moves.
