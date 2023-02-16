#!/usr/bin/perl -s
#Daniel Wielgosz (g1)

use utf8;
use Encode;
binmode(STDOUT, "encoding(UTF-8)");

use Cwd qw( abs_path );
use File::Basename qw( dirname );
use lib dirname(abs_path($0));
use des_helper;


#koduje wiadomość z pliku o podanej nazwie i zapisuje w nowym pliku
sub code_message {
    my($filename, @subkeys) = @_;
    my @blocks;
    my $nr = 0;

    open(FH, "<:encoding(UTF-8)", $filename);

    # odczytuje plik, zamianiam oczytane znaki na ciągi 16 bitowe
    while(<FH>) {
        foreach $char (split('', $_)){
            if (length(@blocks[$nr]) == 64){
                $nr += 1;
            }
            @blocks[$nr] = @blocks[$nr] . sprintf("%.16b", ord($char));
        }
    }

    # dopełniam ostatni blok do 64 bitów
    if (length(@blocks[$nr]) < 64){
        while (length(@blocks[$nr]) < 64){
            @blocks[$nr] = @blocks[$nr] . '0';
        }
    }

    my @c_blocks = ();

    # koduje bloki bitów za pomocą DES'a
    for $i (0..(scalar @blocks - 1)){
        $result = DES($blocks[$i], @subkeys);

        # wynik DES'a zapisuję jako bloki 8-bitowe
        for $i (0..7){
            push @c_blocks, substr($result, $i * 8, 8);
        }
    }

    $final_msg = '';

    #zamiana bloków bitów na znaki w utf-8
    for $i (0..(scalar @c_blocks - 1)){
        $value = oct("0b".$c_blocks[$i]);
        $final_msg = $final_msg . chr($value);
    }

    $filename =~ s{\.[^.]+$}{};
    $filename = $filename . '.zaszyfrowany';
    $new_filename =  $filename;

    open (OUT, ">$new_filename");
    binmode(OUT, ":utf8");
    print OUT $final_msg;
    close OUT;
    close FH;
}


# odkodowuje wiadomość z podanego pliku i zapisuje w pliku wynikowym
sub decode_message {
    my($filename, @subkeys) = @_;
    my @blocks;
    my $nr = 0;
    @decode_subkeys = ();

    # odwrócenie listy podkluczy
    for $i (0..(scalar @subkeys -1)){
        push @decode_subkeys, $subkeys[(scalar @subkeys -1) - $i];
    }

    open(FH, "<:encoding(UTF-8)", $filename);

    # odczytuje plik, zamianiam znaki na ciągi 16 bitów
    while(<FH>) {
        foreach $char (split('', $_)){
            if (length(@blocks[$nr]) == 64){
                $nr += 1;
            }
            @blocks[$nr] = @blocks[$nr] . sprintf("%.8b", ord($char));
        }
    }

    my @c_blocks = ();

    # koduje bloki za pomocą DES'a
    for $i (0..(scalar @blocks - 1)){
        $result = DES($blocks[$i], @decode_subkeys);

        for $i (0..3){
            push @c_blocks, substr($result, $i * 16, 16);
        }
    }

    $final_msg = '';

    #zamiana bloków bitów na znaki w utf-8
    for $i (0..(scalar @c_blocks - 1)){
        $value = oct("0b".$c_blocks[$i]);
        if ($value != 0 ){
            $final_msg = $final_msg . chr($value);
        }
    }

    $filename =~ s{\.[^.]+$}{};
    $filename = $filename . '.odszyfrowany';
    $new_filename =  $filename;

    if ($final_msg =~ /[^\x{0000}-\x{D7FF}]/) {
        $final_msg = Encode::encode('utf8', $final_msg);
    }

    open (OUT, ">$new_filename");
    binmode(OUT, ":utf8");
    print OUT $final_msg;
    close OUT;
    close FH;
}


sub main {
    $key = '';

    if ($h) {
        print_help();
        return;
    }

    for(my $n = 0; $n <= $#ARGV ; $n++){
        if (-e @ARGV[$n]) {
            if (!grep( /^@ARGV[$n]$/, @files)){
                push( @files, @ARGV[$n]);
            }
        } elsif ($key eq '' && $n == 0) {
            $key = @ARGV[$n];
        } else {
            printf("\n~~~~~~~~~~ERROR~~~~~~~~~~\n");
            printf("Plik '%s' nie istnieje\n", @ARGV[$n]);
            printf("~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
            return;
        }
    }

    if  (!$k || $key eq '') {
        printf("\n~~~~~~~~~~ERROR~~~~~~~~~~\n");
        printf("Nie podano żadnego klucza\n");
        printf("~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
        return;
    }

    if ($k && length($key) != 4){
        printf("\n~~~~~~~~~~ERROR~~~~~~~~~~\n");
        printf("Podany klucz ma nieodpowiednią długość\n");
        printf("~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
        return;
    }

    if (!$c && !$d){
        printf("\n~~~~~~~~~~ERROR~~~~~~~~~~\n");
        printf("Nie podano wszystkich argumentów\n");
        printf("~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
        return;
    }

    if ($c && $d){
        printf("\n~~~~~~~~~~ERROR~~~~~~~~~~\n");
        printf("Naeży wybrać tylko jedną z opcji '-c'/'-d'\n");
        printf("~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
        return;
    }

    $b_key = key_to_bits($key);
    @subkeys = key_schedule($b_key);
    $files_nr = scalar @files;

    if ($files_nr == 0){
        printf("\n~~~~~~~~~~ERROR~~~~~~~~~~\n");
        printf("Nie podano żadnego pliku\n");
        printf("~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
        return;
    }

    for(my $nr=0; $nr < $files_nr; $nr++) {
        if ($d){
            decode_message($files[$nr], @subkeys);
        } elsif ($c){
            code_message($files[$nr], @subkeys);
        }
    }
}

main();