#!/bin/bash
#Daniel Wielgosz (g1)

echo
echo '~~ Tabliczka mnożenia od 1 do 9 ~~'

for i in {1..9}
do
    for j in {1..9}
    do
        a=$(($i*$j))
        printf "%2d " $a  #"$a "
    done
    printf "\n"
done

echo