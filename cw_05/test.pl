#!/usr/bin/perl -s
# test
while (<>) {
    if ($c && $n) {
        if ($N && /^#/){
            print "";
        }
        else {
            print "$.: ";
        }
    }
    elsif ($c && $N && /^#/){
        print "";
    }
    elsif ($c) {
        print "$.: ";
    }
    elsif ($n && !/^#/) {

        print "$.: ";
    }
    elsif ($n && !/^#/) {
        $. = $. - 1;
    }

    if ($N && !/^#/){
        print "$_";
    }
    elsif ($N && /^#/){
        print "";
    }
    else{
        print "$_";
    }


    if ( $p & eof ) {
        $. = 0;
    }
}