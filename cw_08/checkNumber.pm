# Daniel Wielgosz (g1)

package checkNumber;

use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(checkInteger checkOther checkGrade);

sub checkInteger {
    if ($_[0] =~  /^[+-]?\d+$/){
        return 1;
    } else {
        return 0;
    }
}

sub checkOther {
    if ($_[0] =~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([EeQqDd^]([+-]?\d+))?$/){
        return 1;
    } else {
        return 0;
    }
}

sub checkGrade {
    if (($_[0] =~ /^[+-]?\d*\.?\d*$/) | ($_[0] =~ /^\d*\.?\d*[+-]?$/)){
        if (($_[0] =~ /^[+]{1}\d*\.?\d*$/)){
            my @test = split /\+/, $_[0];
            my $value = sprintf("%.2f", $test[1]);
            if ($value == 0 || ( $value >= 2 && $value <= 5)){
                $value = $value + 0.25;
                return $value;
            } else {
                return -1;
            }
        } elsif (($_[0] =~ /^\d*\.?\d*[+]{1}$/)){
            my @test = split /\+/, $_[0];
            my $value = sprintf("%.2f", $test[0]);
            if ($value == 0 || ( $value >= 2 && $value <= 5)){
                $value = $value + 0.25;
                return $value;
            } else {
                return -1;
            }
        } elsif (($_[0] =~ /^[-]{1}\d*\.?\d*$/)) {
            my @test = split /\-/, $_[0];
            my $value = sprintf("%.2f", $test[1]);
            if ($value == 0 || ( $value >= 2 && $value <= 5)){
                $value = $value - 0.25;
                return $value;
            } else {
                return -1;
            }
        } elsif (($_[0] =~ /^\d*\.?\d*[-]{1}$/)) {
            my @test = split /\-/, $_[0];
            my $value = sprintf("%.2f", $test[0]);
            if ($value == 0 || ( $value >= 2 && $value <= 5)){
                $value = $value - 0.25;
                return $value;
            } else {
                return -1;
            }
        } elsif ($_[0] =~ /^\d*\.?\d*$/){
            $_[0] =~ /(\d+(?:\.\d+)?)/;
            my $value = $_[0];
            if ($value == 0 || ( $value >= 2 && $value <= 5)){
                return $value;
            } else {
                return -1;
            }
        }
    } else {
        return -1;
    }
}
1;
