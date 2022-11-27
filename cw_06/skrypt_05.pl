#!/usr/bin/perl
#Daniel Wielgosz (g1)

if ((not @ARGV[0] =~ /^\d+$/) || (not @ARGV[1] =~ /^\d+$/ )){
    print("ERROR - zly argument liczbowy\n");
    exit;
} 

if (@ARGV[0] > @ARGV[1]){
    $nr1 = @ARGV[1] - 1;
    $nr2 = @ARGV[0] - 1;
} else {
    $nr1 = @ARGV[0] - 1;
    $nr2 = @ARGV[1] - 1;
}

shift(@ARGV);
shift(@ARGV);

while (<>) {
    @new_line = split(' ', $_);

    $i = 0;
    foreach my $word (@new_line){
        if ($i >= $nr1 && $i <= $nr2){
            printf("%s ", $word);  
        }
        $i += 1;
    }

    if ($i > 0) {
        print "\n";
    }
}