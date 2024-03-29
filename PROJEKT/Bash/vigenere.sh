#!/bin/bash
#Daniel Wielgosz (g1)

declare -g -A dictionary=( ["a"]=0 ["ą"]=1 ["A"]=2 ["Ą"]=3 ["b"]=4 ["B"]=5 ["c"]=6 ["ć"]=7 ["C"]=8 ["Ć"]=9
                           ["d"]=10 ["D"]=11 ["e"]=12 ["ę"]=13 ["E"]=14 ["Ę"]=15 ["f"]=16 ["F"]=17 ["g"]=18
                           ["G"]=19 ["h"]=20 ["H"]=21 ["i"]=22 ["I"]=23 ["j"]=24 ["J"]=25 ["k"]=26 ["K"]=27
                           ["l"]=28 ["ł"]=29 ["L"]=30 ["Ł"]=31 ["m"]=32 ["M"]=33 ["n"]=34 ["N"]=35 ["ń"]=36
                           ["Ń"]=37 ["o"]=38 ["O"]=39 ["ó"]=40 ["Ó"]=41 ["p"]=42 ["P"]=43 ["q"]=44 ["Q"]=45
                           ["r"]=46 ["R"]=47 ["s"]=48 ["S"]=49 ["ś"]=50 ["Ś"]=51 ["t"]=52 ["T"]=53 ["u"]=54
                           ["U"]=55 ["v"]=56 ["V"]=57 ["w"]=58 ["W"]=59 ["x"]=60 ["X"]=61 ["y"]=62 ["Y"]=63
                           ["z"]=64 ["Z"]=65 ["ż"]=66 ["Ż"]=67 ["ź"]=68 ["Ź"]=69 ["1"]=70 ["2"]=71 ["3"]=72
                           ["4"]=73 ["5"]=74 ["6"]=75 ["7"]=76 ["8"]=77 ["9"]=78 ["0"]=79 )

display_help() {
  option=$1
  if [ "${option:0:2}" != './' ]; then
    option="bash $1"
  fi

  echo
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "Program służy do szyfrowania oraz odszyfrowywania wiadomości przy pomocy"
  echo "algorytmu Vigenere."
  echo "W celu ZASZYFROWANIA wiadomości należy podać jako argumenty "
  echo "wywołania programu:"
  echo "- opcję '-c' oznaczającą chęć zaszyfrowania wiadomości,"
  echo "- klucz, będący ciągiem dowolnych znaków. Klucz* należy poprzedzić opcją '-k',"
  echo "- jeden lub kilka plików tekstowych zawierających wiadomości do zaszyfrowania."
  echo "  Przed podaniem pierwszego pliku, należy podać również opcję '-f'"
  echo "Przykład wywołania programu:"
  echo "    $option -c -k mojklucz -f test.txt"
  echo "W wyniku takiego wywołania utworzony zostanie plik 'test.zaszyfrowany'"
  echo "z zaszyfrowaną wiadomością."
  echo
  echo "W celu ODSZYFROWANIA wiadomości należy podać jako argumenty "
  echo "wywołania programu:"
  echo "- opcję '-d' oznaczającą chęć odszyfrowania wiadomości,"
  echo "- klucz, będący ciągiem dowolnych znaków. Klucz* należy poprzedzić opcją '-k',"
  echo "- jeden lub kilka plików tekstowych zawierających wiadomości do odszyfrowania."
  echo "  Nazwę pierwszego pliku należy poprzedzić opcją '-f'"
  echo "Przykład wywołania programu:"
  echo "    $option -d -k mojklucz -f test.zaszyfrowany"
  echo "W wyniku takiego wywołania utworzony zostanie plik 'test.odszyfrowany'"
  echo "z odszyfrowaną wiadomością."
  echo
  echo "*klucz powinien składać się jedynie z kodów ASCII"
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


display_file_not_exist(){
  echo
  echo "~~~~~~ ERROR ~~~~~"
  echo "Plik '$1' nie istnieje"
  echo "~~~~~~~~~~~~~~~~~~"
  echo
}


# oblicza nowy znak na podstawie danego znaku i klucza
get_new_char(){
  char=$1
  nr=$2
  key=$3

  # pozycja czytanego znaku z wiadomości
  position=${dictionary[$char]}

  # wyliczenie przesunięcia jako nr pozycji w alfabecie znaku z klucza
  val=$((nr%${#key}))
  key_char=${key:val:1}
  shift=${dictionary[$key_char]}

  # wyliczenie pozycji nowego znaku w słowniku
  new_pos=$(( $position + $shift ))
  new_pos=$((new_pos%${#dictionary[@]}))

  new_char=${dictionary_r[$new_pos]}
  echo "$new_char"
}


# koduje wiadomość zapisaną w pliku za pomocą klucza
Vigenere_code(){
  file=$1
  key=$2
  result=""
  nr=0

  while IFS= read -r line || [ "$line" ]; do
    for (( i=0; i<${#line}; i++)); do
      char=${line:i:1}

      if [[ -v "dictionary[$char]" ]]; then
        new_char=$(get_new_char $char $nr $key)
        result="$result$new_char"
        nr=$(( $nr + 1 ))

      else
        result="$result$char"
      fi
    done

    newline=$'\n'
    result="$result${newline}"
  done <$file

  echo "$result"
}


#odkodowuje wiadomość z podanego pliku przy użyciu klucza
Vigenere_decode(){
  file=$1
  key=$2
  new_key=""

  #odwrócenie klucza
  for (( i=0; i<${#key}; i++)); do
    char=${key:i:1}
    value=$((${#dictionary[@]}-${dictionary[$char]}))
    new_char_pos=$(($value % ${#dictionary[@]}))
    new_key="$new_key${dictionary_r[$new_char_pos]}"
  done

  result=$(Vigenere_code $file $new_key)
  echo "$result"
}


files=()
option=""
file_option=false
compile_option=""
declare -g -A dictionary_r

# tworzę słownik par wartość - litera
for char in "${!dictionary[@]}"; do
  dictionary_r["${dictionary[$char]}"]=$char
done


#odczytywanie argumentów wywołania
for ((i=0;i<=$#;i++));
do
  if [ $i -eq 0 ]; then
    compile_option=${!i}
    continue
  fi

  if [ "${!i}" == "-h" ] || [ "${!i}" == "--help" ]; then
    display_help $compile_option
    exit 0
  fi

  a=$((i-1))

  if [ "${!i}" == "-c" ] || [ "${!i}" == "-d" ]; then
    if [ "$option" == "" ]; then
      option=${!i}
    else
      display_too_many_options_error
      exit 1
    fi
  fi

  if [ "${!a}" == "-k" ]; then
    key=${!i}
  fi

  if [ "${!a}" == "-f" ] || [ "$file_option" = true ]; then
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
  exit 1
fi

# kodowanie lub odkodowanie dla listy plików
for file in "${files[@]}"; do
  if [ -f "$file" ]; then

    if [ "$option" == "-c" ]; then
      result=$(Vigenere_code $file $key)

      new_file=$(basename -- "$file")
      new_file="${new_file%.*}"
      new_file="$new_file.zaszyfrowany"
      echo "$result" > "$new_file"

    else
      result=$(Vigenere_decode $file $key)

      new_file=$(basename -- "$file")
      new_file="${new_file%.*}"
      new_file="$new_file.odszyfrowany"
      echo "$result" > "$new_file"
    fi
  else
    display_file_not_exist $file
    exit 1
  fi
done

exit 0