#!/bin/bash

# basic date info
TODAY=`date +%s`
CURRENT_YEAR=`date +%Y`
START_OF_YEAR=`date +%s --date "${CURRENT_YEAR}-01-01"`

# number of days past this year
START_TO_NOW=$(($TODAY-$START_OF_YEAR))
CURRENT_DAYS=$(($START_TO_NOW/(3600*24)))

# total number of days this year
MAX_DAYS=365
LEAP_YEAR=$(($CURRENT_YEAR % 4))
if [ $LEAP_YEAR -eq 1 ]
then
    MAX_DAYS=366
fi

# daily character symbol
SQUARE="_/"

# background colours
COL_BLACK="$(tput setab 0)"
COL_RED="$(tput setab 1)"
COL_GREEN="$(tput setab 2)"
COL_YELLOW="$(tput setab 3)"
COL_BLUE="$(tput setab 4)"
COL_MAGENTA="$(tput setab 5)"
COL_CYAN="$(tput setab 6)"
COL_WHITE="$(tput setab 7)"

# colours in use
COL_CURRENT=${COL_RED}
CHARACTER_COL="$(tput setaf 7)"

# counter of days past in the year
counter=0
while [ $counter -le $MAX_DAYS ]
do
    if [ $counter -lt $CURRENT_DAYS ]
    then
        COL_CURRENT=${COL_RED}
    elif [ $counter -eq $CURRENT_DAYS ]
    then
        COL_CURRENT=${COL_WHITE}
    else
        COL_CURRENT=${COL_BLACK}
    fi
    printf "%s" "${COL_CURRENT}${CHARACTER_COL}${SQUARE}"
    ((counter++))
done
# remove the last character - weird output %
echo
