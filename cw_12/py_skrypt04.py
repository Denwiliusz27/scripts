#!/usr/bin/python3
# Daniel Wielgosz (g1)

import sys, os


# fragment do testów
# f = open(os.devnull, 'w')
# sys.stdout = f

def count(my_file, paths, key, results):
    for line in my_file:
        for word in paths[key]:
            if str(line).count(str(word)) > 0:
                # print("jest", str(line).count(str(word)), ": ", line)
                if word not in results[key]:
                    results[key][word] = str(line).count(str(word))
                else:
                    results[key][word] += str(line).count(str(word))


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

    elif (sys.argv[i] == '-d' and wz):
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
    if os.path.isfile(key):
        with open(key, 'rb') as my_file:
            count(my_file, paths, key, results)

    for subdir, dirs, files in os.walk(key):
        for file in files:
            with open(os.path.join(subdir, file), 'rb') as my_file:
                count(my_file, paths, key, results)

for key in results:
    print(key, ": ", end = "")
    for u_key in results[key]:
        print("'", u_key, "'-", results[key][u_key], end =" ")
    print()