#!/bin/sh
PATH=/bin:/usr/lib64/qt-3.3/bin:/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/admin/bin
export PATH
DATE=`date '+%s'`
DOC="/home/admin/.cron/$DATE"
mkdir $DOC
expect /home/admin/.cron/back.exp $DOC