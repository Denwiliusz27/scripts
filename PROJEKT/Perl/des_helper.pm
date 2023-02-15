# Daniel Wielgosz (g1)

package des_helper;

# use strict;
# use warnings;
use utf8;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(print_help key_to_bits key_schedule DES);


my @PC1 = (56, 48, 40, 32, 24, 16,  8,  0, 57, 49, 41, 33, 25, 17,  9,  1, 58,
       50, 42, 34, 26, 18, 10,  2, 59, 51, 43, 35, 62, 54, 46, 38, 30, 22,
       14,  6, 61, 53, 45, 37, 29, 21, 13,  5, 60, 52, 44, 36, 28, 20, 12,
        4, 27, 19, 11,  3);

my @PC2 = (13, 16, 10, 23,  0,  4,  2, 27, 14,  5, 20,  9, 22, 18, 11,  3,
       25, 7, 15,  6, 26, 19, 12,  1, 40, 51, 30, 36, 46, 54, 29, 39,
       50, 44, 32, 47, 43, 48, 38, 55, 33, 52, 45, 41, 49, 35, 28, 31);

my @IP = (57, 49, 41, 33, 25, 17,  9,  1, 59, 51, 43, 35, 27, 19, 11,  3, 61,
       53, 45, 37, 29, 21, 13,  5, 63, 55, 47, 39, 31, 23, 15,  7, 56, 48,
       40, 32, 24, 16,  8,  0, 58, 50, 42, 34, 26, 18, 10,  2, 60, 52, 44,
       36, 28, 20, 12,  4, 62, 54, 46, 38, 30, 22, 14,  6);

my @E = (31, 0, 1, 2, 3, 4, 3, 4, 5, 6, 7, 8, 7, 8, 9, 10, 11,
     12, 11, 12, 13, 14, 15, 16, 15, 16, 17, 18, 19, 20, 19, 20, 21, 22,
     23, 24, 23, 24, 25, 26, 27, 28, 27, 28, 29, 30, 31, 0);

my @P = (15, 6, 19, 20, 28, 11, 27, 16, 0, 14, 22, 25, 4, 17, 30, 9, 1,
     7, 23, 13, 31, 26, 2, 8, 18, 12, 29, 5, 21, 10, 3, 24);

my @FP = (39,  7, 47, 15, 55, 23, 63, 31, 38,  6, 46, 14, 54, 22, 62, 30, 37,
        5, 45, 13, 53, 21, 61, 29, 36,  4, 44, 12, 52, 20, 60, 28, 35,  3,
       43, 11, 51, 19, 59, 27, 34,  2, 42, 10, 50, 18, 58, 26, 33,  1, 41,
        9, 49, 17, 57, 25, 32,  0, 40,  8, 48, 16, 56, 24);

my @SBox0 = ([14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7],
         [0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8],
         [4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0],
         [15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13]);

my @SBox1 = ([15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10],
         [3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5],
         [0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15],
         [13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9]);

my @SBox2 = ([10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8],
         [13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1],
         [13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7],
         [1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12]);

my @SBox3 = ([7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15],
         [13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9],
         [10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4],
         [3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14]);

my @SBox4 = ([2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9],
         [14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6],
         [4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14],
         [11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3]);

my @SBox5 = ([12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11],
         [10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8],
         [9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6],
         [4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13]);

my @SBox6 = ([4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1],
         [13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6],
         [1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2],
         [6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12]);

my @SBox7 = ([13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7],
         [1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2],
         [7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8],
         [2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11]);

my @shift_table = (1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1 );


