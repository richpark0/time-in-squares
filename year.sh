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
BG_BLACK="$(tput setab 0)"
BG_RED="$(tput setab 1)"
BG_GREEN="$(tput setab 2)"
BG_YELLOW="$(tput setab 3)"
BG_BLUE="$(tput setab 4)"
BG_MAGENTA="$(tput setab 5)"
BG_CYAN="$(tput setab 6)"
BG_WHITE="$(tput setab 7)"

# foreground colours
FG_BLACK="$(tput setaf 0)"
FG_RED="$(tput setaf 1)"
FG_GREEN="$(tput setaf 2)"
FG_YELLOW="$(tput setaf 3)"
FG_BLUE="$(tput setaf 4)"
FG_MAGENTA="$(tput setaf 5)"
FG_CYAN="$(tput setaf 6)"
FG_WHITE="$(tput setaf 7)"

# colours in use: character
BG_COL=${BG_RED}
FG_COL=${FG_WHITE}

# colours in use: heading
BG_HEADER=${BG_BLACK}
FG_HEADER=${FG_CYAN}

# | Year progress with days |
daily() {
    # counter of days past in the year
    counter=1
    while [ $counter -le $MAX_DAYS ]
    do
        if [ $counter -lt $THIS_YEAR_DAYS ]
        then
            BG_COL=${BG_RED}
        elif [ $counter -eq $THIS_YEAR_DAYS ]
        then
            BG_COL=${BG_WHITE}
        else
            BG_COL=${BG_BLACK}
        fi
        printf "${BG_COL}${FG_COL}${SQUARE}"
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

    ctr_month=1
    for mon_str in "${month_str_arr[@]}"
    do
        # short form of month label
        printf "${COL_HEADER}$mon_str "

        # number of days in the indexed month
        max_days=`cal $ctr_month $CURRENT_YEAR | awk 'NF {D = $NF}; END {print D}'`

        # assign proper colour
        if [ $ctr_month -lt $CURRENT_MONTH ]
        then
            COL_CURRENT=${COL_RED}
            for i in $(eval echo {0..$max_days})
            do
                printf "${COL_CURRENT}${CHARACTER_COL}${SQUARE}"
            done
        else
            COL_CURRENT=${COL_BLACK}
            for i in $(eval echo {0..$max_days})
            do
                printf "${COL_CURRENT}${CHARACTER_COL}${SQUARE}"
            done
        fi
        
        printf "\n"
        ((ctr_month++))
    done

    # for date_idx in "${DATE_ARR[@]}"
    # do
    #     echo $date_idx
    # done
}

# daily
monthly
