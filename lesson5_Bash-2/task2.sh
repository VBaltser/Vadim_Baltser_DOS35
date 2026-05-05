#!/usr/bin/env bash

if [[ $# -ne 2 ]]; then
  echo "Необходимо указать имя файла и новое расширение: $0 <filename> <new_extension>"
  exit 1
fi

# имя файла
filename="$1"
# новое расширение
new_ext="$2"
# извлекаем расширение без точки
new_ext="${new_ext#.}"

# извлекаем имя файла без пути
name_only="${filename##*/}"

# проверяем, что имя файла имеет расширение
if [[ "$name_only" == *.* && "$name_only" != .* && "$name_only" != *. ]]; then
  # убираем расширение
  base="${filename%.*}"
  # добавляем новое расширение
  echo "${base}.${new_ext}"
else
  echo "Источник файла не имеет расширения: $filename"
  exit 2
fi
