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

# CCE-ID: CCE-3660-8
# Orignal-platform: rhel5
# Modified: 2010-09-26
# Description: Remote connections from accounts with empty passwords should be enabled or disabled as appropriate
# Parameters: enabled / disabled
# Technical-mechanisms: via /etc/ssh/sshd_config

. $(dirname $0)/../include/main.sh

[ -f /etc/ssh/sshd_config ] || exit 0

SUDO grep -Eq '^\s*PermitEmptyPasswords\s+yes' /etc/ssh/sshd_config && CRITICAL \
    "Remove 'PermitEmptyPasswords yes' from /etc/ssh/sshd_config"

exit $ret

