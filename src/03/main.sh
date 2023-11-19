#!/bin/bash

log_file="script_log.txt"

cleanup_by_log() {
  while IFS= read -r line; do
    if [[ $line == "Папка:"* ]]; then
      root_path="${line#*: }"
      echo "Удаляется папка: $root_path"
      rm -rf "$root_path"
    elif [[ $line == "Файл:"* ]]; then
      file_path="${line#*: }"
      echo "Удаляется файл: $file_path"
      rm -f "$file_path"
    fi
  done < "$log_file"
  echo "Очистка по лог-файлу завершена."
}

cleanup_by_datetime() {
  read -p "Введите время начала (DDMMYYHHMM): " start_datetime
  read -p "Введите время окончания (DDMMYYHHMM): " end_datetime

  while IFS= read -r line; do
    if [[ $line == "Файл:"* ]]; then
      file_path="${line#*: }"
      creation_datetime="${line#* : }"
      if [[ $creation_datetime -ge $start_datetime && $creation_datetime -le $end_datetime ]]; then
        echo "Удаляется файл: $file_path"
        rm -f "$file_path"
      fi
    fi
  done < "$log_file"
  echo "Очистка по дате и времени завершена."
}

cleanup_by_mask() {
  read -p "Введите маску имени (буквы, символы нижнего подчеркивания и дата): " mask

  while IFS= read -r line; do
    if [[ $line == "Папка:"* ]]; then
      root_path="${line#*: }"
      folder_name=$(basename "$root_path")
      if [[ $folder_name == $mask* ]]; then
        echo "Удаляется папка: $root_path"
        rm -rf "$root_path"
      fi
    elif [[ $line == "Файл:"* ]]; then
      file_path="${line#*: }"
      file_name=$(basename "$file_path")
      if [[ $file_name == $mask* ]]; then
        echo "Удаляется файл: $file_path"
        rm -f "$file_path"
      fi
    fi
  done < "$log_file"
  echo "Очистка по маске имени завершена."
}

cleanup_method="$1"

case $cleanup_method in
  1) cleanup_by_log ;;
  2) cleanup_by_datetime ;;
  3) cleanup_by_mask ;;
  *) echo "Неверно указан метод очистки." && exit 1 ;;
esac
