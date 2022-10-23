#!/bin/tcsh
#Daniel Wielgosz (g1)

set display_help = "nie podano nic\
co warte jest komentarza\
i kropka"


set values = ()
set operator = ""

foreach arg ($argv)
  if ($arg:q == "-h" || $arg:q == "--help") then
      echo
      echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      echo "~ Skrypt ma za zadanie wykonanie podanej operacji dla "
      echo "~ zakresu podanego przez dwa argumenty"
      echo "~"
      echo "~ Użycie: tcsh zad_03.csh [-h --help] [num1] [oper] [num2]"
      echo "~   -h --help: wyświetla opis"
      echo "~   num1: pierwsza liczba"
      echo "~   oper: operator"
      echo "~   num2: druga liczba"
      echo "~"
      echo "~ Dostepne operacje:"
      echo "~ +: dodawanie"
      echo "~ -: odejmowanie"
      echo "~ m: mnożenie"
      echo "~ /: dzielenie"
      echo "~ ^: potęgowanie"
      echo "~ %: dzielenie modulo"
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      echo
    exit 0
  endif
end

set i = 0

foreach arg ($argv)
  set i = `expr $i + 1`

  if ($i > 3) then
    break
  else
    set check_nmb = `echo ${arg} | egrep '^[+-]?[0-9]+$'`
    if ( "$check_nmb" != "" ) then
      set values = ($values $arg)
    else
      if ( "$arg" == "-" || "$arg" == "+" || "$arg" == "/" || "$arg" == "^" || "$arg" == "%" ) then
        set operator = $arg
      else if ( "$arg" == "m" ) then
        set operator = \*
      else
        echo
        echo "~~~~~~~~~~~ ERROR ~~~~~~~~~~~"
        echo "Wpisano niewłaściwy argument"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo
        echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "~ Skrypt ma za zadanie wykonanie podanej operacji dla "
        echo "~ zakresu podanego przez dwa argumenty"
        echo "~"
        echo "~ Użycie: tcsh zad_03.csh [-h --help] [num1] [oper] [num2]"
        echo "~   -h --help: wyświetla opis"
        echo "~   num1: pierwsza liczba"
        echo "~   oper: operator"
        echo "~   num2: druga liczba"
        echo "~"
        echo "~ Dostepne operacje:"
        echo "~ +: dodawanie"
        echo "~ -: odejmowanie"
        echo "~ m: mnożenie"
        echo "~ /: dzielenie"
        echo "~ ^: potęgowanie"
        echo "~ %: dzielenie modulo"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo

        exit 1
      endif
    endif
  endif
end

if ($i == 0) then
  echo
  echo "~~~~~~~~~~~ ERROR ~~~~~~~~~~~"
  echo "Niewłaściwa ilość argumentów"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "~ Skrypt ma za zadanie wykonanie podanej operacji dla "
  echo "~ zakresu podanego przez dwa argumenty"
  echo "~"
  echo "~ Użycie: tcsh zad_03.csh [-h --help] [num1] [oper] [num2]"
  echo "~   -h --help: wyświetla opis"
  echo "~   num1: pierwsza liczba"
  echo "~   oper: operator"
  echo "~   num2: druga liczba"
  echo "~"
  echo "~ Dostepne operacje:"
  echo "~ +: dodawanie"
  echo "~ -: odejmowanie"
  echo "~ m: mnożenie"
  echo "~ /: dzielenie"
  echo "~ ^: potęgowanie"
  echo "~ %: dzielenie modulo"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
  exit 1

else if ( ${#values} < 2 ) then
  echo
  echo "~~~~~~~~~~~ ERROR ~~~~~~~~~~~"
  echo "Podano niewłaściwą ilość liczb"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "~ Skrypt ma za zadanie wykonanie podanej operacji dla "
  echo "~ zakresu podanego przez dwa argumenty"
  echo "~"
  echo "~ Użycie: tcsh zad_03.csh [-h --help] [num1] [oper] [num2]"
  echo "~   -h --help: wyświetla opis"
  echo "~   num1: pierwsza liczba"
  echo "~   oper: operator"
  echo "~   num2: druga liczba"
  echo "~"
  echo "~ Dostepne operacje:"
  echo "~ +: dodawanie"
  echo "~ -: odejmowanie"
  echo "~ m: mnożenie"
  echo "~ /: dzielenie"
  echo "~ ^: potęgowanie"
  echo "~ %: dzielenie modulo"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
  exit 1

else if ("$operator" == "") then
  echo
  echo "~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~"
  echo "Nie podano właściwego operatora"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "~ Skrypt ma za zadanie wykonanie podanej operacji dla "
  echo "~ zakresu podanego przez dwa argumenty"
  echo "~"
  echo "~ Użycie: tcsh zad_03.csh [-h --help] [num1] [oper] [num2]"
  echo "~   -h --help: wyświetla opis"
  echo "~   num1: pierwsza liczba"
  echo "~   oper: operator"
  echo "~   num2: druga liczba"
  echo "~"
  echo "~ Dostepne operacje:"
  echo "~ +: dodawanie"
  echo "~ -: odejmowanie"
  echo "~ m: mnożenie"
  echo "~ /: dzielenie"
  echo "~ ^: potęgowanie"
  echo "~ %: dzielenie modulo"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
  exit 2
endif

set val1 = $values[1]
set val2 = $values[2]

if ( "$val1" > "$val2" ) then
  set i = $val1
  set j = $val1

  echo
  while ($i >= $val2)
      echo "$i | " | tr '\n' ' '

      while ($j >= $val2)

          if ( ("$operator" == "/" ||  "$operator" == "%" ) && ( "$j" == "0" )) then
            echo "NaN" | tr '\n' ' '
          else if ( "$operator" == "^"  &&  "$i" == 0  &&  "$j" < 0 ) then
            echo "NaN" | tr '\n' ' '
          else
            echo "$i $operator $j" | bc | tr '\n' ' '
          endif
          set j = `expr $j - 1`
      end

      set i = `expr $i - 1`
      set j = $val1
      echo
  end
  echo
else
  set i = $val1
  set j = $val1

  echo
  while ($i <= $val2)
      echo "$i | " | tr '\n' ' '

      while ($j <= $val2)

          if ( ("$operator" == "/" ||  "$operator" == "%" ) && ( "$j" == "0" )) then
            echo "NaN" | tr '\n' ' '
          else if ( "$operator" == "^"  &&  "$i" == 0  &&  "$j" < 0 ) then
            echo "NaN" | tr '\n' ' '
          else
            echo "$i $operator $j" | bc | tr '\n' ' '
          endif
          set j = `expr $j + 1`
      end

      set i = `expr $i + 1`
      set j = $val1
      echo
  end
  echo
endif


