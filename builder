#!/bin/bash

##############################################
#  HashId SecScan 2016 by Richardson Lima
#
#
#
#
#
##############################################

# Include
source include/constants
source include/functions

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

trap main ERR EXIT
main() {
   CheckUmask
   MyUser
   BuildDir
   NeedsDir
   Env
}
