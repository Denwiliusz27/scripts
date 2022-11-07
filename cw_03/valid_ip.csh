#!/bin/tcsh
#Daniel Wielgosz (g1)

set ip = $1
set check_ip = `echo ${ip} | egrep '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'`

if ( "$check_ip" == "" ) then
  echo '0'

else
    set ip1 = `echo $ip | cut -d '.' -f 1`
    set ip2 = `echo $ip | cut -d '.' -f 2`
    set ip3 = `echo $ip | cut -d '.' -f 3`
    set ip4 = `echo $ip | cut -d '.' -f 4`

    if ( ( $ip1 >= 0 && $ip1 <= 255 ) && ( $ip2 >= 0 && $ip2 <= 255 ) && ( $ip3 >= 0 && $ip3 <= 255 ) && ( $ip4 >= 0 && $ip4 <= 255 ) ) then
      echo '1'
    else
      echo '0'
    endif
endif