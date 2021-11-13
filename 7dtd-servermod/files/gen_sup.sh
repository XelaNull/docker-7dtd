#!/bin/sh
echo "[program:$1]";
echo "process_name  = $1";
echo "autostart     = true";
echo "autorestart   = false";
echo "directory     = /";
echo "command       = $2";
echo "startsecs     = 3";
echo "priority      = 1";
