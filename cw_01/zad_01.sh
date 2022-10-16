#!/bin/bash
#Daniel Wielgosz (g1)

help() {
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "~ Skrypt ma za zadanie wyświetlenie na ekranie"
  echo "~ loginu oraz imienia i nazwiska zalogowanego użytkownika"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}

get_data() {
  echo "Username: "$USER
  FULLNAME=$(getent passwd $USER | cut -d : -f 5 | cut -d, -f1)
  echo "" $FULLNAME
}

if [ $# -eq 0 ]
then
  get_data
else

# pętla sprawdza czy podano argument '-h' lub '--help'
  echo "############### sprawdzam help ####################"
  for var in "$@"
  do
    if [ "$var" == "-h" ] || [ "$var" == "--help" ]
    then
      help
      exit 0
    fi
  done
  echo "###################################################"

# jeśli nie podano argumentu '-h' lub '--help', program sprawdza czy podano '-q' lub '--qiet'
  echo "############### sprawdzam quiet ####################"
  for var in "$@"
  do
    if [ "$var" == "-q" ] || [ "$var" == "--quiet" ]
    then
      echo "koncze dzialanie :("
      exit 0
    fi
  done
  echo "###################################################"

# program sprawdza czy nie podano innych argumentów
  echo "############### sprawdzam inne ####################"
  for var in "$@"
  do
    if [ "${var::1}" != "-" ]
    then
      get_data
      exit 0
    else
      echo "ERROR: Nie rozumiem takiej opcji :("
      help
      exit 1
    fi
  done
  echo "###################################################"
fi









