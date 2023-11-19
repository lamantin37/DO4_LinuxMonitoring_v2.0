#!/bin/bash

function cpu {
    CPU="$(cat /proc/loadavg | awk '{print %1}')"
    echo "# HELP cpu total cpu" >> /data/www/metrics/index.html
    echo "# TYPE cpu gauge" >> /data/www/metrics/index.html
    echo "cpu $CPU" >> /data/www/metrics/index.html
}

function disk_space {
    DISK_SPACE="$(df / | grep / | awk '{print $3}')"
    echo "# HELP disk_space shows used disk space" >> /data/www/metrics/index.html
    echo "# TYPE disk_space gauge" >> /data/www/metrics/index.html
    echo "disk_space $DISK_SPACE" >> /data/www/metrics/index.html
}

function memory {
    MEMORY="$(free | grep Mem | awk '{print $3}')"
    echo "# HELP memory shows used memory" >> /data/www/metrics/index.html
    echo "# TYPE memory gauge" >> /data/www/metrics/index.html
    echo "memory $MEMORY" >> /data/www/metrics/index.html
}
