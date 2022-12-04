#!/usr/bin/perl -s
#Daniel Wielgosz (g1)

@files = ();
$w_word_c = 0 ;
$w_line_c = 0 ;
$w_char_c = 0 ;
$w_integer_c = 0;
$w_all_numbers = 0;
$i_option = false;

for(my $n = 0; $n <= $#ARGV ; $n++){
    if (-e @ARGV[$n] ) {
        push( @files, @ARGV[$n]);
    }
}

$files_nr = scalar @files;

# 1e-712 1E-3 1D-3 1d-3 1Q-3 1q-3  1^2 1.2

for(my $nr=0; $nr < $files_nr; $nr++){
    open(FH, @files[$nr]);
    $word_c = 0 ;
    $line_c = 0 ;
    $char_c = 0 ;
    $integer_c = 0;
    $all_numbers = 0;


    # loop po liniach pliku
    while(<FH>){
        @new_line = split(' ', $_);

        next if($e && (index(@new_line[0], '#') != -1));

        $line_c++;
        $char_c += length($_);

        foreach my $word (@new_line){
            $word_c += 1;

            if ($word =~  /^[+-]?\d+$/){
                $integer_c += 1;
                $all_numbers += 1;
            } elsif ($word =~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([EeQqDd^]([+-]?\d+))?$/){
                $all_numbers += 1;
            }
        }
    }

    if ($files_nr > 1){
        $w_word_c += $word_c;
        $w_line_c += $line_c;
        $w_char_c += $char_c;
        $w_integer_c += $integer_c;
        $w_all_numbers += $all_numbers;
    }

    printf("\nFile: %s -- lines: %d, words: %d, characters: %d", @files[$i], $line_c, $word_c, $char_c);
    if ($i){
        printf(", integers: %d", $integer_c);
    }
    if ($d){
        printf(", all numbers: %d", $all_numbers);
    }
    printf("\n");

}

if ($files_nr > 1){
    printf("\nALL FILES -- lines: %d, words: %d, characters: %d", $w_line_c, $w_word_c, $w_char_c, $w_integer_c, $w_all_numbers);
    if ($i){
        printf(", integers: %d", $w_integer_c);
    }
    if ($d){
        printf(", all numbers: %d", $w_all_numbers);
    }
    printf("\n\n");

} else {
    printf("\n");
}
