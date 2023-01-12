#!/usr/bin/python3
# Daniel Wielgosz (g1)

import sys, re, os

files_nr = 1
nr = 1
c = False
N = False
n = False
p = False

# należy odkodować poniższą część przy przeprowadzaniu testów
f = open(os.devnull, 'w')
sys.stdout = f

for i in range(1,len(sys.argv)):
    if sys.argv[i] == '-c':
        c = True
        files_nr += 1
    elif sys.argv[i] == '-N':
        N = True
        files_nr += 1
    elif sys.argv[i] == '-n':
        n = True
        files_nr += 1
    elif sys.argv[i] == '-p':
        p = True
        files_nr += 1

for i in range(files_nr,len(sys.argv)):
    with open(sys.argv[i], 'r') as my_file:
        for line in my_file:
            stripped_line = line.rstrip()

            if (c and N) or (p and N and not n):
                if not re.search("^#", stripped_line):
                    print(str(nr) + ': ' + stripped_line)
                nr += 1   
            
            elif (n and N):
                if not re.search("^#", stripped_line):
                    print(str(nr) + ': ' + stripped_line)
                    nr += 1

            elif p:
                if not N:
                    print(str(nr) + ': ' + stripped_line)
                    nr += 1

            elif N:
                if not re.search("^#", stripped_line):
                    print(stripped_line)

            elif c or n:
                print(str(nr) + ': ' + stripped_line)
                nr += 1

            else:
                print(stripped_line)
        
        if p:
            nr = 1

        print()
        my_file.close()
