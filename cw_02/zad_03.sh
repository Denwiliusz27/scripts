#!/bin/bash
#Daniel Wielgosz (g1)

display_help() {
  echo
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "~ Skrypt ma za zadanie wykonanie podanej operacji dla "
  echo "~ zakresu podanego przez dwa argumenty"
  echo "~"
  echo "~ Użycie: bash zad_03.sh [-h --help] [num1] [oper] [num2]"
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
}

number_error() {
  echo
  echo '~~~~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~~~'
  echo '~' $1 ' nie jest numerem'
  echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  echo
}

args_number_error() {
  echo
  echo '~~~~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~~~'
  echo '~ Wpisano niewłaściwą ilość argumentów.'
  echo '~ Należy wpisać 2 wartości numeryczne'
  echo '~ oraz jeden operator'
  echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  echo
}

operator_error() {
  echo
  echo '~~~~~~~~~~~~~ ERROR ~~~~~~~~~~~~~'
  echo '~ Nie podano właściwego operatora'
  echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  echo
}

number='^[+-]?[0-9]+$'
not_number='*[~0-9]*'
values=()
operator=""

for var in "$@"
do
  if [ "$var" == "-h" ] || [ "$var" == "--help" ]
  then
    display_help
    exit 0
  fi
done


for arg in "${@:1:3}"
do
  case "$arg" in
    [+\-*/^%])
      operator=$arg;
      continue ;;
    "m")
      operator=\*
      continue ;;
  esac

  if [[ $arg =~ $number ]]; then
    values+=($arg)
  else
    number_error $arg
    display_help
    exit 1
  fi

done

if [ "${#values[@]}" -ne "2" ]; then
  args_number_error
  display_help
  exit 1
fi

if [ "$operator" = "" ]; then
  echo
  operator_error
  display_help
  exit 2
fi

val1=${values[0]}
val2=${values[1]}

if [ "$val1" -gt "$val2" ]; then
  for (( i=$val1; i>=$val2; i-- ))
  do
      for (( j=$val1; j>=$val2; j-- ))
      do
          if [ $j -eq $val1 ]; then
            printf " %d | " $i
          fi

          if [ "$operator" = "/" ] || [ "$operator" = "%" ] && [ "$j" = "0" ] ; then
              printf "NaN "
          elif [ "$operator" = "^" ] && [ "$i" = 0 ] && [ "$j" -lt 0 ] ; then
              printf "NaN "
          else
            echo "$i $operator $j" | bc | tr '\n' ' '
          fi
      done
      printf "\n"
  done

else
  for (( i=$val1; i<=$val2; i++ ))
  do
      for (( j=$val1; j<=$val2; j++ ))
      do
          if [ $j -eq $val1 ]; then
            printf " %d | " $i
          fi

          if [ "$operator" = "/" ] || [ "$operator" = "%" ] && [ "$j" = "0" ] ; then
              printf "NaN "
          elif [ "$operator" = "^" ] && [ "$i" = 0 ] && [ "$j" -lt 0 ] ; then
              printf "NaN "
          else
            echo "$i $operator $j" | bc | tr '\n' ' '
          fi
      done
      printf "\n"
  done
fi
echo