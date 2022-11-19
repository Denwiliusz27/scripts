#!/usr/bin/perl -s
#Daniel Wielgosz (g1)

while(<>) {
    if (($c && $N) || ($p && $N && !$n)){
        if (!/^#/){
           print "$.: $_"
        } elsif (/^#/) {
            print ""
        }

        if($p && eof){
            $. = 0
        }

    } elsif ($n && $N){
        if (!/^#/){
           print "$.: $_"
        } elsif (/^#/) {
            print "";
            $. = $. - 1;
        }

        if($p && eof){
            $. = 0
        }
    } elsif ($p){
        if (!$N){
            print "$.: $_"
        }

        if(eof){
            $. = 0
        }
    } elsif ($N){
        if (!/^#/){
           print "$_"
        } elsif (/^#/) {
            print "";
        }
    } elsif ($c || $n) {
        print "$.: $_"
    } else {
        print "$_"
    }
}
