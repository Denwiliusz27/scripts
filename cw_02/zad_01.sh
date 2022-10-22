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

##        echo 'a:' $a , ' dl a = ' ${#a}
#
#        if [ ${#a} -gt $len ]
#        then
#          len=${#a}
#        fi
#
#        printf "%${len}d " $a
    done
    printf "\n"
done

echo