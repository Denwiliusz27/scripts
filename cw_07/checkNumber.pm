# Daniel Wielgosz (g1)

package checkNumber;

use strict;
use warnings;

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(checkInteger checkOther);

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

1;
