#!/bin/bash

generate_ip() {
    echo $((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))
}

generate_status() {
    statuses=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
    echo "${statuses[RANDOM % ${#statuses[@]}]}"
}

generate_method() {
    methods=("GET" "POST" "PUT" "PATCH" "DELETE")
    echo "${methods[RANDOM % ${#methods[@]}]}"
}

generate_date() {
    start=$(date -d "2023-01-01" +%s)
    end=$(date -d "2023-12-31" +%s)
    random_date=$(date -d "@$((RANDOM % (end - start + 1) + start))" "+%d/%b/%Y:%H:%M:%S %z")
    echo "$random_date"
}

generate_url() {
    urls=("/" "/home" "/about" "/contact" "/products" "/services" "/blog" "/login" "/logout" "/admin")
    echo "${urls[RANDOM % ${#urls[@]}]}"
}

generate_agent() {
    agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
    echo "${agents[RANDOM % ${#agents[@]}]}"
}

for i in {1..5}; do
    filename="access_log_$i.txt"
    num_entries=$((RANDOM % (1000 - 100 + 1) + 100))

    echo "Generating $num_entries entries for $filename..."
    touch "$filename"

    for ((j = 1; j <= num_entries; j++)); do
        ip=$(generate_ip)
        status=$(generate_status)
        method=$(generate_method)
        date=$(generate_date)
        url=$(generate_url)
        agent=$(generate_agent)

        echo "$ip - - [$date] \"$method $url HTTP/1.1\" $status 0 \"-\" \"$agent\"" >>"$filename"
    done

    echo "Generated $num_entries entries for $filename"
done
