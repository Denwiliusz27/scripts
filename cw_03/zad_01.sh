#!/bin/bash
#Daniel Wielgosz (g1)


function valid_ip() {
    ip=$1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS

        # for nb in "${ip[@]}"
        # do
        #     if [[ ${#nb} -eq 3 && $nb -le 255 && $nb -ge 100 ]]; then
        #     elif [[ ${#nb} -eq 2 && $nb -le 99 && $nb -ge 10 ]]; then
        #     elif [[ ${#nb} -eq 1 && $nb -le 9 && $nb -ge 1 ]]; then
        #     else
        #         return 0    
        #     fi
        # done
        
        if [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]; then
            return 1
        fi 
    fi
}


function uncorrect_ip() {
    echo
    echo '~~~~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~~'
    echo '~ Numer IP:' $1 'jest niepoprawny'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
}


function no_arguments_error() {
    echo
    echo '~~~~~~~~~~ ERROR ~~~~~~~~'
    echo '~ Nie podano argumentow'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
}

function ping_on_ip() {
  if [ "`ping -c 1 $1`" ]; then
    echo $1 'żywy'
  else
    echo $1 'martwy'
  fi
}


if [ $# -eq 0 ]; then
    no_arguments_error
    exit 1
elif [ $# -eq 1 ]; then
    if  valid_ip $1 ; then
        uncorrect_ip $1
        exit 1
    else
      ping_on_ip $1
    fi

elif [ $# -eq 2 ]; then
    if  valid_ip $1 ; then
      uncorrect_ip $1
    else
      if valid_ip $2; then
        uncorrect_ip $2
      else
        OIFS=$IFS
        IFS='.'
        ping_1=($1)
        ping_2=($2)
        IFS=$OIFS

        for (( i=0; i<${#ping_1[@]}; i++ ))
        do
          if [ ${ping_1[$i]} -gt ${ping_2[$i]} ]; then
            temp=( "${ping_1[@]}" )
            ping_1=( "${ping_2[@]}" )
            ping_2=( "${temp[@]}" )
            break;
          elif [ ${ping_1[$i]} -lt ${ping_2[$i]} ]; then
            break;
          fi
        done

        p_1=$( IFS=$'.'; echo "${ping_1[*]}" )
        p_2=$( IFS=$'.'; echo "${ping_2[*]}" )

        ping_on_ip $p_1

#        if [ "`ping -c 1 $p_1`" ]; then
#          echo $p_1 'żywy'
#        else
#          echo $p_1 'martwy'
#        fi

        echo '---------- PETLA ----------'
        while [ "$p_1" != "$p_2" ];
        do
          i=3

          while [ ${ping_1[$i]} -eq 255 ];
          do
            ping_1[$i]=0
            i=$(( $i - 1 ))
          done

          ping_1[$i]=$(( ${ping_1[$i]} + 1 ))
#          echo 'ping1: ' ${ping_1[0]} '.' ${ping_1[1]} '.' ${ping_1[2]} '.' ${ping_1[3]}
          p_1=$( IFS=$'.'; echo "${ping_1[*]}" )

          ping_on_ip $p_1
#          if [ "`ping -c 1 $p_1`" ]; then
#            echo $p_1 'żywy'
#          else
#            echo $p_1 'martwy'
#          fi
        done
        echo '---------- PETLA ----------'

      fi
    fi
fi