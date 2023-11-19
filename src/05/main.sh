#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 [1|2|3|4]"
    exit 1
fi

log_files=("../04/access_log_1.txt" "../04/access_log_2.txt" "../04/access_log_3.txt" "../04/access_log_4.txt")

print_sorted_entries() {
    for file in "${log_files[@]}"; do
        echo "Entries sorted by response code in $file:"
        awk '{print $9, $0}' "$file" | sort -k1
    done
}

print_unique_ips() {
    for file in "${log_files[@]}"; do
        echo "Unique IPs in $file:"
        awk '{print $1}' "$file" | sort -u
    done
}

print_error_requests() {
    for file in "${log_files[@]}"; do
        echo "Error requests in $file:"
        awk '$9 ~ /^[45]/ {print}' "$file"
    done
}

print_unique_ips_error_requests() {
    for file in "${log_files[@]}"; do
        echo "Unique IPs from error requests in $file:"
        awk '$9 ~ /^[45]/ {print $1}' "$file" | sort -u
    done
}

case $1 in
    1) print_sorted_entries ;;
    2) print_unique_ips ;;
    3) print_error_requests ;;
    4) print_unique_ips_error_requests ;;
    *)
        echo "Invalid parameter. Usage: $0 [1|2|3|4]"
        exit 1
        ;;
esac
