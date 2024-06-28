#!/usr/bin/bash
#
# Script that print data from a given IP adress
# Create for ubuntu 24.04 - bash 5.2.21 - jq 1.7 - curl 8.5.0 - tr  9.4
#
# Copyright (c) 2020, Abhishek Shingane (abhisheks@iitbhilai.ac.in)
#               2024, Raffaele Marco Bagnato (software@rmbagnato.eu)
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

# Geolocation API URL
GAPIURL="http://ip-api.com/json/"
# JQ path
JQ=/usr/bin/jq
# CURL path
CURL=/usr/bin/curl
# TR path
TR=/usr/bin/tr

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.'
  exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed.'
  exit 1
fi

if ! [ -x "$(command -v tr)" ]; then
  echo 'Error: tr is not installed.'
  exit 1
fi

if ! [[ "$1" =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]; then
  echo 'Usage:  ' $0 ' <ip> '
        exit 1
fi

DATA=($(${CURL} ${GAPIURL}/$1 -s | ${JQ} -r '.status, .city, .regionName, .country' | ${TR} -d '[]," '))

if [[ "${DATA[0]}" == "success" ]]; then
        echo "${DATA[1]}, ${DATA[2]} ${DATA[3]}"
fi 

