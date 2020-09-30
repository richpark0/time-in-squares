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
        printf "${BG_HEADER}${FG_HEADER}$mon_str:"

        # number of days in the indexed month: add month minus day
        max_days=`date -d "$ctr_month/1 + 1 month - 1 day" "+%d"`

        # assign proper colour
        if [ $ctr_month -lt $CURRENT_MONTH ]
        then
            BG_COL=${BG_RED}
            for ((i=1; i <= ${max_days}; i++))
            do
                printf "${BG_COL}${FG_COL}${SQUARE}"
            done
        elif [ $ctr_month -eq $CURRENT_MONTH ]
        then
            for ((i=1; i <= $((CURRENT_DAY-1)); i++))
            do
                printf "${BG_COL}${FG_COL}${SQUARE}"
            done

            # today
            BG_COL=${BG_WHITE}
            FG_COL=${FG_RED}
            printf "${BG_COL}${FG_COL}X"

            # rest of the month
            BG_COL=${BG_BLACK}
            FG_COL=${FG_WHITE}

            for ((i=$((CURRENT_DAY+1)), j=$max_days; i <= j; i++ ))
            do
                printf "${BG_COL}${FG_COL}${SQUARE}$i"
            done
        else
            BG_COL=${BG_BLACK}
            for ((i=1; i <= ${max_days}; i++))
            do
                printf "${BG_COL}${FG_COL}${SQUARE}"
            done
        fi

        printf "${BG_HEADER}\n"
        ((ctr_month++))
    done
}

# daily
monthly
