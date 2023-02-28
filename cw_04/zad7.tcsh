#!/bin/tcsh
#Paweł Kowalczyk Grupa 1

set bn=`basename $0`
set dn=`dirname $0`

set link=`echo $0 | grep -E -o 'zad7.tcsh'`
if ( $link == "zad7.tcsh") then
    echo "#\!/bin/tcsh" >! "$dn/serwer.tcsh"
    echo 'dn=$(dirname $0)'  >>! "$dn/serwer.tcsh"
    echo "$dn/zad7.tcsh"' $*' >>! "$dn/serwer.tcsh"
    chmod u=rwx $dn/serwer.tcsh

    echo "#\!/bin/tcsh" >! "$dn/klient.tcsh"
    echo 'dn=$(dirname $0)'  >>! "$dn/klient.tcsh"
    echo "$dn/zad7.tcsh -c"' $*' >>! "$dn/klient.tcsh"
    chmod u=rwx $dn/klient.tcsh
endif

#flagi
@ klient=0
@ opcje=0

@ licznikParametrow=1

@ licznik=0
@ lineNumber=0

set ip="localhost"
set port="5000"

if ( $#argv != 0 ) then
    while ( $licznikParametrow <= $#argv )
        if ( "$argv[$licznikParametrow]" == "-c" || "$argv[$licznikParametrow]" == "--klient" ) then
            @ klient=1
        else
            if ( "$argv[$licznikParametrow]" == "-i") then
                if ($opcje == 0) then
                    @ opcje=1
                else 
                    if ($opcje == 1) then
                        @ opcje=1
                    else
                        if ($opcje == 2) then
                            @ opcje=3
                        endif
                    endif
                endif
                @ licznikParametrow = $licznikParametrow + 1
                if ($licznikParametrow > $#argv) then
                    echo "Nie podano adresu ip"
                    exit 1
                else
                    source $dn/ip_validator.tcsh "$argv[$licznikParametrow]"
                    if ( $? != 0) then
                        exit 1
                    else
                        set ip="$argv[$licznikParametrow]"
                    endif
                endif
            else 
                if ( "$argv[$licznikParametrow]" == "-p") then
                    if ($opcje == 0) then
                        @ opcje=2
                    else 
                        if ($opcje == 2) then
                            @ opcje=2
                        else
                            if ($opcje == 1) then
                                @ opcje=3
                            endif
                        endif
                    endif
                    @ licznikParametrow = $licznikParametrow + 1
                    if ($licznikParametrow > $#argv) then
                        echo "Nie podano portu"
                        exit 2
                    else
                        set czek=`echo "$argv[$licznikParametrow]" | grep -E -o '^([0-9]+,{0,1})+'`
                        if ( "$czek" == "") then
                            echo "Port nie jest liczba"
                            exit 2
                        else
                            set port="$argv[$licznikParametrow]"
                        endif
                    endif
                endif
            endif
        endif

        @ licznikParametrow = $licznikParametrow + 1
    end
endif

set file="$dn/.licznik.rc"

if ( -e "$file" ) then
    echo "$file istnieje!"

    @ globalLineNumber=1
    foreach line ( "`cat $file`" )
        if ($opcje == 1 || $opcje == 0) then
            set czek = `echo "$line" | grep -E -o 'default port'`
            if ("$czek"=="default port") then
                set port = `echo "$line" | grep -E -o '[0-9]+'`
            endif
        endif
        
        if ($opcje == 2 || $opcje == 0) then
            set czek = `echo "$line" | grep -E -o 'default ip'`
            if ("$czek" == "default ip") then
                set ip = `echo "$line" | grep -E -o 'localhost'`
                if ("$ip" == "") then
                    set ip = `echo "$line" | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
                endif
            endif
        endif
        set adres=`echo "$line" | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]+'`
        if ( "$adres" == "$ip"':'"$port" ) then
            @ licznik = `echo "$line" | grep -E -o ' [0-9]+'`
            @ lineNumber = $globalLineNumber
        endif
        @ globalLineNumber = $globalLineNumber + 1
    end
    if ($lineNumber == 0) then
        @ lineNumber = $globalLineNumber
        echo "$ip"':'"$port $licznik" >>! .licznik.rc
    endif
else
    echo "plik .rc nie istnieje, tworzenie..."
    echo "defeault ip = $ip" >! .licznik.rc
    echo "default port" = $port >>! .licznik.rc
endif
if ($klient == 0) then
    set czek = `nc -zv -w 1 $ip $port |& grep -E -o 'failed'`
    if ("$czek" == "failed") then
        echo "Utworzono Serwer ip: $ip na porcie $port"
        while (1) 
            set czek = `nc -d -l $ip $port`
            if ($status != 0) then
                echo "Nie mozna utworzyc serweru na danym porcie i/lub adresie ip"
                exit 4
            endif
            if ("$czek" != "") then
                echo "Wiadomosc: $czek"
                @ licznik = $licznik + 1
                sed -i "$lineNumber s/.*/$ip"':'"$port $licznik/" $file
            endif
            echo "Liczba wywolan do serwera: $licznik"
            set czek = ""
        end
    else
        echo "$ip"":$port"
        echo "Serwer na tym porcie jest juz ustawiony"
        exit 3
    endif
else
    echo "Polaczono z $ip na porcie $port"
    while (1)
        set wiadomosc = $<
        echo "$wiadomosc" | nc -w 0 $ip $port
    end
endif