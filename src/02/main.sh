#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Неверное количество аргументов."
  echo "Использование: $0 <список_букв_папки> <список_букв_папки.список_букв_расширения> <размер_файлов_в_Мб>"
  exit 1
fi

alphabet=$1
extension=$2
file_size=$3

random_number() {
  local max=$1
  echo $((RANDOM % max))
}

name_generation() {
  local input_string="$1"
  output_string=""

  for ((a=0; a<${#input_string}; a++)); do
    char="${input_string:$a:1}"
    repeat_count=$(( RANDOM % 6 + 5 ))

    for ((b=0; b<repeat_count; b++)); do
      output_string+="$char"
    done
  done
}

current_date=$(date +'%d%m%y')

create_files() {
  local path=$1
  local depth=$2

  mkdir -p "$path"

  echo "--------------------------" >> script_log.txt
  echo >> script_log.txt
  echo "Папка: $path" >> script_log.txt
  echo "Дата создания: $(date +"%d%m%y")" >> script_log.txt

  local num_files=$(random_number 10)

  for ((i=0; i<num_files; i++)); do
    name_generation "${extension%%.*}"
    file_name_prefix="${output_string}"

    IFS='.' read -ra parts <<< "${extension}"
    if [ "${#parts[@]}" -lt 2 ]; then
      echo "No dot found in the input string"
      exit 1
    fi

    name_generation "${parts[1]}"
    file_extension="${output_string}"
    filename="${file_name_prefix}_${current_date}.${file_extension}"

    dd if=/dev/zero of="$path/$filename" bs=${file_size}M count=1 &>/dev/null

    local file_size_mb=$(du -h "$path/$filename" 2>/dev/null | awk '{print $1}')
    echo >> script_log.txt
    echo "Файл: $path/$filename" >> script_log.txt
    echo "Дата создания: $(date +"%d%m%y"), Размер: $file_size_mb" >> script_log.txt
  done

  if [[ $depth -lt 100 ]]; then
    local num_subfolders=$(random_number 10)

    for ((i=0; i<num_subfolders; i++)); do
      name_generation "${alphabet}"
      local subfolder_name=${alphabet:$(random_number ${#alphabet}):1}$(uuidgen)
      subfolder_name="${output_string}"
      local subfolder="${subfolder_name}_${current_date}"

      create_files "$path/$subfolder" $((depth+1))
    done
  fi
}

free_space=$(df -BM / | awk '/\// {print $4}' | sed 's/M//')

start_time=$(date +%s)

while [[ $free_space -gt 1024 ]]; do
  root_folder=$(uuidgen)
  name_generation "${alphabet}"
  root_folder_name="${output_string}"
  root_folder="${root_folder_name}_${current_date}"
  create_files "/$root_folder" 0
  free_space=$(df -BM / | awk '/\// {print $4}' | sed 's/M//')
done

end_time=$(date +%s)
total_time=$((end_time - start_time))

echo "Время начала работы: $(date -d @$start_time)"
echo "Время окончания работы: $(date -d @$end_time)"
echo "Общее время работы: $total_time сек."

echo "Время начала работы: $(date -d @$start_time)" >> script_log.txt
echo "Время окончания работы: $(date -d @$end_time)" >> script_log.txt
echo "Общее время работы: $total_time сек." >> script_log.txt