sub print_help {
    printf("\n~~~~~~~~~~~~~~~~~~ OPIS ~~~~~~~~~~~~~~~~~~~\n");
    printf("Program służy do szyfracji oraz deszyfracji wiadomości przy pomocy algorytmu DES.\n");
    printf("\nW celu ZASZYFROWANIA wiadomości należy jako argumenty wywołania programu podać:\n");
    printf("- opcję '-c' deklarującą chęć zaszyfrowania wiadomości\n");
    printf("- klucz, będący ciągiem 4 dowolnych znaków. Klucz należy poprzedzić opcją '-k',\n");
    printf("- jeden lub kilka plików tekstowych zawierających wiadomości do zaszyfrowania.\n");
    printf("Przykład wywołania:\n");
    printf("        perl des.pl -c -k baca test.txt\n");
    printf("W wyniku takiego wywołania utworzony zostanie plik 'test.zaszyfrowane' z zaszyfrowaną\n");
    printf("wiadomością.\n");

    printf("\nW celu ODSZYFROWANIA wiadomości należy jako argumenty wywołania programu podać:\n");
    printf("- opcję '-d' deklarującą chęć odszyfrowania wiadomości,\n");
    printf("- klucz, będący ciągiem 4 dowolnych znaków. Klucz* należy poprzedzić opcją '-k',\n");
    printf("- jeden lub kilka plików tekstowych zawierających wiadomości do zaszyfrowania.\n");
    printf("Przykład wywołania:\n");
    printf("        perl des.pl -d -k baca test.zaszyfrowany\n");
    printf("W wyniku takiego wywołania utworzony zostanie plik 'test.odszyfrowany' z odszyfrowaną\n");
    printf("wiadomością.\n");

    printf("\n* W przypadku chęci odkodowania wiadomości, podany klucz powinien być taki sam\n");
    printf("jak klucz, którego użyto przy zakodowaniu wiadomości.\n");
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

sub xor_binaries {
    my $result = '';
    my @bin1 = split("", $_[0]);
    my @bin2 = split("", $_[1]);

    for my $i (0..(scalar @bin1 -1)){
        if ($bin1[$i] == $bin2[$i]){
            $result = $result . '0';
        } else {
            $result = $result . '1';
        }
    }

    return $result;
}

sub permute {
    my($temp, @perm) = @_;
    my @txt = split("", $temp);
    my $permuted = '';

    for my $i (@perm){
        $permuted = $permuted . $txt[$i];
    }

    return $permuted;
}


sub shift_left {
    my @string = split("", $_[1]);
    my $n = $_[0];

    for $i (1..$n){
        my $temp = @string[0];

        for $j (0..(scalar @string - 1)){
            if ($j == (scalar @string - 1)){
                @string[$j] = $temp;
            } else {
                @string[$j] = @string[$j+1];
            }
        }
    }

    my $result = join '', @string;
    return $result;
}


sub key_schedule {
    my @subkeys = ();
    my $key = $_[0];

    my $new_key = permute($key, @PC1);
    my $l_key = substr($new_key, 0, length($new_key)/2);
    my $r_key = substr($new_key, length($new_key)/2, length($new_key));

    for $i (0..(scalar @shift_table - 1)){
        my $new_subkey = '';

        $l_key= shift_left($shift_table[$i], $l_key);
        $r_key = shift_left($shift_table[$i], $r_key);
        $new_subkey = $l_key . $r_key;

        push @subkeys, permute($new_subkey, @PC2);
    }

    return @subkeys
}


sub F {
    $msg = $_[0];
    $subkey = $_[1];
    my @sboxes = ();

    my $right = permute($msg, @E);
    my $right_xor = xor_binaries($right, $subkey);

    $length = int(length($right_xor) / 8);
    for $i (0..7){
        push @sboxes, substr($right_xor, $i * $length, $length)
    }

    $sbox_str = '';

    for $i (0..7){
        $elem = $sboxes[$i];

        $first_last = substr($elem, 0, 1) . substr($elem, 5, 1);
        $row_nr = oct("0b" . $first_last);

        $middle = substr($elem, 1, 4);
        $column_nr = oct("0b" . $middle);

        if ($i == 0){
            $new_elem = $SBox0[$row_nr][$column_nr];
        } elsif ($i == 1){
            $new_elem = $SBox1[$row_nr][$column_nr];
        } elsif ($i == 2){
            $new_elem = $SBox2[$row_nr][$column_nr];
        } elsif ($i == 3){
            $new_elem = $SBox3[$row_nr][$column_nr];
        } elsif ($i == 4){
            $new_elem = $SBox4[$row_nr][$column_nr];
        } elsif ($i == 5){
            $new_elem = $SBox5[$row_nr][$column_nr];
        } elsif ($i == 6){
            $new_elem = $SBox6[$row_nr][$column_nr];
        } else {
            $new_elem = $SBox7[$row_nr][$column_nr];
        }

        $b_new_elem = sprintf("%.4b", $new_elem);
        $sbox_str = $sbox_str . $b_new_elem;
    }

    $final = permute($sbox_str, @P);
    return $final;
}


sub Feistel {
    my($message, @subkeys) = @_;
    $length = int(length($message) / 2);

    $l_msg = substr($message, 0, $length);
    $r_msg = substr($message, $length, $length);

    for $i (0..15){
        $r_msg_f = F($r_msg, $subkeys[$i]);

        $l_xor = xor_binaries($l_msg, $r_msg_f);

        if ($i < 15){
            $l_msg = $r_msg;
            $r_msg = $l_xor;
        }
    }

    $final = $l_xor . $r_msg;
    return $final;
}


sub DES {
    my($msg,@subkeys) = @_;

    $message = permute($msg, @IP);
    $feistel = Feistel($message, @subkeys);
    $final = permute($feistel, @FP);

    return $final;
}