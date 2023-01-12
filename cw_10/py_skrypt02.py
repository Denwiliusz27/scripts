#!/usr/bin/python3
# Daniel Wielgosz (g1)

import sys, re, os

files_nr = 1
nr = 1
d = False
i = False
e = False
w_word_c = 0
w_line_c = 0
w_char_c = 0
w_integer_c = 0
w_all_numbers = 0
i_option = False

# nalezy odkodowac ponizsza czesc przy wykonywaniu testow
# f = open(os.devnull, 'w')
# sys.stdout = f

# 1e-712 1E-3 1D-3 1d-3 1Q-3 1q-3  1^2 1.2

for n in range(1,len(sys.argv)):
    if sys.argv[n] == '-d':
        d = True
        files_nr += 1
    elif sys.argv[n] == '-i':
        i = True
        files_nr += 1
    elif sys.argv[n] == '-e':
        e = True
        files_nr += 1

for n in range(files_nr,len(sys.argv)):
    word_c = 0
    line_c = 0
    char_c = 0
    integer_c = 0
    all_numbers = 0

    with open(sys.argv[n], 'r') as my_file:
        for line in my_file:
            splitted_line =  line.split()

            if e and line.strip().startswith("#"):
                continue

            line_c += 1
            char_c += len(line)

            for word in splitted_line:
                if word != '':
                    word_c += 1

                if word.isdigit():
                    integer_c += 1
                    all_numbers += 1
                elif re.match("^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([EeQqDd^]([+-]?\d+))?$", word):
                    all_numbers += 1

        if files_nr > 1:
            w_word_c += word_c
            w_line_c += line_c
            w_char_c += char_c
            w_integer_c += integer_c
            w_all_numbers += all_numbers

        print("\nFile: ", sys.argv[n], " -- lines: ", line_c, ", words: ", word_c, ", characters: ", char_c, end=" ")

        if i:
            print(", integers: ", integer_c, end=" ")

        if d:
            print(", all numbers: ", all_numbers, end=" ")

        print()

if len(sys.argv) - files_nr > 1:
    print("\nALL FILES -- lines: ", w_line_c, ",words: ", w_word_c, ", characters: ", w_char_c, end=" ")

    if i:
        print(", integers: ", w_integer_c, end=" ")

    if d:
        print(", all numbers: ", w_all_numbers, end=" ")

print("\n")
