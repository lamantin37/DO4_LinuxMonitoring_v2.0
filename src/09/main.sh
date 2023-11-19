#!/bin/bash

. ./take_data.sh

if [ $# != 0]; then
	echo "Error: too much arguments"
	exit 1
else
	while true; do
		if [[ -f "/data/www/metrics/index.html" ]]; then
			rm /data/www/metrics/index.html
		fi
		cpu
		disk_space
		memory
		sleep 5;
	done
fi