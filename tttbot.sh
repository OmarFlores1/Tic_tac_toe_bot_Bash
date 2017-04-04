#This bash program translates the bot from:
#http://curtisquarterly.blogspot.com/2005/04/writing-tic-tac-toe-bot-in-perl.html
#Created by: Omar Flores
#4/3/2017

board=123456789

wins=( 123 456 789 147 258 369 159 357 )

function board
{
echo $board | grep -o '...'

if [[ $1 != "" ]]
then
echo $1
exit
fi

}

function move
{
piece=$1
move=$2
log=$3
#echo "piece $1 move $2 log $3"
#echo
case $move in
^[0-9]) move_return=0;return
;;
*) move_return=1; 
;;
esac

b=$(echo $board | sed -e "s/$move/$piece/")

if [[ $board == $b ]]  #nothing was replaced 
then
move_return=0
return
else   #there was a replacement in the board, so retval=1
board=$b
move_return=1
fi

#part that ends the game, either wins or ties.
winsBefore=(${wins[@]})
for i in $(seq 0 7)
do
wins[$i]=$(echo ${wins[$i]} | sed -e "s/$move/$piece/")

if [[ ${wins[$i]} != ${winsBefore[$i]} && ${wins[$i]} == "$piece$piece$piece" ]]
then
board "piece $piece wins!"
fi

done


#now deal with "tie"

if ! [[ $board =~ [1-9] ]]
then
board "TIE"
move_return=1
fi

return
}

function check {
#checks for possible forks
piece=$1
move=$2
log=$3
#open1=($@)

#echo "$@"
#echo 

if ! [[ $move =~ [1-9] ]]
then
move_return=0
return
fi

k=0
for i in ${wins[@]}
do
criteria=$(echo $i | awk "/$piece/&&/$move/&&/[[:digit:]]$piece?[[:digit:]]/")
if [[ $criteria != "" ]]
then
k=$((k+1))
fork[0]=$i
fi
done

forkSize=$k
#echo "fork(0) ${fork[0]} forkSize $k"
return

}

function player
{
retval=0

while [[ $retval == 0 ]]
do
echo "enter your move"
read move
move "X" "$move" "dePlayer"
retval=$move_return
done


}

function bot
{
#attempt to grab box 5
move "O" "5" "botGrabs5"

if [[ $move_return == 1 ]]
then
return
fi


#get the open boxes in the $board
open=($(echo $board | grep -o . | awk '/([[:digit:]])/' ))

#The second and third items to consider will be making a winning move 

for move in ${open[@]}
do

j=0
for i in ${wins[@]}
do
d=$(echo $i | awk "/$move/&&/O[[:digit:]]?O/")
if [[ $d != "" ]]
then
wins[$j]=$d
j=$((j+1))
#if possible to win do it
d=$(echo $d | sed -e "s/O//g")
move "O" "$d" "winningMove"
return
fi

done  #finish getting the winning options for O 

done  #finished for all moves in ${open[@]}


#making a block if it is necessary. These outweigh considerations of forks.


for move1 in ${open[@]}
do

j=0
for i in ${wins[@]}
do

e=$(echo $i | awk "/$move1/&&/X[[:digit:]]?X/" )

if [[ $e != "" ]]
then
wins[$j]="$e"
j=$((j+1))
#if possible to block do it
e=$(echo $e | sed -e "s/X//g")
move "O" "$e" "blockingMove"
return
fi

done  #finish getting the blocking options for X

done  #finished for all moves in ${open[@]}


#get a fork

for move in ${open[@]}
do
check "O" "$move" "botGetsFork" "${wins[@]}" "${open[@]}"


if [[ $forkSize > 1 ]]
then
move "O" "$move" "botsGetAFork"
return
fi

done

#handler to prevent the opponent from obtaining a fork. 

for move1 in ${open[@]}
do
check "O" "$move1" "botPreventsFork" "${wins[@]}" "${open[@]}"
if [[ $forkSize > 0 ]]
then
opposite=$(echo ${fork[0]} | grep -o "[^O$move1]")
check "X" "$opposite" "botChecksAdversary" "${wins[@]}" "${open[@]}"
if [[ $forkSize < 2 ]]
then
move "O" "$move1" "bothPreventsFork"
return
fi  #ends if $forkSize<2 
fi  #ends if $forkSize>1

done

move "O" "${open[0]}" "bothPreventsForkNoIssues"

}


while [[ 1 ]]
do
board
player
bot
done
