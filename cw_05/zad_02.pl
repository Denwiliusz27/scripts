
#!/usr/bin/perl -n
#Daniel Wielgosz (g1)

while (<>) { 
            if(!/^#/) { 
             print "$.: $_" 
            }
}
