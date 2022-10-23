#!/bin/bash
#Daniel Wielgosz (g1)

display_help() {
  echo
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "~ Skrypt ma za zadanie wyświetlenie tabelki mnożenia od"
  echo "~ pierwszego do drugiego argumentu"
  echo "~"
  echo "~ Użycie: bash zad_02.sh [-h --help] [num1] [num2]"
  echo "~   -h --help: wyświetla opis"
  echo "~   num1: pierwsza liczba"
  echo "~   num2: druga liczba"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
}

single_arg_error() {
  echo
  echo '~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~'
  echo '~ '$1 ' nie jest liczbą całkowitą'
  echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  echo
}


print_multiplication_array() {
  echo
  echo '~~ Tabliczka mnożenia od ' $1 ' do ' $2 ' ~~'

  for (( i=$1; i<=$2; i++ ))
  do
      for (( j=$1; j<=$2; j++ ))
      do
          if [ $j -eq $1 ]; then
            printf " %d | " $i
          fi

          val=$(($i*$j))
          printf "%d " $val
      done
      printf "\n"
  done

  echo
}


number='^[+-]?[0-9]+$'

if [ $# -eq 0 ]; then  # jeśli nie podano argumentów, wyświetl tabelke 1x9
  print_multiplication_array 1 9

else
  # pętla sprawdza czy podano argument '-h' lub '--help'
  for var in "$@"
  do
    if [ "$var" == "-h" ] || [ "$var" == "--help" ]
    then
      display_help
      exit 0
    fi
  done

  if [ $# -eq 1 ]; then  # jeśli podano 1 argument
    if [[ $1 =~ $number ]]; then  # sprawdzenie czy argument jest numerem
      if [ $1 -gt 1 ]; then
        print_multiplication_array 1 $1
      else
        print_multiplication_array $1 1
      fi

    else  # jeśli argument nie jest numerem, wyświetl komunikat błędu
      single_arg_error $1
      exit 1
    fi

  else
    if [[ $1 =~ $number ]]; then
      if [[ $2 =~ $number ]]; then
        if [ $1 -gt $2 ]; then
          print_multiplication_array $2 $1
        else
          print_multiplication_array $1 $2
        fi
      else
        single_arg_error $2
        exit 1
      fi
    else
      single_arg_error $1
      exit 1
    fi
  fi
fi