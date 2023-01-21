#!/usr/bin/python3
# Daniel Wielgosz (g1)

import sys, os

paths = {}
results = {}
temp_paths = []
wz = False

for i in range(1,len(sys.argv)):
    if sys.argv[i-1] == '-d':
        temp_paths.append(sys.argv[i])
        if sys.argv[i] not in paths:
            paths[sys.argv[i]] = []
        if sys.argv[i] not in results:
            results[sys.argv[i]] = {}

    elif sys.argv[i] == '-d' and wz:
        wz = False
        temp_paths = []
    elif (sys.argv[i-2] == '-d' and sys.argv[i] != '-d') or wz:
        wz = True
        for key in temp_paths:
            paths[key].append(sys.argv[i])

for key in paths:
    if not os.path.exists(key):
        print("ERROR - ścieżka '", key, "' nie istnieje")
        continue

    for subdir, dirs, files in os.walk(key):
        for file in files:
            with open(os.path.join(subdir, file), 'rb') as my_file:
                for line in my_file:
                    splitted_line = line.split()

                    for word in paths[key]:
                        if str(line).count(str(word)) > 0:
                            if word not in results[key]:
                                results[key][word] = str(line).count(str(word))
                            else:
                                results[key][word] += str(line).count(str(word))

for key in results:
    for u_key in results[key]:
        print(key, ": '", u_key, "'-", results[key][u_key])