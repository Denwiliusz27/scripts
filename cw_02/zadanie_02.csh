#!/bin/tcsh
#Daniel Wielgosz (g1)


if ($#argv == 0) then
    set i = 1
    set j = 1
    set line = ""

    echo
    echo '~~ Tabliczka mnożenia od 1 do 9 ~~'

    while ($i <= 9)
        while ($j <= 9)
            set value = `expr $i \* $j`
            set line = "$line $value"
            set j = `expr $j + 1`
        end

        echo $line
        set line = ""
        set i = `expr $i + 1`
        set j = 1
    end
    echo

else
    foreach arg ($argv)
      if ($arg:q == "-h" || $arg:q == "--help") then
        echo
        echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~ Skrypt ma za zadanie wyświetlenie na ekranie"
        echo "~ loginu oraz imienia i nazwiska zalogowanego użytkownika"
        echo "~"
        echo "~ Użycie: tcsh zad_02.csh [-h --help] [num1] [num2]"
        echo "~ -h --help: wyświetla opis"
        echo "~ num1: pierwsza liczba"
        echo "~ num2: druga liczba"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo
        exit 0
      endif
    end

    if ( $#argv == 1 ) then  # podano tylko jeden argumnenta
      set check = `echo $1 | egrep '^[+-]?[0-9]+$'`
      if ( "$check" == "" ) then  # argument nie jest numerem
          echo
          echo '~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~'
          echo '~ '$1 ' nie jest liczbą całkowitą'
          echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
          echo
      else  # argument jest numerem
        if ( $1 > 1 ) then
            set num1 = 1
            set num2 = $1
        else
            set num1 = $1
            set num2 = 1
        endif

        set i = $num1
        set j = $num1
        set line = ""

        echo
        echo '~~ Tabliczka mnożenia od' $num1 'do' $num2 '~~'

        while ($i <= $num2)
            set line = "$i | "
            while ($j <= $num2)
                set value = `expr $i \* $j`
                set line = "$line $value"
                set j = `expr $j + 1`
            end

            echo $line
            set line = ""
            set i = `expr $i + 1`
            set j = $num1
        end

        echo
      endif

    else  # podano 2 lub więcej argumentów
      set check1 = `echo $1 | egrep '^[+-]?[0-9]+$'`
      set check2 = `echo $2 | egrep '^[+-]?[0-9]+$'`

      if ( "$check1" == "" ) then
            echo
            echo '~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~'
            echo '~ '$1 ' nie jest liczbą całkowitą'
            echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
            echo
      else
          if ( "$check2" == "" ) then
            echo
            echo '~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~'
            echo '~ '$2 ' nie jest liczbą całkowitą'
            echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
            echo
          else
                if ( $1 > $2 ) then
                    set num1 = $2
                    set num2 = $1
                else
                    set num1 = $1
                    set num2 = $2
                endif

                set i = $num1
                set j = $num1
                set line = ""

                echo
                echo '~~ Tabliczka mnożenia od' $num1 'do' $num2 '~~'

                while ($i <= $num2)
                    set line = "$i | "
                    while ($j <= $num2)
                        set value = `expr $i \* $j`
                        set line = "$line $value"
                        set j = `expr $j + 1`
                    end

                    echo $line
                    set line = ""
                    set i = `expr $i + 1`
                    set j = $num1
                end

                echo
          endif
      endif
    endif
endif