#!/usr/bin/bash
#
# Script that prints geolocation data for a given IPv4 address
# Created for ubuntu 24.04 - bash 5.2.21 - jq 1.7 - curl 8.5.0
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

set -o pipefail

# Geolocation API base URL (no trailing slash)
GAPIURL="http://ip-api.com/json"
# Fields requested from the API
GFIELDS="status,message,city,regionName,country"

for tool in jq curl; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Error: $tool is not installed." >&2
    exit 1
  fi
done

IP_RE='^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$'

if [[ -z "$1" ]]; then
  echo "Usage: $0 <ip>" >&2
  exit 1
fi

if ! [[ "$1" =~ $IP_RE ]]; then
  echo "Error: '$1' is not a valid IPv4 address." >&2
  exit 1
fi

response=$(curl -s --max-time 5 "${GAPIURL}/${1}?fields=${GFIELDS}")

if [[ -z "$response" ]]; then
  echo "Error: no response from geolocation service." >&2
  exit 1
fi

status=$(jq -r '.status' <<<"$response")

if [[ "$status" != "success" ]]; then
  message=$(jq -r '.message // "unknown error"' <<<"$response")
  echo "Error: $message" >&2
  exit 1
fi

IFS=$'\t' read -r city region country < <(jq -r '[.city, .regionName, .country] | @tsv' <<<"$response")

echo "${city}, ${region} ${country}"
