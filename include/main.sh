#!/bin/bash

# Include
. include/constants.sh
. include/functions.sh

# don't set it via the shebang otherwise it won't be inherited
set -eu

# disable CTRL+C
trap '' INT

# error handler
term() {
    echo "Unexpected termination (exit code: $?)"
    exit
}
trap term TERM

# Check we're not root unless explicitly allowed
[ $UID -ne 0 ] || $FORCE_ROOT || FATAL \
"This software does NOT need root privileges to run." \
"If you really want to execute it under the root user, you can pass the '-f' flag."

# Handle excluded tests
current_test=$(echo $0 | sed -r 's#tests/(.*)\.sh#\1#')
if [[ "$EXCLUDE_TESTS" =~ " $current_test " ]]; then
    $VERBOSE && NOTICE "$0 excluded" >&2
    exit 0
fi

return 0

