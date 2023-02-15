# Daniel Wielgosz (g1)

package des_helper;

use strict;
use warnings;
use utf8;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(print_help key_to_bits);

sub print_help {
    printf("\n~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~\n");
    printf("Program służy do szyfracji oraz deszyfracji wiadomości przy pomocy algorytmu DES.\n");
    printf("\nW celu ZASZYFROWANIA wiadomości należy jako argumenty wywołania programu podać:\n");
    printf("- opcję '-c' deklarującą chęć zaszyfrowania wiadomości\n");
    printf("- klucz, będący ciągiem 4 dowolnych znaków. Klucz należy poprzedzić opcją '-k'\n");
    printf("- jeden lub kilka plików tekstowych zawierających wiadomości do zaszyfrowania\n");
    printf("Przykład wywołania:\n");
    printf("        perl des.pl -c -k kula test.txt\n");
    printf("\nW celu ODSZYFROWANIA wiadomości należy jako argumenty wywołania programu podać:\n");
    printf("- opcję '-d' deklarującą chęć odszyfrowania wiadomości\n");
    printf("- klucz, będący ciągiem 4 dowolnych znaków. Klucz należy poprzedzić opcją '-k'\n");
    printf("- jeden lub kilka plików tekstowych zawierających wiadomości do zaszyfrowania\n");
    printf("Przykład wywołania:\n");
    printf("        perl des.pl -d -k kula test.txt\n");
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
}

sub key_to_bits {
    my $key = $_[0];
    my $final = '';

    foreach my $char (split('', $key)){
        $final = $final . sprintf("%.16b", ord($char));
    }

    return $final;
}