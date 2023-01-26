#!/bin/bash
#Daniel Wielgosz (g1)

declare -A paths
declare -A results
declare -A results_inner
temp_paths=()
temp=()
wz=false
temp_patterns=()

for ((i=2;i<=$#;i++));
do
#  echo "$#" "$i" "${!i}";
  echo "$i" "${!i}";
  echo "wz = $wz"
  a=$((i-1))
  b=$((i-2))

  if [ "${!a}" == "-d" ]; then
    temp_paths+=(${!i})
    echo "dl: ${#temp_paths[@]}"
    echo "${temp_paths[${#temp_paths[@]}-1]}"

    if [ ! "${paths[${!i}]}" ]; then
#      echo "${!i} nie jest w paths"
      paths[${!i}]=temp[@]
    fi

    if [ ! "${results[${!i}]}" ]; then
      results[${!i}]=results_inner
#      echo "pusty slownik"
    fi

  elif [ "${!i}" == "-d" ] && [ "$wz" = true ]; then
    if [ $i -gt 1 ] && [ "${!b}" != "-d" ]; then
      for key in "${temp_paths[@]}";
      do
        printf -v array_str '%q ' "${temp_patterns[@]}"
        paths[$key]=$array_str
        echo "dopisalem: $array_str "
        echo "dopisalem do $key : $array_str "
      done
    fi

    wz=false
    temp_paths=()
    temp_patterns=()
    echo "usuwam"

  elif [[ "${!b}" == "-d" && "${!a}" != "-d" && "${!i}" != "-d" ]] || [[ "$wz" = true && "${!i}" != "-d" ]]; then
    wz=true

#    for key in "${temp_paths[@]}";
#    do
#      printf -v temp_patterns
    echo "dodaje ${!i}"
    temp_patterns+=( ${!i} )
#    done
  fi
done
echo "~~~~~~~~~~~~~~~~~~"

for key in "${temp_paths[@]}";
do
  echo "dopisuje tablice do $key"
  printf -v array_str '%q ' "${temp_patterns[@]}"
  paths[$key]=$array_str #(${temp_patterns[@]});
  echo "dopisalem do $key : $array_str "
done


tablica=()

for key in "${!paths[@]}"; do
    echo "~~~~~~~~~~~~~~~~~~"
    echo "Key: $key"

    printf -v array_cmd "%q=( %s )" "$tablica" "${paths[$key]}"
    eval "$tablica"

    echo " to jest : ${paths[$key]}"

    IFS=' '
    new_array=(${paths[$key]})
    echo "Array: ${new_array[@]}"

#    for value in "${paths[$key][@]}"; do
#        echo "Value: $value"
#    done
done



#echo "dopisuje tablice do $key"
#for key in "${temp_paths[@]}";
#do
#  paths[$key]=(${temp_patterns[@]});
#done



