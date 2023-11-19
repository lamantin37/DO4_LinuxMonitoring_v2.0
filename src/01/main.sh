#!/bin/bash

if [ "$#" -ne 6 ]; then
  echo "Неверное количество аргументов."
  echo "Использование: $0 <путь_к_директории> <количество_папок> <список_букв> <количество_файлов> <список_букв> <размер_файлов_в_Кб>"
  exit 1
fi

directory="$1"
num_folders="$2"
folder_letters="$3"
num_files="$4"
file_letters="$5"
file_size_kb="$6"

space_check() {
  free_space=$(df -k --output=avail / | tail -n 1)
  if [ "$free_space" -lt 1048576 ]; then
    echo "Недостаточно свободного места на диске."
    exit 1
  fi
}

create_folder() {
  local folder_name="$1"
  local dir="$2"
  mkdir -p "$dir/$folder_name"
}

create_file() {
  local folder_name="$1"
  local file_name="$2"
  local file_size="$3"
  local dir="$4"

  file_size_numeric=$(echo "$file_size" | sed 's/[^0-9]*//')

  if [[ ! $file_size_numeric =~ ^[0-9]+$ ]]; then
    echo "Invalid file size: $file_size"
    exit 1
  fi

  file_size_suffix=$(echo "$file_size" | sed 's/[0-9]*//')

  touch "$dir/$folder_name/$file_name"
  truncate -s "${file_size_numeric}${file_size_suffix}" "$dir/$folder_name/$file_name"
}

create_log() {
  local dir="$1"
  local current_date="$2"
  local file_size_kb="$3"
  local log_file="$dir/log.txt"

  echo "Созданные папки и файлы:" > "$log_file"
  echo >> "$log_file"

  for folder in "$dir"/*; do
    if [ -d "$folder" ]; then
      echo "Папка: $(basename "$folder")" >> "$log_file"
      echo "Дата создания: $current_date" >> "$log_file"
      echo "Размер файлов: $file_size_kb Кб" >> "$log_file"
      echo >> "$log_file"

      for file in "$folder"/*; do
        if [ -f "$file" ]; then
          echo "Файл: $(basename "$file")" >> "$log_file"
          echo "Дата создания: $current_date" >> "$log_file"
          echo "Размер: $file_size_kb Кб" >> "$log_file"
          echo >> "$log_file"
        fi
      done
    fi
  done

  echo "Скрипт успешно выполнен."
}

name_generation() {
  local input_string="$1"
  local output_string=""

  for ((a=0; a<${#input_string}; a++)); do
    char="${input_string:$a:1}"
    repeat_count=$(( RANDOM % 7 + 4 ))

    for ((b=0; b<repeat_count; b++)); do
      output_string+="$char"
    done
  done

  echo "$output_string"
}

main() {
  current_date=$(date +'%d%m%y')

  space_check

  for ((i = 1; i <= num_folders; i++)); do
    folder_name=$(name_generation "$folder_letters")_"$current_date"
    create_folder "$folder_name" "$directory"

    for ((j = 1; j <= num_files; j++)); do
      file_name_prefix=$(name_generation "${file_letters%%.*}")
      IFS='.' read -ra parts <<< "$file_letters"

      if [ "${#parts[@]}" -lt 2 ]; then
        echo "No dot found in the input string"
        exit 1
      fi

      file_extension=$(name_generation "${parts[1]}")
      file_name="${file_name_prefix}_${current_date}.${file_extension}"
      create_file "$folder_name" "$file_name" "$file_size_kb" "$directory"
    done
  done

  create_log "$directory" "$current_date" "$file_size_kb"
}

main
