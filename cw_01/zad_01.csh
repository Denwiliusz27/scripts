#!/bin/tcsh
#Daniel Wielgosz (g1)


foreach arg ($argv)
  if ($arg:q == "-h" || $arg:q == "--help") then
    echo
    echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "~ Skrypt ma za zadanie wyświetlenie na ekranie"
    echo "~ loginu oraz imienia i nazwiska zalogowanego użytkownika"
    echo "~"
    echo "~ Użycie: tcsh zad_01.csh [-h --help] [-q --quiet]"
    echo "~ -h --help: wyświetla opis"
    echo "~ -q --quiet: kończy działanie programu"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo
    exit 0
  endif
end

foreach arg ($argv)
  if ($arg:q == "-q" || $arg:q == "--quiet") then
    exit 0
  endif
end

foreach arg ($argv)
  if ( $arg:q =~ -* ) then
    echo
    echo "ERROR: podano niewłaściwą opcję"
    echo
    echo "~~~~~~~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "~ Skrypt ma za zadanie wyświetlenie na ekranie"
    echo "~ loginu oraz imienia i nazwiska zalogowanego użytkownika"
    echo "~"
    echo "~ Użycie: tcsh zad_01.csh [-h --help] [-q --quiet]"
    echo "~ -h --help: wyświetla opis"
    echo "~ -q --quiet: kończy działanie programu"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo
    exit 1
  endif
end

echo
echo "Username: "$USER
set FULLNAME = `getent passwd $USER | cut -d : -f 5 | cut -d, -f1`
echo "Imie i nazwisko: " $FULLNAME
echo

