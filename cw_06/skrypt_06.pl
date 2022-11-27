#!/usr/bin/perl
#Daniel Wielgosz (g1)

if ((not @ARGV[0] =~ /^\d+$/) || (not @ARGV[1] =~ /^\d+$/ )){
    print("ERROR - zly argument liczbowy\n");
    exit;
} 

$nr1 = @ARGV[0] - 1;
$nr2 = @ARGV[1] - 1;
$file_name = @ARGV[2];

shift(@ARGV);
shift(@ARGV);
$line_nr = 1;

while (<>) {
    @new_line = split(' ', $_);

    $i = 0;
    foreach my $word (@new_line){
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
        printf("%s %s \n", $word1, $word2);
    } else {
        printf("Brak danych w linii %d ('%s') \n", $line_nr, $file_name);
    }

    $line_nr += 1;
    reset('word');
}