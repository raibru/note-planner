#!/bin/bash
#
# call: build_weekly.sh Week-Number-Begin Week-Number-End Year
#

WEEK_PLAN_TEMP=Planner-Weekly
RES_DIR=../res
BUILD_DIR=../../build

function weekof()
{
    local week=$1 year=$2
    local -n result=$3

    local week_num_of_Jan_1 week_day_of_Jan_1
    #local date_fmt="+%a %d. %b %Y"
    local date_fmt="+%a %d. %b"
    local date_small_fmt="+%a %d"
    local date_weeklead_fmt="+%W"
    local date_month_fmt="+%m"
    local first_Mon
    local mon sun
    local date_mon
    local date_tue
    local date_wed
    local date_thu
    local date_fri
    local date_sat
    local date_son
    local weeklead
    local month

    week_num_of_Jan_1=$(date -d $year-01-01 +%W)
    week_day_of_Jan_1=$(date -d $year-01-01 +%u)

    if ((week_num_of_Jan_1)); then
        first_Mon=$year-01-01
    else
        first_Mon=$year-01-$((01 + (7 - week_day_of_Jan_1 + 1) ))
    fi

    mon=$(date -d "$first_Mon +$((week - 1)) week" "$date_fmt")
    sun=$(date -d "$first_Mon +$((week - 1)) week + 6 day" "$date_fmt")

     # week number with leading zero
    weeklead=$(date -d "$first_Mon +$((week - 1)) week" "$date_weeklead_fmt")
    # Month where week monday includes
    month=$(date -d "$first_Mon +$((week - 1)) week" "$date_month_fmt")


    date_mon=$(date -d "$first_Mon +$((week - 1)) week" "$date_small_fmt")
    date_tue=$(date -d "$first_Mon +$((week - 1)) week + 1 day" "$date_small_fmt")
    date_wed=$(date -d "$first_Mon +$((week - 1)) week + 2 day" "$date_small_fmt")
    date_thu=$(date -d "$first_Mon +$((week - 1)) week + 3 day" "$date_small_fmt")
    date_fri=$(date -d "$first_Mon +$((week - 1)) week + 4 day" "$date_small_fmt")
    date_sat=$(date -d "$first_Mon +$((week - 1)) week + 5 day" "$date_small_fmt")
    date_sun=$(date -d "$first_Mon +$((week - 1)) week + 6 day" "$date_small_fmt")

    #printf "%s - %s %s KW %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $mon $sun $year $week $date_mon $date_tue $date_wed $date_thu $date_fri $date_sat $date_sun
    result=$(echo "$mon - $sun $year;KW $week;$date_mon;$date_tue;$date_wed;$date_thu;$date_fri;$date_sat;$date_sun;$weeklead;$month")
    #echo "\"$mon\" - \"$sun\""

}

function build_weekly()
{
    local mstart=$1
    local mend=$2
    local year=$3


    local header
    local kw
    local month
    local date_mon
    local date_tue
    local date_wed
    local date_thu
    local date_fri
    local date_sat
    local date_son


    for i in $(seq $mstart $mend)
    do
      local w
      weekof $i $year w

      local weeklead=$(echo "$w" |cut -d';' -f10)
      local month=$(echo "$w" |cut -d';' -f11)

      local src_file=${RES_DIR}/$WEEK_PLAN_TEMP.png
      local dest_file=${BUILD_DIR}/${WEEK_PLAN_TEMP}_${year}_$weeklead.png
      local month_print=${BUILD_DIR}/month_print.tmp

      #ncal -Mwbh $month $year > $month_print
      
      header=$(echo "$w" |cut -d';' -f1)
      kw=$(echo "$w" |cut -d';' -f2)
      date_mon=$(echo "$w" |cut -d';' -f3)
      date_tue=$(echo "$w" |cut -d';' -f4)
      date_wed=$(echo "$w" |cut -d';' -f5)
      date_thu=$(echo "$w" |cut -d';' -f6)
      date_fri=$(echo "$w" |cut -d';' -f7)
      date_sat=$(echo "$w" |cut -d';' -f8)
      date_sun=$(echo "$w" |cut -d';' -f9)

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 24 \
        -draw "text 20,50 '$header'" \
        -draw "text 700,50 '$kw'" \
        -draw "text 410,105 '$date_mon'" \
        -draw "text 410,255 '$date_tue'" \
        -draw "text 410,405 '$date_wed'" \
        -draw "text 410,555 '$date_thu'" \
        -draw "text 410,705 '$date_fri'" \
        -draw "text 410,855 '$date_sat'" \
        -draw "text 410,1005 '$date_sun'" \
        $src_file \
        $dest_file

      echo -n "."

    done

    convert $BUILD_DIR/${WEEK_PLAN_TEMP}_*.png $BUILD_DIR/planner-weekly-$year.pdf

    echo "done"
}

build_weekly $1 $2 $3
