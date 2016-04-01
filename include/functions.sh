#!/bin/sh

# Include
source include/constants.sh

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
CheckUmask(){

  if [ $? -eq 0 ]; then
       echo "Usually servers can have a more strict umask like (027), where desktops may be less strict (022)."
       echo -e "${OK} [+] Setting umask: ${NORMAL}"; umask $UMASK_OPTION && echo $UMASK_OPTION
     else
       echo -e "${WARNING} [x] Could not set umask ${NORMAL}"
  fi
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
MyUser(){
  IM=`whoami`
  if [ "${IM}" = "root" ]; then
      echo -e "${WARNING} [x] This programm should not be executed as root ${NORMAL}"
      return 0
  else
      echo -e "${OK} [+] User: ${NORMAL}" ${IM}
    fi
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
BuildDir(){
  BUILDDIR="/opt/hashId-SecScan"
  if [ ! -d ${BUILDDIR} ]; then
      echo -e "${WARNING} [x] Directory not found: ${NORMAL}" ${BUILDDIR}
      echo -e "${WARNING} Hint:  Missing directory ... ${NORMAL}"
      echo -e "${OK} [+] Creating directory in: ${NORMAL}" ${BUILDDIR} ;sudo mkdir -p ${BUILDDIR}
    else
      echo -e "${NOTICE} [+] BuildDir found: ${NORMAL}" ${BUILDDIR}
  fi
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
NeedsDir(){
NEEDSDIR="include db logs"
for DIR in ${BUILDDIR}/${NEEDSDIR}; do
  if [ ! -d "${DIR}" -a ! -h "${DIR}" ]; then
  #if [ ! -d ${DIR} ]; then
    echo -e "${WARNING} [x] Directory not found: ${NORMAL}" ${DIR}
    echo -e "${WARNING} [x] Hint:  Missing directory ... ${NORMAL}"
    echo -e "${OK} [+] Creating directory in: ${NORMAL}" ${DIR} ; sudo mkdir -p ${DIR}
else
    echo -e "${NOTICE} [+] Directory found: ${NORMAL}" ${DIR}
fi
done
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
CheckIncludeFiles(){
INCLUDE_DIR="${BUILDDIR}/include"
if sudo find -- "${INCLUDE_DIR}" -prune -type d -empty | grep -q .; then
  echo -e "${WARNING} [+] Now ${INCLUDE_DIR} is an empty directory ${NORMAL}"; CreateIncludeFiles
else
  echo -e "${OK} [+] Files found in include directory: ${NORMAL}" ${INCLUDE_DIR}
  echo -e "${NOTICE} [+] Now ${INCLUDE_DIR} is not empty, or is not a directory" \
                    "or is not readable or searchable in which case" \
                    "you should have seen an error message from find above. ${NORMAL}"
fi
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
CreateIncludeFiles(){
           echo -e "${WARNING} [x] Include files wasn't found in include directory ... ${NORMAL}"
           echo -e "${OK} [+] Creating files in: ${NORMAL}" ${INCLUDE_DIR}; sudo cp -Rfa include/{constants,functions} ${INCLUDE_DIR}
           echo -e "${NOTICE} [+] Creating alias in user environment ... ${NORMAL}";sudo echo "alias hashidsecscan='/opt/hashId-SecScan/hashidsecscan' " >> ~/.bash_alias
           echo -e "${NOTICE} [+] Enabling alias in user environment ... ${NORMAL}";source ~/.bash_alias

}

## severity helpers

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
set_exit_code() {
    # keep the most critical code (biggest number) or OK
    [ $1 -gt $ret -o $1 -eq ${SEVERITY[ok]} ] && ret=$1
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
set_severity() {
    local severity=$1
    shift

    [ $MINIMAL_SEVERITY -le ${SEVERITY[$severity]} ] || return
    echo -e "${COLOR[${SEVERITY_COLOR[$severity]}]}${severity^}: $@${COLOR[default]}"
    set_exit_code ${SEVERITY[$severity]}
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
CRITICAL() {
    set_severity critical $@
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
MAJOR() {
    set_severity major $@
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
MINOR() {
    set_severity minor $@
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
TRIVIAL() {
    set_severity trivial $@
}


## colored message helpers

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# handy helper to display a warning message
function WARNING
{
    echo -e "${COLOR[red]}$@${COLOR[default]}"
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# handy helper to display a notice message
function NOTICE
{
    echo -e "${COLOR[yellow]}$@${COLOR[default]}"
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# handy helper to display a success message
function SUCCESS
{
    echo -e "${COLOR[green]}$@${COLOR[default]}"
}

## test helpers

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# returns the distribution family (i.e. CentOS and Fedora will return 'redhat')
function DISTRO
{
    [ -e /etc/redhat-release ] && { echo redhat; return; }
    [ -e /etc/debian_version ] && { echo debian; return; }
    [ -e /etc/arch-release ] && { echo archlinux; return; }
    echo unknown
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# any fatal error to the program
function FATAL
{
    echo -e "${COLOR[red_bold]}FATAL ERROR: $@${COLOR[default]}" >&2
    exit $E_FATAL
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# abort a test which cannot complete
function ABORT
{
    echo -e "${COLOR[red_bold]}FATAL ERROR: ${1}\nTest $(basename $0) aborted${COLOR[default]}" >&2
    exit $E_FATAL
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# abort if any given file is not readable
function FILE
{
    for f; do
        file=$f
        [ -r "$file" ] || ABORT "Unable to read file '$file'."
        shift
    done
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# sweet grep wrapper
function GREP
{
    [ $# -lt 1 -o $# -gt 3 ] && exit $E_INTERNAL

    [ $# -eq 3 ] && { options=$1 ; shift; } || options=--
    [ $# -eq 1 ] && file=- <&1 || { FILE $2; file=$2; }

    pattern=$1

    grep -Eq $options "$pattern" $file
    return
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# test if a program/command is installed and available
function INSTALLED
{
    [ $# -ne 1 ] && exit $E_INTERNAL

    which "$1" &>/dev/null
    return
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
# interactive sudo wrapper which handles concurrent calls
function SUDO
{
    if $SKIP_ROOT; then
        NOTICE "$0 skipped because '-s' flag has been set" >&2
        return 1
    fi

    cmd="$@"

    (
        flock -x 200
        if $EXECUTE_ROOT; then
            choice=e
        else
            echo -en "Command ${COLOR[yellow_bold]}\`${cmd}'${COLOR[default]}" \
            "needs root privileges, [e]xecute or [s]kip [s]? " >&2
            read -u 2 choice
            [ -z "$choice" ] && choice=s
        fi

        case $choice in
            e) [ $UID -eq 0 ] && $cmd || sudo -- $cmd ; return ;;
            s|*) NOTICE "$0 skipped" >&2 ; return 1 ;;
        esac
    ) 200>$LOCK_FILE
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
usage() {
    cat >&2 <<USAGE
Usage: $(basename $0) [OPTION]...
  -h  Display this help
  -s  Skip all tests where root privileges are required (overrides -e)
  -e  Execute all tests where root privileges are required
  -f  Force the program to run even with root privileges (implies -e)
  -v  Be verbose
  -x <test>  Test to exclude (can be repeated, e.g. -x CCE-3561-8 -x NSA-2-1-2-3-1)
  -o <file>  Write the list of failed tests into an output file
  -m (trivial|minor|major|critical) Minimal severity to report
USAGE

    exit 1
}

##############################################
# Name            :
# Description     :
# Returns         :
##############################################
check_command()
{
    for cmd; do
        command -v $cmd >/dev/null || \
            FATAL "Command \`$cmd' not found in 'PATH=$PATH'" >&2
    done
}

check_command find grep mv rm sed /sbin/sysctl xargs
case $(DISTRO) in
    redhat) check_command yum;;
    debian) check_command apt-get;;
    archlinux) check_command pacman;;
esac
