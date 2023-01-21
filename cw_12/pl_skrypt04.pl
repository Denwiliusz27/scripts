#!/usr/bin/perl
#Daniel Wielgosz (g1)

use File::Find;
my @files;

sub collect_files {
    my $file = $File::Find::name;
    push @files, $file if (-f $file);
}

$wz = 0;
@temp_paths = [];
%paths = ();
%results = ();

for(my $i = 1; $i <= $#ARGV ; $i++) {
    if ( $ARGV[$i-1] eq '-d') {
        push (@temp_paths, $ARGV[$i]);

        if (not(exists($paths{$ARGV[$i]}))){
            $paths{$ARGV[$i]} = [];
        }
        if (not(exists($results{$ARGV[$i]}))){
            $results{$ARGV[$i]} = {};
        }
    } elsif ( $ARGV[$i] eq '-d' & $wz == 1) {
        $wz = 0;
        @temp_paths = [];
    } elsif (($ARGV[$i-2] eq '-d' & $ARGV[$i] ne '-d') | $wz == 1){
        $wz = 1;

        for my $key (@temp_paths[1..$#temp_paths]){
            push @{$paths{$key}}, $ARGV[$i];
        }
    }
}

foreach my $key (keys %paths){
    if ((-d $key ) | (-e $key)){
        find(\&collect_files, $key);

        foreach my $file (@files){
            open(FH, $file);
            while(<FH>){
                foreach $word (@{$paths{$key}}){
                    $count = () = $_ =~ /$word/g;

                    if ($count >= 1){
                        # print "jest $count : $_";
                        if (not(exists($results{$key}{$word}))){
                            $results{$key}{$word} = $count;
                        } else{
                            $results{$key}{$word} += $count;
                        }
                    }
                }
            }
        }
        @files = ();
    } else {
        print "ERROR - ścieżka '$key' nie istnieje\n";
    }
}

while (my ($key, $value) = each %results) {
    print "$key : ";
    while (my ($subkey, $subvalue) = each %$value) {
        print "'$subkey' - $subvalue ";
    }
    print "\n";
}