#!/bin/tcsh
#Paweł Kowalczyk Grupa 1


if( $#argv == 1 ) then
    set ip=`echo $1 | grep -E -o '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
    if ( $ip == $1 ) then
        set zmienna=`echo $ip | awk 'BEGIN { FS="." } { print $1; print $2; print $3; print $4 }'`
        set ip =($zmienna:as/\n/ /)
        if ( $ip[1] > 255 || $ip[2] > 255 || $ip[3] > 255 || $ip[4] > 255) then
            goto blad
        endif
        exit 0
    endif
    blad:
    echo "Podany argument nie jest ipv4"
else 
    echo "Nie podano argumentu"
endif
exit 1