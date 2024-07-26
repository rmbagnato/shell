#!/bin/ksh
#
# Script to automate the backup of an OpenBSD machine via Restic Rclone
# create for OpenBSD 7.5 - restic 0.16.4 - rclone 1.65.2 - ksh 5.2.14 
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

RESTIC=<restic_path>
RCLONE_PATH=<rclone_path>

export RESTIC_PASSWORD=<restic_repo_passwd>
export RCLONE_CONFIG=<rclone_config_path>

RESTIC_REPO=<restic_repo>
BCK_FILES_LIST_PATH=<backup_path_list>

TAGS="daily"
DAY=$(date +%d)
FORCE=""

if [ ! -e $BCK_FILES_LIST_PATH ]; then
        echo "Error: the --files-from option required file path"
        exit -1
fi

if [ ${DAY} -eq 1 ]; then
        TAGS="full,$(date  +%b)"
        FORCE="--force"
fi

${RESTIC} forget -r "${RESTIC_REPO}" \
        -o rclone.program=${RCLONE_PATH} \
        --tag daily --keep-last 5

${RESTIC} backup --files-from ${BCK_FILES_LIST_PATH} \
        -r "${RESTIC_REPO}" \
        -o rclone.program=${RCLONE_PATH} \
        ${FORCE} \
        --tag ${TAGS}
