#!/usr/bin/env bash

if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo "Необходимо указать строку, начальную и конечную позицию, а также режим: $0 <string> <start_pos> <end_pos> [extract|delete]"
  exit 1
fi

src="$1"
start="$2"
end="$3"
mode="${4:-extract}"

if ! [[ "$start" =~ ^[0-9]+$ && "$end" =~ ^[0-9]+$ ]]; then
  echo "Начальная и конечная позиции должны быть положительными целыми числами."
  exit 2
fi

if (( start < 1 || end < 1 || start > end )); then
  echo "Неверный диапазон. Ожидается: 1 <= start_pos <= end_pos."
  exit 3
fi

range="${start}-${end}"

case "$mode" in
  extract)
    printf '%s\n' "$src" | cut -c "$range"
    ;;
  delete)
    printf '%s\n' "$src" | cut --complement -c "$range"
    ;;
  *)
    echo "Режим должен быть 'extract' или 'delete'."
    exit 4
    ;;
esac
