#!/usr/bin/env bash
#
# Script that mount SFTP with rclone
# create for ubuntu 24.04 - rclone 1.60.1 - bash 5.2.21
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

# RCLONE PATH
RCLONE=/usr/bin/rclone
# RCLONE CONFIG NAME
RCONF=<rclone config name>
# REMOTE PATH
RPATH=<remote path>
# LOCAL PATH
LPATH=<local path>

if ! [ -x "$(command -v rclone)" ]; then
  echo 'Error: rclone is not installed.' >&2
  exit 1
fi

if [[ ! -e ${LPATH} ]]; then
    mkdir ${LPATH} && chmod 777 ${LPATH}
fi

${RCLONE} mount ${RCONF}:${RPATH} ${LPATH}
