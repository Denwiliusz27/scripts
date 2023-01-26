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
  a=$((i-1))
  b=$((i-2))

  if [ "${!a}" == "-d" ]; then
    temp_paths+=(${!i})

    if [ ! "${paths[${!i}]}" ]; then
      paths[${!i}]=temp[@]
    fi

  elif [ "${!i}" == "-d" ] && [ "$wz" = true ]; then
    if [ $i -gt 1 ] && [ "${!b}" != "-d" ]; then
      for key in "${temp_paths[@]}";
      do
        printf -v array_str '%q ' "${temp_patterns[@]}"
        paths[$key]=$array_str
      done
    fi

    wz=false
    temp_paths=()
    temp_patterns=()

  elif [[ "${!b}" == "-d" && "${!a}" != "-d" && "${!i}" != "-d" ]] || [[ "$wz" = true && "${!i}" != "-d" ]]; then
    wz=true
    temp_patterns+=( ${!i} )
  fi
done

for key in "${temp_paths[@]}";
do
  printf -v array_str '%q ' "${temp_patterns[@]}"
  paths[$key]=$array_str #(${temp_patterns[@]});
done

for key in "${!paths[@]}"; do
  results=()

  if [ -e "$key" ]; then
    IFS=$'\n'
    files=($(find $key -type f))
    IFS=' '
    words=(${paths[$key]})

    for file in "${files[@]}"; do
      while IFS= read -r line; do
        for word in "${words[@]}"; do
          word="$(echo -e "${word}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

          tmp="${line//$word}"
          count=$(( ( ${#line} - ${#tmp} ) / ${#word} ))

          if [[ -v results[$word] ]]; then
            if [ $count -gt 0 ]; then
              results[$word]=$((results[$word] + $count))
            fi
          else
            if [ $count -gt 0 ]; then
              results[$word]=$count
            else
              results[$word]=0
            fi
          fi
        done
      done < "$file"
    done

    echo -n "$key: "  #&>/dev/null
    for word in "${!results[@]}"; do
      echo -n " '$word' - ${results[$word]} " #&>/dev/null
    done
    echo ""

  else
    echo "ERROR - ścieżka '$key' nie istnieje"
    exit 1
  fi
done