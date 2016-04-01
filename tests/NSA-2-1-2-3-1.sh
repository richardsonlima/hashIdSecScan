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

# NSA-ID: NSA-2-1-2-3-1
# Orignal-platform: rhel5
# Modified: 2011-02-28
# Description: Check for package updates.
# Parameters: up-to-date / outdated
# Technical-mechanisms: via yum

. $(dirname $0)/../include/main.sh

case $(DISTRO) in
redhat)
    list=$(yum -q check-update)
    cmd="yum update"
    ;;
debian)
    # haven't found a way without being root so far
    SUDO apt-get -qq update
    list=$(SUDO apt-get -q --dry-run upgrade)
    list=$(echo "$list" | grep '^Inst' | cut -d' ' -f2-)
    cmd="apt-get upgrade"
    ;;
archlinux)
    SUDO pacman -Sy > /dev/null
    list=$(pacman -Qu)
    cmd="pacman -Syu"
    ;;
*)
    MAJOR \
    "Unable to detect if your system is up-to-date, please check manually"
esac

[ "$list" ] && {
    MAJOR "Update your packages with '$cmd'"
    $VERBOSE && echo -e "List of available updates:$list"
}

exit $ret

