#!/bin/bash

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# CCE-ID: CCE-15007-8
# Orignal-platform: rhel5
# Modified: 2010-09-26
# Description: The nodev option should be enabled or disabled for /dev/shm.
# Parameters: enabled / disabled
# Technical-mechanisms: via /etc/fstab

. $(dirname $0)/../include/main.sh

FILE /etc/fstab

[ "$(awk '$2=="/dev/shm" && $4!~"nodev"' $file)" ] && \
    CRITICAL "Add the option 'nodev' in column 4 for /dev/shm in $file"

exit $ret

