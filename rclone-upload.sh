#!/bin/bash
# GCLONE UPLOAD CRON TAB SCRIPT 
# chmod a+x /home/plex/scripts/rclone-upload.sh
# Type crontab -e and add line below (without #) and with correct path to the script
# * * * * * /home/plex/scripts/rclone-upload.sh >/dev/null 2>&1
# if you use custom config path add line bellow in line 20 after --log-file=$LOGFILE 
# --config=/path/rclone.conf (config file location)

if pidof -o %PPID -x "$0"; then
   exit 1
fi

FROM="/content/udemy-downloader/out_dir"
TO="colab:{0AEccOAma26pfUk9PVA}"

# CHECK FOR FILES IN FROM FOLDER THAT ARE OLDER THAN 15 MINUTES
if find $FROM* -type f -name "*.zip" -mmin +1 | read
  then
  start=$(date +'%s')
  echo "$(date "+%d.%m.%Y %T") GCLONE UPLOAD STARTED" | tee -a $LOGFILE
  # MOVE FILES OLDER THAN 10 MINUTES 
  rclone move "$FROM" "$TO" --filter "+ *.zip" --transfers=5 --checkers=5 --delete-after --min-age 1m --log-file=$LOGFILE
  echo "$(date "+%d.%m.%Y %T") GCLONE UPLOAD FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
fi
exit
