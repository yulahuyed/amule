if [ -f /home/amule/rclone.conf ]
then
 RCLONE_TYPE=$(cat /aria2/rclone.conf | grep -oE '\[.*\]' | head -1 | sed 's/\[\(.*\)\]/\1/g')
 rclone copy "/home/amule/.aMule/Incoming/" "$RCLONE_TYPE:aMule"
 rm -rf /home/amule/.aMule/Incoming
 mkdir -p /home/amule/.aMule/Incoming
fi
