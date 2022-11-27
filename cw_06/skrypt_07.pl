#!/usr/bin/perl
#Daniel Wielgosz (g1)

if ((not @ARGV[1] =~ /^\d+$/) || (not @ARGV[2] =~ /^\d+$/ )){
    print("ERROR - zly argument liczbowy\n");
    exit;
}

if (@ARGV[1] > @ARGV[2]){
    $nr1 = @ARGV[2] - 1;
    $nr2 = @ARGV[1] - 1;
} else {
    $nr1 = @ARGV[1] - 1;
    $nr2 = @ARGV[2] - 1;
}

$separator = @ARGV[0];

shift(@ARGV);
shift(@ARGV);
shift(@ARGV);

while (<>) {
    @new_line = split($separator, $_);
    $i = 0;
    foreach my $word (@new_line){
        if ($i >= $nr1 && $i <= $nr2){
            $word =~ s/^\s+|\s+$//g;
            printf("%s--", $word);
        }
        $i += 1;
    }

    if ($i > 0) {
        print "\n";
    }
    reset('word');
}