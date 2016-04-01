#!/bin/bash

# Colors

    NORMAL="\033[1;39m"
    WARNING="\033[1;31m"          # Bad (red)
    TITLE="\033[0;34m"            # Information (blue)
    NOTICE="\033[1;33m"           # Notice (yellow)
    OK="\033[1;32m"               # Ok (green)
    BAD="\033[1;31m"              # Bad (red)

    # Normal color names
    YELLOW="\033[1;33m"
    WHITE="\033[1;37m"
    GREEN="\033[1;32m"
    RED="\033[1;31m"
    PURPLE="\033[0;35m"
    MAGENTA="\033[1;35m"
    BROWN="\033[0;33m"
    CYAN="\033[0;36m"
    BLUE="\033[0;34m"
#

# System Paths
BIN_PATHS="/bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin \
          /usr/local/libexec /usr/libexec /usr/sfw/bin /usr/sfw/sbin \
          /usr/sfw/libexec /opt/sfw/bin /opt/sfw/sbin /opt/sfw/libexec \
          /usr/xpg4/bin /usr/css/bin /usr/ucb /usr/X11R6/bin /usr/X11R7/bin \
          /usr/pkg/bin /usr/pkg/sbin"

ETC_PATHS="/etc /usr/local/etc"

# Do not use specific language, fall back to default
unset LANG

#
UMASK_OPTION="027"

# Initialize defaults
# Variable initializing
    PROGRAM_name=" HashId SecScan"
    PROGRAM_CV="v1.0.0"
    PROGRAM_LV="v1.0.1"
    PROFILE=""

# Errors
declare -ir E_FATAL=1     # exit code for fatal errors
declare -ir E_INTERNAL=2  # exit code for internal errors, i.e. bugs

# Other colors schemas
declare -A COLOR
COLOR=([default]="\e[0m" [red]="\e[31m" [red_bold]="\e[1;31m" [yellow]="\e[33m" [yellow_bold]="\e[1;33m" [green]="\e[32m" [green_bold]="\e[1;32m")

# Problem severities which can be returned by tests
declare -A SEVERITY
SEVERITY=([ok]=0 [trivial]=1 [minor]=2 [major]=3 [critical]=4)

declare -A SEVERITY_COLOR
SEVERITY_COLOR=([ok]=green [trivial]=yellow [minor]=yellow_bold [major]=red [critical]=red_bold)

# Default
declare -i ret=${SEVERITY[ok]}

# Lock file for flock
declare -rx LOCK_FILE=.lock

# FIXME: get rid of those vars
SKIP_ROOT=false
EXECUTE_ROOT=false
FORCE_ROOT=false
VERBOSE=false
EXCLUDE_TESTS=''
OUTPUT_FILE=''
MINIMAL_SEVERITY=${SEVERITY[trivial]}

ARGS=$(getopt -uo "h,s,e,f,v,x:,o:,m:" -l "help,verbose,version,skip-root,execute-root,force-root,exclude:,output-file:,minimal-severity:" -n hashidsecscan -- "$@")
[ $? -ne 0 ] && usage

eval set -- "$ARGS"
while true; do
    case "$1" in
    -h|--help)
        usage;;
    -s|--skip-root)
        SKIP_ROOT=true
        shift;;
    -e|--execute-root)
        EXECUTE_ROOT=true
        shift;;
    -f|--force-root)
        FORCE_ROOT=true
        EXECUTE_ROOT=true
        shift;;
    -v|--verbose)
        VERBOSE=true
        shift;;
    -x|--exclude)
        EXCLUDE_TESTS="${EXCLUDE_TESTS} $2 "
        shift 2;;
    -o|--output-file)
        OUTPUT_FILE=$2
        shift 2;;
    -m|--minimal-severity)
        set +u
        if [ "${SEVERITY[$2]}" ]; then
           MINIMAL_SEVERITY=${SEVERITY[$2]}
        else
           FATAL "Severity is invalid." >&2
        fi
        set -u
        shift 2;;
    --version)
        echo "hashidsecscan version 0.1" >&2
        exit 0;;
    --)
        shift; break;;
    *)
        FATAL "Unknown parameter: \`$1'" >&2 ;;
    esac
done
