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

# CCE-ID: CCE-14847-8
# Orignal-platform: rhel5
# Modified: 2010-09-26
# Description: The default umask for all users should be set correctly in /etc/profile
# Parameters: umask
# Technical-mechanisms: via /etc/profile

. $(dirname $0)/../include/main.sh

case $(DISTRO) in
    debian) exit 0;;
    *)      FILE /etc/profile;;
esac

GREP "^\s*umask\s+077" $file || \
    MINOR "Add or correct the line 'umask 077' in $file"

exit $ret

