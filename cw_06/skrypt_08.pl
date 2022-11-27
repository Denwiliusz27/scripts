#!/usr/bin/perl
#Daniel Wielgosz (g1)

if ((not @ARGV[1] =~ /^\d+$/) || (not @ARGV[2] =~ /^\d+$/ )){
    print("ERROR - zly argument liczbowy\n");
    exit;
}

$separator = @ARGV[0];
$nr1 = @ARGV[1] - 1;
$nr2 = @ARGV[2] - 1;
$file_name = @ARGV[3];

shift(@ARGV);
shift(@ARGV);
shift(@ARGV);
$line_nr = 1;

while (<>) {
    @new_line = split($separator, $_);

    $i = 0;
    foreach my $word (@new_line){
        $word =~ s/^\s+|\s+$//g;
        if ($i == $nr1 && $i == $nr2){
            $word1 = $word;
            $word2 = $word;
        } elsif ($i == $nr1) {
            $word1 = $word;
        } elsif ($i == $nr2){
            $word2 = $word;
        }
        $i += 1;
    }

    if ($word1 && $word2){
        printf("%s--%s\n", $word1, $word2);
    } else {
        printf("Brak danych w linii %d ('%s') \n", $line_nr, $file_name);
    }

    $line_nr += 1;
    reset('word');
}