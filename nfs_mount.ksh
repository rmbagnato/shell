#!/bin/ksh
#
# Script that mount nfs resources on a OpenBSD machine.
#
# Copyright (c) 2024, Raffaele Marco Bagnato <software@rmbagnato.eu>
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

# Set some variables for the script
MOUNTPOINT=<mount_point_path>
NFSIP=<remote_ip>
NFSPATH=<remote_nsf_path>
NFSOPTIONS=<nfs_options>
RETRANS=<retransmit_timeout_count>
WRITESIZE=<number_of_byte>
READSIZE=<number_of_byte>

if ! ping -c 1 -W 1 "$NSFIP" &>/dev/null; 
then
    if mount | grep $MOUNTPOINT > /dev/null 2>&1; 
    then
        umount $MOUNTPOINT > /dev/null 2>&1
	    rm -r $MOUNTPOINT > /dev/null 2>&1
        echo "Error: No remote machine - mount point disconnected"
    else
        echo "Error: No remote machine"
    fi
    exit 1
fi

if [ ! -d $MOUNTPOINT ]
then
    mkdir $MOUNTPOINT > /dev/null 2>&1
    chmod 777 $MOUNTPOINT > /dev/null 2>&1
fi

mount_nfs \
    -o $NFSOPTIONS \
    $NFSIP:$NFSPATH \
    -w $WRITESIZE \
    -r $READSIZE \
    -x $RETRANS \
    $MOUNTPOINT > /dev/null 2>&1
