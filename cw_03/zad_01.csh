#!/bin/tcsh
#Daniel Wielgosz (g1)

if ($#argv == 0) then
    echo
    echo '~~~~~~~~~~ ERROR ~~~~~~~~'
    echo '~ Nie podano argumentow'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
    exit 0

else if ($#argv == 1) then
    set is_ip_correct = `tcsh valid_ip.csh $1`

    if ( $is_ip_correct == 0) then
        echo
        echo '~~~~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~~'
        echo '~ Numer IP:' $1 'jest niepoprawny'
        echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
        echo
        exit 0
    else
       set ping_result = `ping -c 1 -w 1 $1`
       echo $ping_result

       if ( $? == 0 ) then
         echo $1 'żywy'
         exit 1
       else
         echo $1 'martwy'
         exit 0
       endif
    endif

else if ($#argv == 2) then
    set is_ip_correct = `tcsh valid_ip.csh $1`

    if ( $is_ip_correct == 0) then
        echo
        echo '~~~~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~~'
        echo '~ Numer IP:' $1 'jest niepoprawny'
        echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
        echo
        exit 0
    else
        set is_ip_correct = `tcsh valid_ip.csh $2`
        if ( $is_ip_correct == 0) then
            echo
            echo '~~~~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~~'
            echo '~ Numer IP:' $2 'jest niepoprawny'
            echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
            echo
            exit 0
        else

            set ip1 = `echo $1 | cut -d '.' -f 1`
            set ip2 = `echo $1 | cut -d '.' -f 2`
            set ip3 = `echo $1 | cut -d '.' -f 3`
            set ip4 = `echo $1 | cut -d '.' -f 4`
            set ping_1_arr = ( $ip1 $ip2 $ip3 $ip4 )

            set ip1 = `echo $2 | cut -d '.' -f 1`
            set ip2 = `echo $2 | cut -d '.' -f 2`
            set ip3 = `echo $2 | cut -d '.' -f 3`
            set ip4 = `echo $2 | cut -d '.' -f 4`
            set ping_2_arr = ( $ip1 $ip2 $ip3 $ip4 )

            set i = 1
            while ($i < 5)
                if ($ping_1_arr[$i] > $ping_2_arr[$i]) then
                    set temp = ( $ping_1_arr[1] $ping_1_arr[2] $ping_1_arr[3] $ping_1_arr[4] )
                    set ping_1_arr = ( $ping_2_arr[1] $ping_2_arr[2] $ping_2_arr[3] $ping_2_arr[4] )
                    set ping_2_arr = ( $temp[1] $temp[2] $temp[3] $temp[4] )
                    break;
                else if ($ping_1_arr[$i] > $ping_2_arr[$i]) then
                    break;
                endif
                set i = `expr $i + 1`
            end

            echo 'ping1: ' $ping_1_arr
            echo 'ping2: ' $ping_2_arr




            set ping_1 = `echo $ping_1_arr[1]'.'$ping_1_arr[2]'.'$ping_1_arr[3]'.'$ping_1_arr[4]`
            echo 'ping_1: ' $ping_1
#
            set ping_result = `ping -c 1 -w 1 $ping_1`

            echo $ping_result

            if ( $? == 0 ) then
              echo $ping_1 'żywy'
            else
              echo $ping_1 'martwy'
              exit 0
            endif




        endif
    endif
endif