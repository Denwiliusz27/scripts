#!/bin/csh
#Daniel Wielgosz (g1)



set ips = ()
set ports = ()

foreach arg ($argv)
    set res = `tcsh valid_ip.csh $arg`

    if ("$res" == "1") then
        set ips = ( $ips $arg )
    else
      set possible_ports = `echo $arg | sed 's/\,/ /g'`

      foreach port ($possible_ports)
        if ( `echo ${port} | egrep '^[0-9]+$'` != "" ) then
          set ports = ( $ports $port )
        else
          echo
          echo '~~~~~~~~~~ ERROR ~~~~~~~~'
          echo '~ Podano niewłaściwy argument'
          echo '~~~~~~~~~~~~~~~~~~~~~~~~~'
          echo
          exit 1
        endif
      end
    endif
end

set ips_nr = ${#ips}
set ports_nr = ${#ports}

if ( $ips_nr == 0 ) then
    echo
    echo '~~~~~~~~~~ ERROR ~~~~~~~~'
    echo '~ Nie podano adresu IP'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
    exit 1
else if ( $ports_nr == 0 ) then
    echo
    echo '~~~~~~~~~~ ERROR ~~~~~~~~'
    echo '~ Nie podano nr portu'
    echo '~~~~~~~~~~~~~~~~~~~~~~~~~'
    echo
    exit 1
endif

if ( $ips_nr == 1 ) then
  set result = "${ips[1]}: "

  foreach port ($ports)
    if ( $port == 22 ) then
      set extra = `ssh -v -o  ConnectTimeout=1 ${ips[1]} sleep 1 |& grep -E -o '^[a-zA-Z0-9 _.]+ '`

      if ( "$extra" != "" ) then
        set result="${result}${port} - ${extra}, "
      endif
    else
      set resp = `echo "stats" | nc -w 1  ${ips[1]} $port `

      if ( "$resp" != "" ) then
        set server = `echo $resp | sed 's/>/ /g'`
        set cloud = `echo $server[6] | sed 's/\t/ /g'`
        set cloud = `echo $cloud | sed 's/\r/ /g'`
        set cloud = `echo $cloud | sed 's/\n/ /g'`
        if ( $? == 0 ) then
          set result = "${result}${port} - ${cloud}"
        endif

        set result = "${result} - otwarty, "

      else
        set result = "${result}${port} - zamkniety, "
      endif
    endif
  end

  echo $result
  exit 0

else
  set ip1 = `echo ${ips[1]} | cut -d '.' -f 1`
  set ip2 = `echo ${ips[1]} | cut -d '.' -f 2`
  set ip3 = `echo ${ips[1]} | cut -d '.' -f 3`
  set ip4 = `echo ${ips[1]} | cut -d '.' -f 4`
  set ping_1_arr = ( $ip1 $ip2 $ip3 $ip4 )

  set ip1 = `echo ${ips[2]} | cut -d '.' -f 1`
  set ip2 = `echo ${ips[2]} | cut -d '.' -f 2`
  set ip3 = `echo ${ips[2]} | cut -d '.' -f 3`
  set ip4 = `echo ${ips[2]} | cut -d '.' -f 4`
  set ping_2_arr = ( $ip1 $ip2 $ip3 $ip4 )

  set i = 1

  while ($i < 5)
      if ($ping_1_arr[$i] > $ping_2_arr[$i]) then
          set temp = ( $ping_1_arr[1] $ping_1_arr[2] $ping_1_arr[3] $ping_1_arr[4] )
          set ping_1_arr = ( $ping_2_arr[1] $ping_2_arr[2] $ping_2_arr[3] $ping_2_arr[4] )
          set ping_2_arr = ( $temp[1] $temp[2] $temp[3] $temp[4] )
          break;
      else if ($ping_1_arr[$i] < $ping_2_arr[$i]) then
          break;
      endif
      set i = `expr $i + 1`
  end

  set ping_1 = `echo $ping_1_arr[1]'.'$ping_1_arr[2]'.'$ping_1_arr[3]'.'$ping_1_arr[4]`
  set ping_2 = `echo $ping_2_arr[1]'.'$ping_2_arr[2]'.'$ping_2_arr[3]'.'$ping_2_arr[4]`

  set result = "${ping_1}: "

  foreach port ($ports)
    if ( $port == 22 ) then
      set extra = `ssh -v -o  ConnectTimeout=1 ${ping_1} sleep 1 |& grep -E -o '^[a-zA-Z0-9 _.]+ '`

      if ( "$extra" != "" ) then
        set result="${result}${port} - ${extra}, "
      endif
    else
      set resp = `echo "stats" | nc -w 1  ${ping_1} $port `

      if ( "$resp" != "" ) then
        set server = `echo $resp | sed 's/>/ /g'`
        set cloud = `echo $server[6] | sed 's/\t/ /g'`
        set cloud = `echo $cloud | sed 's/\r/ /g'`
        set cloud = `echo $cloud | sed 's/\n/ /g'`

        if ( $? == 0 ) then
          set result = "${result}${port} - ${cloud}"
        endif

        set result = "${result} - otwarty, "

      else
        set result = "${result}${port} - zamkniety, "
      endif
    endif
  end

  echo $result

  while ( $ping_1 != $ping_2)
      set i = 4

      while ( $ping_1_arr[$i] == 255 )
          set ping_1_arr[$i] = 0
          set i = `expr $i - 1`
      end

      set ping_1_arr[$i] = `expr $ping_1_arr[$i] + 1`
      set ping_1 = `echo $ping_1_arr[1]'.'$ping_1_arr[2]'.'$ping_1_arr[3]'.'$ping_1_arr[4]`

      set result = "${ping_1}: "

      foreach port ($ports)
        if ( $port == 22 ) then
          set extra = `ssh -v -o  ConnectTimeout=1 ${ping_1} sleep 1 |& grep -E -o '^[a-zA-Z0-9 _.]+ '`

          if ( "$extra" != "" ) then
            set result="${result}${port} - ${extra}, "
          endif
        else
          set resp = `echo "stats" | nc -w 1  ${ping_1} $port `

          if ( "$resp" != "" ) then
            set server = `echo $resp | sed 's/>/ /g'`
            set cloud = `echo $server[6] | sed 's/\t/ /g'`
            set cloud = `echo $cloud | sed 's/\r/ /g'`
            set cloud = `echo $cloud | sed 's/\n/ /g'`

            if ( $? == 0 ) then
              set result = "${result}${port} - ${cloud}"
            endif

            set result = "${result} - otwarty, "

          else
            set result = "${result}${port} - zamkniety, "
          endif
        endif
      end
      echo $result
  end
  exit 0
endif