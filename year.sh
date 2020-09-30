#!/bin/bash

# basic date info
DATE_INFO=`date +"%Y %m %d %s"`
DATE_ARR=($(echo $DATE_INFO | tr " " "\n"))
CURRENT_YEAR=${DATE_ARR[0]}
CURRENT_MONTH=${DATE_ARR[1]}
CURRENT_DAY=${DATE_ARR[2]}
CURRENT_SECONDS=${DATE_ARR[3]}

START_SECONDS=`date +%s --date "${CURRENT_YEAR}-01-01"`

# number of days past this year
THIS_YEAR_SECONDS=$(($CURRENT_SECONDS-$START_SECONDS))
THIS_YEAR_DAYS=$(($THIS_YEAR_SECONDS/(3600*24)))

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

# | Year progress with days |
basic() {
    # counter of days past in the year
    counter=0
    while [ $counter -le $MAX_DAYS ]
    do
        if [ $counter -lt $THIS_YEAR_DAYS ]
        then
            COL_CURRENT=${COL_RED}
        elif [ $counter -eq $THIS_YEAR_DAYS ]
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
}

# | Monthly Separated |
monthly() {
    # months in the short form
    month_str=`locale abmon` 
    month_str_arr=($(echo $month_str | tr ";" "\n"))
    echo $month_str_arr

    # resulting output
    # TODO: string or vector
    output=''

    for mon_idx in "${month_str_arr[@]}"
    do
        echo $mon_idx
    done

    counter=0
    while [ $counter -le $MAX_DAYS ]
    do
        # colour picker
        if [ $counter -lt $CURRENT_DAYS ]
        then
            COL_CURRENT=${COL_RED}
        elif [ $counter -eq $CURRENT_DAYS ]
        then
            COL_CURRENT=${COL_WHITE}
        else
            COL_CURRENT=${COL_BLACK}
        fi

        # seperate days in months


        # is_column_end=$(($counter % 3))
        # if [ $is_column_end -eq 0 ]
        # then
        #     printf "\n%s" "${COL_CURRENT}${CHARACTER_COL}${SQUARE}"
        # else
        #     printf "%s" "${COL_CURRENT}${CHARACTER_COL}${SQUARE}"
        # fi
        ((counter++))
    done
    printf "%s" "${output}"
    # remove the last character - weird output %
    echo
}

# monthly
basic
