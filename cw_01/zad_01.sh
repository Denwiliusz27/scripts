#!/bin/bash
#Daniel Wielgosz (g1)

help() {
  echo
  echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo "~ Skrypt ma za zadanie wyświetlenie na ekranie"
  echo "~ loginu oraz imienia i nazwiska zalogowanego użytkownika"
  echo "~"
  echo "~ Użycie: bash zad_01.sh [-h --help] [-q --quiet]"
  echo "~ -h --help: wyświetla opis"
  echo "~ -q --quiet: kończy działanie programu"
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  echo
}

get_data() {
  echo
  echo "Username: "$USER
  FULLNAME=$(getent passwd $USER | cut -d : -f 5 | cut -d, -f1)
  echo "Imie i nazwisko: " $FULLNAME
  echo
}

if [ $# -eq 0 ]
then
  get_data
else

# pętla sprawdza czy podano argument '-h' lub '--help'
  for var in "$@"
  do
    if [ "$var" == "-h" ] || [ "$var" == "--help" ]
    then
      help
      exit 0
    fi
  done

# jeśli nie podano argumentu '-h' lub '--help', program sprawdza czy podano '-q' lub '--qiet'
  for var in "$@"
  do
    if [ "$var" == "-q" ] || [ "$var" == "--quiet" ]
    then
      exit 0
    fi
  done

# program sprawdza czy nie podano innych argumentów
  for var in "$@"
  do
    if [ "${var::1}" == "-" ] || [ "${var::2}" == "--" ]
    then
      echo
      echo "ERROR: podano niewłaściwą opcję"
      help
      exit 1
    fi
  done

  get_data
  exit 0
fi









