#!/usr/bin/perl
#Daniel Wielgosz (g1)

use Cwd qw( abs_path );
use File::Basename qw( dirname );
use lib dirname(abs_path($0));
use checkNumber;

sub changeName {
    $name = lc($_[0]);
    $name =~ s/(\w+)/\u$1/g;
    return $name;
}


sub printError {
    $_[2]=~ s/^\s+|\s+$//g;
    printf("ERROR w linii %d (%s): '%s'\n", $_[1], $_[0], $_[2]);
}

@files = ();

for(my $i = 0; $i <= $#ARGV ; $i++){

    if (-e @ARGV[$i] ) {
        push( @files, @ARGV[$i]);
    }
}

$files_nr = scalar @files;

for(my $i=0; $i < $files_nr; $i++){    
    $line_nr = 1;
    %grades = ();

    open(FH, @files[$i]);

    # loop po liniach pliku
    while(<FH>){
        @new_line = split(' ', $_);

        if (scalar @new_line < 3){
            printError(@files[$i], $line_nr, $_);
        } else {
            $name = changeName($new_line[0])." ".changeName($new_line[1]);
            $value = checkGrade($new_line[2]);

            if ($value != -1){
                if (exists($grades{$name})){
                    @{$grades{$name}}[0] += $value;
                    push ( @{$grades{$name}}, $new_line[2]);
                } else {
                    $grades{$name} = [];
                    push ( @{$grades{$name}}, 0.0);
                    @{$grades{$name}}[0] += $value;
                    push ( @{$grades{$name}}, $new_line[2]);
                }
            } else {
                printError(@files[$i], $line_nr, $_);
            }
        }

        $line_nr++;
    }

    @files[$i] =~ s{\.[^.]+$}{};
    @files[$i] = @files[$i].'.oceny';
    $file_name =  @files[$i];

    open(OF, '>' , "$file_name" ) or die 'ERROR: nie udalo sie utworzyc pliku\n';

    $all_avg = 0;
    foreach $k (sort keys %grades){
        print OF "$k: ";

        $grades_nr = scalar @{$grades{$k}};

        for(my $nr = 1; $nr < $grades_nr; $nr++){
            print OF "@{$grades{$k}}[$nr] ";
        }

        $avg = @{$grades{$k}}[0] / ($grades_nr-1);
        $avg = sprintf("%.2f", $avg);
        $all_avg += $avg;
        print OF ": $avg \n";
    }

    @keys = keys %grades;
    $keys_nr = scalar @keys;
    $all_avg = $all_avg / $keys_nr;
    $all_avg = sprintf("%.2f", $all_avg);

    print OF "\nŚrednia wszystkich: $all_avg \n";

    close(OF);
}