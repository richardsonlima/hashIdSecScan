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

# CCE-ID: CCE-3870-3
# Orignal-platform: rhel5
# Modified: 2010-09-26
# Description: The default umask for all users should be set correctly
# Parameters:
# Technical-mechanisms:

. $(dirname $0)/../include/main.sh

[ -d /etc/profile.d ] || exit 0

for file in $(find /etc/profile.d/ -type f); do
    GREP "^\s*umask\s+" "$file" && {
        GREP "^\s*umask\s+077" "$file" || \
        MINOR "Add or correct the line 'umask 077' in $file"
    }
done

exit $ret

