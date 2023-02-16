#!/bin/bash
#Daniel Wielgosz (g1)

export LANG=C.UTF-8

declare -g -A dictionary=( ["a"]=1 ["ą"]=2 ["A"]=3 ["Ą"]=4 ["b"]=5 ["B"]=6 ["c"]=7 ["ć"]=8 ["C"]=9 ["Ć"]=10
                           ["d"]=11 ["D"]=12 ["e"]=13 ["ę"]=14 ["E"]=15 ["Ę"]=16 ["f"]=17 ["F"]=18 ["g"]=19
                           ["G"]=20 ["h"]=21 ["H"]=22 ["i"]=23 ["I"]=24 ["j"]=25 ["J"]=26 ["k"]=27 ["K"]=28
                           ["l"]=29 ["ł"]=30 ["L"]=31 ["Ł"]=32 ["m"]=33 ["M"]=34 ["n"]=35 ["N"]=36 ["ń"]=37
                           ["Ń"]=38 ["o"]=49 ["O"]=50 ["ó"]=51 ["Ó"]=52 ["p"]=53 ["P"]=54 ["q"]=55 ["Q"]=56
                           ["r"]=57 ["R"]=58 ["s"]=59 ["S"]=60 ["ś"]=61 ["Ś"]=62 ["t"]=63 ["T"]=64 ["u"]=65
                           ["U"]=66 ["v"]=67 ["V"]=68 ["w"]=69 ["W"]=70 ["x"]=71 ["X"]=72 ["y"]=73 ["Y"]=74
                           ["z"]=75 ["Z"]=76 ["ż"]=77 ["Ż"]=78 ["ź"]=79 ["Ź"]=80 [","]=81 ["."]=82 ["?"]=83
                           [":"]=84 [";"]=85 ["("]=86 [")"]=87 ["["]=88 ["]"]=89 ["{"]=90 ["}"]=91 ["-"]=92
                           ["+"]=93 ["="]=94 ["1"]=95 ["2"]=96 ["3"]=97 ["4"]=98 ["5"]=99 ["6"]=100 ["7"]=101
                           ["8"]=102 ["9"]=103 ["0"]=104 )

display_help() {
  echo
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "Program służy do szyfrowania oraz odszyfrowywania wiadomości"
  echo "przy pomocy algorytmu Vigenere."
  echo "W celu ZASZYFROWANIA wiadomości należy podać jako argumenty "
  echo "wywołania programu:"
  echo "- opcję '-c' oznaczającą chęć zaszyfrowania wiadomości,"
  echo "- klucz, będący ciągiem dowolnych znaków. Klucz należy poprzedzić opcją '-k',"
  echo "- jeden lub kilka plików tekstowych zawierających wiadomości do zaszyfrowania."
  echo "  Przed podaniem pierwszego pliku, należy podać również opcję '-f'"
  echo "Przykład wywołania programu:"
  echo "    perl -c -k mojklucz -f test.txt"
  echo "W wyniku takiego wywołania utworzony zostanie plik 'test.zaszyfrowany'"
  echo "z zaszyfrowaną wiadomością."
  echo
  echo "W celu ODSZYFROWANIA wiadomości należy podać jako argumenty "
  echo "wywołania programu:"
  echo "- opcję '-d' oznaczającą chęć odszyfrowania wiadomości,"
  echo "- klucz, będący ciągiem dowolnych znaków. Klucz należy poprzedzić opcją '-k',"
  echo "- jeden lub kilka plików tekstowych zawierających wiadomości do odszyfrowania."
  echo "  Nazwę pierwszego pliku należy poprzedzić opcją '-f'"
  echo "Przykład wywołania programu:"
  echo "    perl -d -k mojklucz -f test.zaszyfrowany"
  echo "W wyniku takiego wywołania utworzony zostanie plik 'test.odszyfrowany'"
  echo "z odszyfrowaną wiadomością."
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
}


display_no_option_error() {
  echo
  echo "~~~~~~ ERROR ~~~~~"
  echo "Nie podano żadnej opcji"
  echo "~~~~~~~~~~~~~~~~~~"
  echo
}

display_too_many_options_error(){
  echo
  echo "~~~~~~ ERROR ~~~~~"
  echo "Należy wybrać tylko jedną opcję '-c' lub '-d'"
  echo "~~~~~~~~~~~~~~~~~~"
  echo
}

display_no_key_error(){
  echo
  echo "~~~~~~ ERROR ~~~~~"
  echo "Nie podano klucza"
  echo "~~~~~~~~~~~~~~~~~~"
  echo
}

display_no_files_error(){
  echo
  echo "~~~~~~ ERROR ~~~~~"
  echo "Nie podano żadnego pliku"
  echo "~~~~~~~~~~~~~~~~~~"
  echo
}

display_few_arg_error(){
  echo
  echo "~~~~~~ ERROR ~~~~~"
  echo "Podano za mało argumentów"
  echo "~~~~~~~~~~~~~~~~~~"
  echo
}

Vigenere_code(){
  message=$0
  key=$1


}


files=()
option=""
file_option=false

for ((i=1;i<=$#;i++));
do
  if [ "${!i}" == "-h" ] || [ "${!i}" == "--help" ]; then
    display_help
    exit 0
  fi

  a=$((i-1))

  echo "i: ${!i}"
  echo "a: ${!a}"

  if [ "${!i}" == "-c" ] || [ "${!i}" == "-d" ]; then
    if [ "$option" == "" ]; then
      echo "jest opcja ${!i}"
      option=${!i}
    else
      display_too_many_options_error
      exit 1

    fi
  fi

  if [ "${!a}" == "-k" ]; then
    echo "mam klucz: ${!i}"
    key=${!i}
  fi


  if [ "${!a}" == "-f" ] || [ "$file_option" = true ]; then
    echo "mam plik "
    files+=(${!i})
    file_option=true
  fi
done

# sprawdzanie błędów
if [ "$option" == "" ]; then
  display_no_option_error
  exit 1
fi

if [ "$key" == "" ]; then
  display_no_key_error
  exit 1
fi

if [ ${#files[@]} -eq 0 ]; then
  display_no_files_error
  exit 1
fi

if [ $# -lt 5 ]; then
  display_few_arg_error
fi

for file in "${files[@]}"; do
  echo "plik: $file"
done

