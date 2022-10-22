#!/bin/tcsh
#Daniel Wielgosz (g1)

set i = 1
set j = 1
set line = ""

echo
echo '~~ Tabliczka mnożenia od 1 do 9 ~~'

while ($i <= 9)
    while ($j <= 9)
        set value = `expr $i \* $j`
        set line = "$line $value"
        set j = `expr $j + 1`
    end

    echo $line
    set line = "" 
    set i = `expr $i + 1`
    set j = 1
end

echo