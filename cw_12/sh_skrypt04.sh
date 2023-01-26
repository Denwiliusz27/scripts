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
#  echo "$i" "${!i}";
#  echo "wz = $wz"
  a=$((i-1))
  b=$((i-2))

  if [ "${!a}" == "-d" ]; then
    temp_paths+=(${!i})

    if [ ! "${paths[${!i}]}" ]; then
      paths[${!i}]=temp[@]
    fi

#    if [ ! "${results[${!i}]}" ]; then
#      results[${!i}]=results_inner
#    fi

  elif [ "${!i}" == "-d" ] && [ "$wz" = true ]; then
    if [ $i -gt 1 ] && [ "${!b}" != "-d" ]; then
      for key in "${temp_paths[@]}";
      do
        printf -v array_str '%q ' "${temp_patterns[@]}"
        paths[$key]=$array_str
#        echo "dopisalem: $array_str "
#        echo "dopisalem do $key : $array_str "
      done
    fi

    wz=false
    temp_paths=()
    temp_patterns=()
#    echo "usuwam"

  elif [[ "${!b}" == "-d" && "${!a}" != "-d" && "${!i}" != "-d" ]] || [[ "$wz" = true && "${!i}" != "-d" ]]; then
    wz=true
#    echo "dodaje ${!i}"
    temp_patterns+=( ${!i} )
  fi
done

for key in "${temp_paths[@]}";
do
#  echo "dopisuje tablice do $key"
  printf -v array_str '%q ' "${temp_patterns[@]}"
  paths[$key]=$array_str #(${temp_patterns[@]});
#  echo "dopisalem do $key : $array_str "
done

for key in "${!paths[@]}"; do
  results=()

  if [ -e "$key" ]; then
    IFS=$'\n'
    files=($(find $key -type f))
    IFS=' '
    words=(${paths[$key]})
#    echo "len: ${#files[@]}"

    for file in "${files[@]}"; do
#      echo "~~~~~~~~~~~~~~~~~~"
#      echo "file: $file"
#      echo "array: ${words[@]}"

      while IFS= read -r line; do
        # Do something with the line
#        echo "$line"

        for word in "${words[@]}"; do
          word="$(echo -e "${word}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
          count=$(($(echo $line | awk -v string="$word" '{print gsub(string,"&")}')))


          if [ $count -gt 0 ]; then
            if [[ -v results[$word] ]]; then
              results[$word]=$((results[$word] + $count))
            else
              results[$word]=$count
            fi
          fi
        done
      done < "$file"

    done

    echo "$key: "
    for word in "${!results[@]}"; do
      echo "  $word - ${results[$word]}"
    done


  else
    echo "ERROR - ścieżka '$key' nie istnieje"
    exit 1
  fi


done