umask 022

LOGDIR=/data/local/log

LOGFILE=$LOGDIR"/dmesglog"

MV_FILES_SHELL="/system/bin/mv_files.sh"


while [ 1 ]
do
	date >> $LOGFILE
	echo "" >> $LOGFILE
	dmesg -c >> $LOGFILE

	LOGSIZE=`du -shm $LOGFILE | sed 's/[[:blank:]].*//g'`

	if [ $LOGSIZE -ge 10 ]; then
		$MV_FILES_SHELL $LOGFILE
	fi
	sleep 2
done
