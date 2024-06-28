#!/bin/ksh
#
# Copyright (c)  Nicholas Marriott
#               2024, Raffaele Marco Bagnato <software@rmbagnato.eu>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# Originally by Nicholas Marriott

#programs in use
RCLONE=/usr/local/bin/rclone
DUMP=/sbin/dump
AWK=/usr/bin/awk
SED=/usr/bin/sed
GZIP=/usr/bin/gzip

# Set some variables for the script
# hostname of local machine
HOSTNAME=<hostname>
# local backup path
LBKPATH=<path>
# rclone config
RCLONE_CONFIG=<rclone_config_path>
RCONFIG=<config_name>
RCLONE_PATH=$RCONFIG:${HOSTNAME}
# directories and mountpoints that you want to dump
SOURCES=<string_of_directories>
# backup file extension
EXT=.gz
# dump sequence. FULL is 0, RESET is 1, and PATTERN is followed between RESETs
FULL=20
RESET=10
# modified Tower of Hanoi algorithm, with
# this sequence of dump levels
set -A PATTERN 3 2 5 4 7 6 9 8 9 9
# date of running
DATE="`date +%Y%m%d`"

export RCLONE_CONFIG

if ! [ -d $LBKPATH ]
then
    print "NO BACKUP DISK !!!"
    exit 1
fi

# check free space
USED=`df $LBKPATH|$AWK '/^\// { print substr($5, 0, length($5) - 1) }'`
if [ $USED -gt 75 ]; then
    echo "-------------------------------------------------------------------"
    echo "INSUFFICIENT DISK SPACE"
    echo "-------------------------------------------------------------------"
    df -h $LBKPATH
    exit 1
fi

# get the last day
if [ -f $LBKPATH/${HOSTNAME}/day ]; then
    DAY=$(< $LBKPATH/${HOSTNAME}/day)
else
    DAY=0
fi

if [ $(($DAY % $FULL)) -eq 0 ]; then
    LEVEL=0
    DAY=0
elif [ $(($DAY % $RESET)) -eq 0 ]; then
    LEVEL=1
else
    LEVEL=${PATTERN[$((($DAY % $RESET) - 1))]}
fi

for i in $SOURCES; do
   NAME="`echo $i|$SED 's/^\///; s/\/$//; s/\//_/'`"
   TARGET="$LBKPATH/$HOSTNAME/$NAME"
   mkdir -p "$TARGET"

   FILENAME="`echo ${NAME}|$SED 's/\//_/g'`"
   FILE="$TARGET/${HOSTNAME}_${FILENAME}_`printf '%0.2d' $DAY`_${DATE}_${LEVEL}"
   echo "DUMP SOURCES: $i"
   echo "FILE: $FILE"

  if [ -f "$TARGET.ignore" ]; then
	  while read j; do
	    (echo $j|grep '\.\.' >/dev/null) && echo illegal $i/$j && continue
	    (echo $j|grep '^/'   >/dev/null) && echo illegal $i/$j && continue
	    echo ignore $i/$j
	    chflags -R nodump "$i/$j" || exit
	  done < "$TARGET.ignore"
  fi

  if [ $LEVEL -eq 0 ]; then
	  # save list of files for removal
	  ls -d "$TARGET"/* 2>/dev/null >"$TARGET/list"
	  [ ! -s "$TARGET/list" ] && rm -f "$TARGET/list"
  fi
  time ($DUMP -h0 -u$LEVEL -f - $i|$GZIP >"$FILE$EXT") 2>&1| \
	tee "$FILE.log" || exit

  if [ $LEVEL -eq 0 -a -f "$TARGET/list" ]; then
	  # clean up old files
	  xargs rm -f -- <"$TARGET/list"
	  rm -f "$TARGET/list"
  fi
  if [ $LEVEL -eq 1 ]; then
	  # remove everything except level 0 and 1
	  rm -f -- "$TARGET"/*.[2-9]*
  fi
done
df -h $LBKPATH

# update day
DAY=$(($DAY + 1))
echo $DAY >$LBKPATH/${HOSTNAME}/day

echo "RCLONE SYNC:"
${RCLONE} sync ${LBKPATH}/${HOSTNAME} ${RCLONE_PATH}
