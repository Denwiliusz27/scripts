#!/bin/bash
#Paweł Kowalczyk Grupa 1


function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

bn=$(basename $0)
dn=$(dirname $0)

link=$(echo $0 | grep -E -o 'zad7.sh')
if [[ $link=="zad7.sh" ]]; then
    echo "#!/bin/bash" > "$dn/serwer.sh"
    echo "dn=\$(dirname \$0)"  >> "$dn/serwer.sh"
    echo "\$dn/zad7.sh \$*" >> "$dn/serwer.sh"
    chmod u=rwx $dn/serwer.sh

    echo "#!/bin/bash" > "$dn/klient.sh"
    echo "dn=\$(dirname \$0)"  >> "$dn/klient.sh"
    echo "\$dn/zad7.sh -c \$*" >> "$dn/klient.sh"
    chmod u=rwx $dn/klient.sh
fi

#flagi:
klient=0
opcje=0

licznikParametrow=1

licznik=0
lineNumber=0

ip="localhost"
port="5000"

if [[ $# != 0 ]]; then
    for PARAMETR in $*; do
        if [[ "$PARAMETR" == "-c" ]] || [[ "$PARAMETR" == "--klient" ]]; then
            klient=1
        elif [[ "$PARAMETR" == "-i" ]]; then
            
            if [[ $opcje -eq 0 ]]; then
                opcje=1
            elif [[ $opcje -eq 1 ]]; then
                opcje=1
            elif [[ $opcje -eq 2 ]]; then
                opcje=3
            fi

            ip=$(($licznikParametrow + 1))
            ip=${!ip}
            if valid_ip $ip; then stat='1'; else stat='0'; fi
            if [ $stat == '0' ]; then echo "Podany argument nie jest ipv4"; exit 1; fi
        elif [[ "$PARAMETR" == "-p" ]]; then
            
            if [[ $opcje -eq 0 ]]; then
                opcje=2
            elif [[ $opcje -eq 2 ]]; then
                opcje=2
            elif [[ $opcje -eq 1 ]]; then
                opcje=3
            fi
            

            port=$(($licznikParametrow + 1))
            port=${!port}
            czek=`echo "$port" | grep -E -o '^([0-9]+,{0,1})+'`
            if [[ "$czek" == "" ]]; then
                echo "Port nie jest liczba"; exit 2
            fi
        fi
        licznikParametrow=$(($licznikParametrow + 1))
    done
fi

file="$dn/.licznik.rc"

if [[ -f "$file" ]]; then
    echo "$file istnieje"
    globalLineNumber=1
    while read -r line; do
        if [[ $opcje -eq 1 ]] || [[ $opcje -eq 0 ]]; then
            czek=$(echo "$line" | grep -E -o 'default port')
            if [[ $czek == "default port" ]]; then
                port=$(echo "$line" | grep -E -o '[0-9]+')
            fi
        fi
        if [[ $opcje -eq 2 ]] || [[ $opcje -eq 0 ]]; then
            czek=$(echo "$line" | grep -E -o 'default ip')
            if [[ $czek == "default ip" ]]; then
                ip=$(echo "$line" | grep -E -o 'localhost')
                if [[ $ip == "" ]]; then
                    ip=$(echo "$line" | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
                fi
            fi
        fi
        adres=$(echo "$line" | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]+')
        if [[ $adres == "$ip:$port" ]]; then
            licznik=$(echo "$line" | grep -E -o ' [0-9]+')
            lineNumber=$globalLineNumber
        fi
        globalLineNumber=$(($globalLineNumber + 1))
    done <$file
    if [[ $lineNumber -eq 0 ]]; then
        lineNumber=$globalLineNumber
        echo "$ip:$port $licznik" >> .licznik.rc
    fi
else
    echo "plik .rc nie istnieje, tworzenie..."
    echo "default ip = $ip" > .licznik.rc
    echo "default port = $port" >> .licznik.rc
fi

if [[ $klient -eq 0 ]]; then
    status=$(nc -zv -w 1 $ip $port 2>&1 | grep -E -o 'failed')
    if [[ $status == 'failed' ]]; then
        echo "Utworzono Serwer ip: $ip na porcie $port"
        while true; do
            status=$(nc -d -l $ip $port)
            if [[ $? -ne 0 ]]; then
                echo "Nie mozna utworzyc serweru na danym porcie i/lub adresie ip"
                exit 4
            fi
            if [[ $status != "" ]]; then
                echo "Wiadomosc: $status"
                licznik=$(($licznik + 1))
                sed -i "$lineNumber s/.*/$ip:$port $licznik/" $file
            fi
            echo "Liczba wywolan do serwera: $licznik"
            status=""
        done
    else
        echo "$ip:$port"
        echo "Serwer na tym porcie jest juz ustawiony"
        exit 3
    fi
else
    echo "Polaczono z $ip na porcie $port"
    while true; do
        read wiadomosc
        echo "$wiadomosc" | nc -w 0 $ip $port
    done

fi

