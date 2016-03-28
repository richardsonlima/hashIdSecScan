#!/bin/sh 

##############################################
#  HashId SecScan 2016 by Richardson Lima
#  
#
#
#
#
##############################################

# Include
. ./constants

UMASK_OPTION="027"

###
echo -e ""
            echo -e "      ==============================================================================="
            echo -e "        ${NOTICE} ${PROGRAM_name} ${NORMAL}"
            echo -e "      ==============================================================================="
            echo -e ""
            echo -e "        Current version : ${YELLOW}${PROGRAM_CV}${NORMAL}   Latest version : ${GREEN}${PROGRAM_LV}${NORMAL}"
            echo -e ""
            echo -e "        ${WHITE}Please update to the latest version for new features, bug fixes, tests"
            echo -e "        and baselines.${NORMAL}"
            echo -e ""
            echo -e "        https://www.hashidsecscan.com.br/downloads/"
            echo -e ""
            echo -e "      ==============================================================================="
            echo -e ""
            sleep 5
###
trap run_tests ERR EXIT
run_tests() { 
   CheckUmask
   MyUser
   BuildDir
   NeedsDir
}
. ./functions 
x
