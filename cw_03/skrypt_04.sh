#!/bin/bash
#Daniel Wielgosz (g1)


function valid_ip() {
    ip=$1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS

        if [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]; then
            echo 1
            exit
        fi
    fi
    echo 0
}

function valid_port() {
    port=$1

    if [[ $port =~ ^[0-9]+$ ]]; then
      echo 1
    else
      echo 0
    fi
}


function uncorrect_ip() {
    echo
    echo '~~~~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~~'
    echo '~ Numer IP:' $1 'jest niepoprawny'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
}


function no_ip_error() {
    echo
    echo '~~~~~~~~~~ ERROR ~~~~~~~~'
    echo '~ Nie podano adresu IP'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
}


function no_port_error() {
    echo
    echo '~~~~~~~~~~ ERROR ~~~~~~~~'
    echo '~ Nie podano nr portu'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
}


function invalid_arg() {
    echo
    echo '~~~~~~~~~~ ERROR ~~~~~~~~'
    echo '~ Podano niewłaściwy argument'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
}


function ping_on_ip() {
  ports=$2
  result="$1: "

  for port in "${ports[@]}"; do
    if [ $port -eq 22 ]; then
      extra=`ssh -v -o  ConnectTimeout=1 $1 sleep 1 2>&1 | grep -E -o '^[a-zA-Z0-9 _.]+ '`
      if [ "$extra" != "" ]; then
        result="${result}${port} - ${extra},"
      fi
      continue
    fi

    resp=$(echo "stats" | nc -w 1 -v $1 $port 2>&1)

    if [ $? -eq 0 ]; then
        server=$(echo "$resp" | grep "Server")
        if [ $? -eq 0 ]; then
            respSplit=(${server//:/ })
            cleanedServer=${respSplit[1]//[$'\t\r\n']}
            result="${result} $port - ${cleanedServer}"
        fi
        respSplit=(${resp// / })
        result="${result}${respSplit[5]} - otwarty, "
    else
        result="${result}$port - zamkniety, "
    fi

  done
  echo $result

}

ips=()
ports=()

for arg in "$@"
do
  res=$(valid_ip $arg)

  if [ "$res" == "1" ]; then
    ips+=($arg)
  else
    ports_arg=(${arg//,/ })

    for port in "${ports_arg[@]}"; do
      valid=$(valid_port $port)
      if [ "$valid" == "1" ]; then
        ports+=(${port})
      else
        invalid_arg
        exit 1
      fi
    done
  fi
done

ip_nr=${#ips[@]}
ports_nr=${#ports[@]}

if [ $ip_nr -eq 0 ]; then
  no_ip_error
  exit 1
elif [ $ports_nr -eq 0 ]; then
  no_port_error
  exit 1
fi

if [ "${#ips[@]}" -eq 1 ]; then
#  for port in "${ports[@]}"; do
   ping_on_ip $1 $ports
#  done
else
  OIFS=$IFS
  IFS='.'
  ping_1=(${ips[0]})
  ping_2=(${ips[1]})
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

#  for port in "${ports[@]}"; do
  ping_on_ip $p_1 $ports
#  done

  while [ "$p_1" != "$p_2" ];
  do
    i=3

    while [ ${ping_1[$i]} -eq 255 ];
    do
      ping_1[$i]=0
      i=$(( $i - 1 ))
    done

    ping_1[$i]=$(( ${ping_1[$i]} + 1 ))
    p_1=$( IFS=$'.'; echo "${ping_1[*]}" )

#    for port in "${ports[@]}"; do
      ping_on_ip $p_1 $ports
#    done
  done
fi