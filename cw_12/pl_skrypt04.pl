#!/usr/bin/perl
#Daniel Wielgosz (g1)

$wz = 0;
@temp_paths = [];
%paths = ();
%results = ();

for(my $i = 1; $i <= $#ARGV ; $i++) {
    print "~~~~~~~~~~~~~~~~~~~~~\n";
    print "arg: @ARGV[$i] \n";
    if ( $ARGV[$i-1] eq '-d') {
        # if ((-d $ARGV[$i] ) | (-e $ARGV[$i])){
        #     print "scieżka $key istnieje\n";
        # } else {
        #     print "ERROR - ścieżka '$ARGV[$i]' nie istnieje\n";
        # }

        print "wstawiam $ARGV[$i] do temp: ";
        push (@temp_paths, $ARGV[$i]);
        print "@temp_paths[1]\n";

        if (not(exists($paths{$ARGV[$i]}))){
            print "wstawiam pusta tablice: ";
            $paths{$ARGV[$i]} = [];
            print "$paths{$ARGV[$i]} \n"
        }
        if (not(exists($results{$ARGV[$i]}))){
            print"wstawiam pusty slownik: ";
            $results{$ARGV[$i]} = ();
            print "$results{$ARGV[$i]}\n";
        }
    } elsif ( $ARGV[$i] eq '-d' & $wz == 1) {
        print"zeruje\n";
        $wz = 0;
        @temp_paths = [];
    } elsif (($ARGV[$i-2] eq '-d' & $ARGV[$i] ne '-d') | $wz == 1){
        print"wstawiam $ARGV[$i] z temp do slownika: \n";
        $wz = 1;

        for my $key (@temp_paths){
            push @{$paths{$key}}, $ARGV[$i];
            print "$key : @{$paths{$key}} \n";
        }

        # for (@temp_paths[1 .. $#temp_paths]){
        #     push @{$paths{@temp_path[$_]}}, $ARGV[$i];
        #     print "@temp_path[$_] : @{$paths{@temp_path[$_]}} \n";
        # }
    }
}

foreach my $key (keys %paths) {
    my $value = $paths{$key};
    print "Key: $key\n";
    print "Values: ";
    foreach my $element (@$value) {
        print "$element ";
    }
    print "\n";
}

# foreach my $key (keys %paths){
#     if ((-d $key ) | (-e $key)){
#         print "scieżka $key istnieje\n";
#     } else {
#         print "ERROR - ścieżka '$key' nie istnieje\n";
#     }
# }

