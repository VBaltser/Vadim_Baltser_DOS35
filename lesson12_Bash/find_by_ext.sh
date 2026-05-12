#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
    echo "Использование: $0 <файл_результата> <каталог> <расширение>" >&2
    exit 1
fi

out_file="$1"
dir="$2"
ext="${3#.}"

if [ ! -d "$dir" ]; then
    echo "Ошибка: каталог не найден: $dir" >&2
    exit 2
fi

find "$dir" -type f -name "*.${ext}" -printf '%f\n' > "$out_file"
