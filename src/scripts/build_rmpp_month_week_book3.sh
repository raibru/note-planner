#!/bin/bash

#
# Build a reMarkable Paper Pro Weekly Block as weekly calendar
# matrix 
# call: build_rmpp_weekblock_book.sh Year
#
# Requisites: ncal, tex {for: pdf, booklet}, imagemagik {for: convert}
#

set -eu
set -o pipefail

ARGS=("$@")

YEAR_MONTH_TEMP=RMPP-Planner-Empty
YEAR_OVERVIEW_TEMP=RMPP-Planner-Yearly
QUAT_PLAN_GOALS_TEMP=RMPP-Planner-Quartarly
MONTH_CAL_TEMP=RMPP-Planner-Monthly-6
WEEK_CAL_TEMP=RMPP-Planner-Weekly-HBlock-Col
WEEK_PLAN_MATRIX_TEMP=RMPP-Planner-Task-Matrix
WEEK_NOTE_PAGE_TEMP=RMPP-Note-Dots
PLAN_TEMP_PATTERN=Planner-*.png
RES_DIR=../res
BUILD_DIR=../../build/build_rmpp_calendar
ARTIFACTS_DIR=../../artifacts/RMPP-Calendar

WEEK_COUNT=52 # ueberschrieben in build weekly

function build_yearly_month()
{
    local year=$1
    local page_nr=$2

    echo "-- start building yearly planning page..."

    local header=$(echo "$1")
    local src_file=${RES_DIR}/$YEAR_MONTH_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Yearly_Month_${year}.png

      # -font helvetica \

    convert  \
      -font /usr/share/fonts/opentype/comic-neue/ComicNeue-Regular.otf \
      -fill black \
      -pointsize 26 \
      -draw "text 390,45 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 18  \
      -draw "text 70, 100  '$(gcal -K --iso-week-number=yes -H no -s 1 1 ${year})'" \
      -draw "text 70, 270  '$(gcal -K --iso-week-number=yes -H no -s 1 3 ${year})'" \
      -draw "text 70, 440  '$(gcal -K --iso-week-number=yes -H no -s 1 5 ${year})'" \
      -draw "text 70, 610 '$(gcal -K --iso-week-number=yes -H no -s 1 7 ${year})'" \
      -draw "text 70, 780 '$(gcal -K --iso-week-number=yes -H no -s 1 9 ${year})'" \
      -draw "text 70, 950 '$(gcal -K --iso-week-number=yes -H no -s 1 11 ${year})'" \
      -draw "text 450, 100  '$(gcal -K --iso-week-number=yes -H no -s 1 2 ${year})'" \
      -draw "text 450, 270  '$(gcal -K --iso-week-number=yes -H no -s 1 4 ${year})'" \
      -draw "text 450, 440  '$(gcal -K --iso-week-number=yes -H no -s 1 6 ${year})'" \
      -draw "text 450, 610 '$(gcal -K --iso-week-number=yes -H no -s 1 8 ${year})'" \
      -draw "text 450, 780 '$(gcal -K --iso-week-number=yes -H no -s 1 10 ${year})'" \
      -draw "text 450, 950 '$(gcal -K --iso-week-number=yes -H no -s 1 12 ${year})'" \
      $src_file \
      $dest_file

    echo "-- ...done"
}

function build_quartarly_plan_goal()
{
    local year=$1
    local page_nr=$2

    echo "-- start building quatarly year pages..."

    for i in $(seq 1 4)
    do
      local header=$(echo "Quartal $i")
      local src_file=${RES_DIR}/$QUAT_PLAN_GOALS_TEMP.png
      local dest_file=${BUILD_DIR}/Planner-${page_nr}-Quartarly_${year}.${i}-2.png

      local m1=""
      local m2=""
      local m3=""

      case $i in
        1 )
          m1="January"
          m2="February"
          m3="March"
          ;;
        2 )
          m1="April"
          m2="May"
          m3="June"
          ;;
        3 )
          m1="July"
          m2="August"
          m3="September"
          ;;
        4 )
          m1="October"
          m2="November"
          m3="December"
          ;;
        esac

      echo "--- ...Q${i} | ${m1} | ${m2} | ${m3} | ${QUAT_PLAN_GOALS_TEMP}"

        # -font helvetica \

      convert  \
        -font /usr/share/fonts/opentype/comic-neue/ComicNeue-Regular.otf \
        -fill black \
        -pointsize 22 \
        -draw "text 30,45 '$header'" \
        -draw "text 760,45 '$year'" \
        -pointsize 14 \
        -draw "text 300,100 '$m1'" \
        -draw "text 490,100 '$m2'" \
        -draw "text 690,100 '$m3'" \
        $src_file \
        $dest_file

    done

    echo "-- ...done"
}

function build_monthly_calendar()
{
    local year=$1
    local page_nr=$2


    echo "-- start building monthly calendar page..."

    local src_file=${RES_DIR}/$MONTH_CAL_TEMP.png

    for mon in $(seq 1 12)
    do

      #local monDays=("--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--")
       local monDays=("  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
      #local monWeekNums=("--" "--" "--" "--" "--" "--")
       local monWeekNums=("  " "  " "  " "  " "  " "  ")

      local fdayIdx=1
      local ldayIdx=$(date -d "$year-$mon-$fdayIdx +1 month -1 day" '+%d')
      local fwdayIdx=$(date -d "$year-$mon-$fdayIdx" '+%u')
      local lwdayIdx=$(date -d "$year-$mon-$ldayIdx" '+%u')
      local fweekIdx=$(date -d "$year-$mon-$fdayIdx" '+%V')
      local lweekIdx=$(date -d "$year-$mon-$ldayIdx" '+%V')
      local mwCount=$(expr 1 + $lweekIdx - $fweekIdx)
      local monName=$(date -d "$year-$mon-$fdayIdx" '+%B')
      local monNum=$(date -d "$year-$mon-$fdayIdx" '+%m')
      local idx=$(expr $fwdayIdx - 1)

      for i in $(seq 1 $ldayIdx)
      do
          monDays[$idx]=$(printf '%02d' $i)
          idx=$(expr $idx + 1)
      done

      local icount=$(echo $(($mwCount*1)))
      if [ "$icount" -lt 1 ];
      then
        local widx=$(date -d "$year-$mon-$ldayIdx -7 day" '+%V')
        widx=$(expr $widx + 2)
        mwCount=$(expr $widx - $fweekIdx)
      fi

      local wnr=$(echo $((10#$fweekIdx*1)))
      for i in $(seq 1 $mwCount)
      do
        local wnrIdx=$(expr $i - 1)
        monWeekNums[$wnrIdx]=$(printf '%02d' $wnr)
        wnr=$(expr $wnr + 1)
      done

      #echo "first week day idx: $fwdayIdx"
      #echo "last week day idx : $lwdayIdx"
      #echo "first week idx    : $fweekIdx"
      #echo "last week idx    : $lweekIdx"
      #echo "weeks per month   : $mwCount"
      echo "--- Month $mon: ${monDays[@]}"
      echo "--- WeekNum $mon: ${monWeekNums[@]}"

      #for i in $(seq 1 $mwCount)
      #do
      #    local idx=$(expr $i - 1)
      #    #echo $(expr 7 \* $idx)
      #    local vdate=${monDays[$idx]}
      #    if [ "$vdate" = "--" ];
      #    then
      #        vdate=${monDays[$(expr $idx + 6)]}
      #    fi
      #    local wnr=$(date -d "$year-$mon-$vdate" '+%V')
      #    #echo "Month $mon: $wnr: ${monDays[@]:$idx:7}"
      #done
      
      #echo "---------------------------------------------"

      local dest_file=${BUILD_DIR}/Planner-${page_nr}-${monNum}-Monthly_${year}.png

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 48 \
        -draw "text 40,58 '$monName'" \
        -font helvetica \
        -fill black \
        -pointsize 20 \
        -draw "text 40,215 '${monWeekNums[0]}'" \
        -draw "text 40,375 '${monWeekNums[1]}'" \
        -draw "text 40,545 '${monWeekNums[2]}'" \
        -draw "text 40,705 '${monWeekNums[3]}'" \
        -draw "text 40,875 '${monWeekNums[4]}'" \
        -draw "text 40,1045 '${monWeekNums[5]}'" \
        -font helvetica \
        -fill black \
        -pointsize 20 \
        -draw "text 90,150 '${monDays[0]}'" \
        -draw "text 192,150 '${monDays[1]}'" \
        -draw "text 294,150 '${monDays[2]}'" \
        -draw "text 398,150 '${monDays[3]}'" \
        -draw "text 500,150 '${monDays[4]}'" \
        -draw "text 604,150 '${monDays[5]}'" \
        -draw "text 710,150 '${monDays[6]}'" \
        -draw "text 90,315 '${monDays[7]}'" \
        -draw "text 192,315 '${monDays[8]}'" \
        -draw "text 294,315 '${monDays[9]}'" \
        -draw "text 398,315 '${monDays[10]}'" \
        -draw "text 500,315 '${monDays[11]}'" \
        -draw "text 604,315 '${monDays[12]}'" \
        -draw "text 710,315 '${monDays[13]}'" \
        -draw "text 90,480 '${monDays[14]}'" \
        -draw "text 192,480 '${monDays[15]}'" \
        -draw "text 294,480 '${monDays[16]}'" \
        -draw "text 398,480 '${monDays[17]}'" \
        -draw "text 500,480 '${monDays[18]}'" \
        -draw "text 604,480 '${monDays[19]}'" \
        -draw "text 710,480 '${monDays[20]}'" \
        -draw "text 90,650'${monDays[21]}'" \
        -draw "text 192,650 '${monDays[22]}'" \
        -draw "text 294,650 '${monDays[23]}'" \
        -draw "text 398,650 '${monDays[24]}'" \
        -draw "text 500,650 '${monDays[25]}'" \
        -draw "text 604,650 '${monDays[26]}'" \
        -draw "text 710,650 '${monDays[27]}'" \
        -draw "text 90,815 '${monDays[28]}'" \
        -draw "text 192,815 '${monDays[29]}'" \
        -draw "text 294,815 '${monDays[30]}'" \
        -draw "text 398,815 '${monDays[31]}'" \
        -draw "text 500,815 '${monDays[32]}'" \
        -draw "text 604,815 '${monDays[33]}'" \
        -draw "text 710,815 '${monDays[34]}'" \
        -draw "text 90,980 '${monDays[35]}'" \
        -draw "text 192,980 '${monDays[36]}'" \
        -draw "text 290,980 '${monDays[37]}'" \
        -draw "text 398,980 '${monDays[38]}'" \
        -draw "text 500,980 '${monDays[39]}'" \
        -draw "text 604,980 '${monDays[40]}'" \
        -draw "text 710,980 '${monDays[41]}'" \
        $src_file \
        $dest_file
    done

    echo "-- ...done"
}

function build_weekly_calendar()
{
    local year=$1
    local page_nr=$2

    #local -n result=$2
    echo "-- start building weekly pages..."

    local date_fmt="+%a %d. %b"
    #local date_small_fmt="+%a %d"
    local date_small_fmt="+%d"
    local date_weeklead_fmt="+%V"
    local date_month_fmt="+%m"
    local week_num_of_Jan_1 week_day_of_Jan_1
    local week_num_of_Dec_31 week_day_of_Dec_31
    local start_Mon end_Mon
    local mon sun

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

    local file_cnt ord

    week_num_of_Jan_1=$(date -d $year-01-01 +%V)
    week_day_of_Jan_1=$(date -d $year-01-01 +%u)
    week_num_of_Dec_31=$(date -d $year-12-31 +%V)
    week_day_of_Dec_31=$(date -d $year-12-31 +%u)

    if [[ "$week_day_of_Jan_1" == "0" ]]; then
      week_day_of_Jan_1 = 7
    fi

    start_Mon=$(date -d "$year-01-01 - $((week_day_of_Jan_1 - 1 )) day" +%F)
    end_Mon=$(date -d "$year-12-31 + $((7 - week_day_of_Dec_31 + 1 )) day" +%F)
    echo "--- Start-Monday=$start_Mon"
    echo "--- Start-Week=$week_num_of_Jan_1"
    echo "--- End-Monday=$end_Mon"
    echo "--- End-Week=$week_num_of_Dec_31"
    isoweek=$week_num_of_Jan_1
    isoyear=$(date -d $start_Mon +%G)

    file_cnt=0

    while [[ "$start_Mon" != "$end_Mon" ]]; do
      mon=$(date -d "$start_Mon" "$date_fmt")
      sun=$(date -d "$start_Mon + 6 day" "$date_fmt")

      # week number with leading zero
      weeklead=$(date -d "$start_Mon" "$date_weeklead_fmt")
      # Month where week monday includes
      month=$(date -d "$start_Mon" "$date_month_fmt")

      date_mon=$(date -d "$start_Mon" "$date_small_fmt")
      date_tue=$(date -d "$start_Mon + 1 day" "$date_small_fmt")
      date_wed=$(date -d "$start_Mon + 2 day" "$date_small_fmt")
      date_thu=$(date -d "$start_Mon + 3 day" "$date_small_fmt")
      date_fri=$(date -d "$start_Mon + 4 day" "$date_small_fmt")
      date_sat=$(date -d "$start_Mon + 5 day" "$date_small_fmt")
      date_sun=$(date -d "$start_Mon + 6 day" "$date_small_fmt")

      result=$(echo "$mon - $sun;$isoyear;KW$isoweek;$date_mon;$date_tue;$date_wed;$date_thu;$date_fri;$date_sat;$date_sun;$weeklead;$month")
      start_Mon=$(date -d "$start_Mon + 7 day" +%F)
      isoweek=$(date -d $start_Mon +%V)
      isoyear=$(date -d $start_Mon +%G)

      file_cnt=$((file_cnt + 1 ))
      ord=$(printf "%02d" $file_cnt)
      local src_file=${RES_DIR}/$WEEK_CAL_TEMP.png
      local dest_file=${BUILD_DIR}/Planner-${page_nr}-${ord}-Weekly_${year}_${weeklead}_1.png
      local month_print=${BUILD_DIR}/month_print.tmp

      #printf "%s - %s %s KW %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $mon $sun $isoyear $isoweek $date_mon $date_tue $date_wed $date_thu $date_fri $date_sat $date_sun
      #echo "\"$mon\" - \"$sun\""
      #printf "### Start-Monday=%s\n" $start_Mon
      #printf "### End-Monday=%s\n" $end_Mon
      #printf "--- %s | %s\n" $result $dest_file
      #echo "--- $result | $dest_file"

      header=$(echo "$mon - $sun")
      kw=$(echo "KW $weeklead")

      echo "--- $ord | $result | $kw"

        # -font helvetica \

      convert  \
        -font /usr/share/fonts/opentype/comic-neue/ComicNeue-Regular.otf \
        -fill black \
        -pointsize 48 \
        -draw "text 890,186 '$header'" \
        -draw "text 50,186 '$year'" \
        -draw "text 190,186 '$kw'" \
        -font helvetica \
        -fill black \
        -pointsize 36 \
        -draw "text 40,312 '$date_mon'" \
        -draw "text 40,585 '$date_tue'" \
        -draw "text 40,858 '$date_wed'" \
        -draw "text 40,1131 '$date_thu'" \
        -draw "text 40,1404 '$date_fri'" \
        -draw "text 40,1677 '$date_sat'" \
        -draw "text 40,1950 '$date_sun'" \
        $src_file \
        $dest_file

      #printf "."
    done

    WEEK_COUNT=$file_cnt
    echo "--- Week Count: $WEEK_COUNT"

    echo "-- ...done"
}

function build_weekly_plan_matrix()
{
    local year=$1
    local page_nr=$2

    #local -n result=$2
    echo "-- start building weekly task matrix pages..."

    local date_fmt="+%a %d. %b"
    #local date_small_fmt="+%a %d"
    local date_small_fmt="+%d"
    local date_weeklead_fmt="+%V"
    local date_month_fmt="+%m"
    local week_num_of_Jan_1 week_day_of_Jan_1
    local week_num_of_Dec_31 week_day_of_Dec_31
    local start_Mon end_Mon
    local mon sun

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

    local file_cnt ord

    week_num_of_Jan_1=$(date -d $year-01-01 +%V)
    week_day_of_Jan_1=$(date -d $year-01-01 +%u)
    week_num_of_Dec_31=$(date -d $year-12-31 +%V)
    week_day_of_Dec_31=$(date -d $year-12-31 +%u)

    if [[ "$week_day_of_Jan_1" == "0" ]]; then
      week_day_of_Jan_1 = 7
    fi

    start_Mon=$(date -d "$year-01-01 - $((week_day_of_Jan_1 - 1 )) day" +%F)
    end_Mon=$(date -d "$year-12-31 + $((7 - week_day_of_Dec_31 + 1 )) day" +%F)
    echo "--- Start-Monday=$start_Mon"
    echo "--- Start-Week=$week_num_of_Jan_1"
    echo "--- End-Monday=$end_Mon"
    echo "--- End-Week=$week_num_of_Dec_31"
    isoweek=$week_num_of_Jan_1
    isoyear=$(date -d $start_Mon +%G)

    file_cnt=0

    while [[ "$start_Mon" != "$end_Mon" ]]; do
      mon=$(date -d "$start_Mon" "$date_fmt")
      sun=$(date -d "$start_Mon + 6 day" "$date_fmt")

      # week number with leading zero
      weeklead=$(date -d "$start_Mon" "$date_weeklead_fmt")
      # Month where week monday includes
      month=$(date -d "$start_Mon" "$date_month_fmt")

      date_mon=$(date -d "$start_Mon" "$date_small_fmt")
      date_tue=$(date -d "$start_Mon + 1 day" "$date_small_fmt")
      date_wed=$(date -d "$start_Mon + 2 day" "$date_small_fmt")
      date_thu=$(date -d "$start_Mon + 3 day" "$date_small_fmt")
      date_fri=$(date -d "$start_Mon + 4 day" "$date_small_fmt")
      date_sat=$(date -d "$start_Mon + 5 day" "$date_small_fmt")
      date_sun=$(date -d "$start_Mon + 6 day" "$date_small_fmt")

      result=$(echo "$mon - $sun;$isoyear;KW$isoweek;$date_mon;$date_tue;$date_wed;$date_thu;$date_fri;$date_sat;$date_sun;$weeklead;$month")
      start_Mon=$(date -d "$start_Mon + 7 day" +%F)
      isoweek=$(date -d $start_Mon +%V)
      isoyear=$(date -d $start_Mon +%G)

      file_cnt=$((file_cnt + 1 ))
      ord=$(printf "%02d" $file_cnt)
      local src_file=${RES_DIR}/$WEEK_PLAN_MATRIX_TEMP.png
      local dest_file=${BUILD_DIR}/Planner-${page_nr}-${ord}-Weekly_${year}_${weeklead}_3.png
      local month_print=${BUILD_DIR}/month_print.tmp

      #printf "%s - %s %s KW %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $mon $sun $isoyear $isoweek $date_mon $date_tue $date_wed $date_thu $date_fri $date_sat $date_sun
      #echo "\"$mon\" - \"$sun\""
      #printf "### Start-Monday=%s\n" $start_Mon
      #printf "### End-Monday=%s\n" $end_Mon
      #printf "--- %s | %s\n" $result $dest_file
      #echo "--- $result | $dest_file"

      header=$(echo "$mon - $sun")
      kw=$(echo "KW $weeklead")

      echo "--- $ord | $result | $kw"

        # -font helvetica \
        # -draw "text 890,186 '$header'" \
        # -draw "text 50,186 '$year'" \
        # -draw "text 190,186 '$kw'" \
        #
        # -draw "text 20,36 '$header'" \
        # -draw "text 390,36 '$kw'" \
        # -draw "text 760,36 '$year'" \

      convert  \
        -font /usr/share/fonts/opentype/comic-neue/ComicNeue-Regular.otf \
        -fill black \
        -pointsize 48 \
        -draw "text 890,186 '$header'" \
        -draw "text 50,186 '$year'" \
        -draw "text 190,186 '$kw'" \
        -font helvetica \
        $src_file \
        $dest_file

      #printf "."
    done

    WEEK_COUNT=$file_cnt
    echo "--- Week Count: $WEEK_COUNT"

    echo "-- ...done"
}

function build_weekly_note_page()
{
    local year=$1
    local page_nr=$2

    #local -n result=$2
    echo "-- start building weekly note pages..."

    local date_fmt="+%a %d. %b"
    #local date_small_fmt="+%a %d"
    local date_small_fmt="+%d"
    local date_weeklead_fmt="+%V"
    local date_month_fmt="+%m"
    local week_num_of_Jan_1 week_day_of_Jan_1
    local week_num_of_Dec_31 week_day_of_Dec_31
    local start_Mon end_Mon
    local mon sun

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

    local file_cnt ord

    week_num_of_Jan_1=$(date -d $year-01-01 +%V)
    week_day_of_Jan_1=$(date -d $year-01-01 +%u)
    week_num_of_Dec_31=$(date -d $year-12-31 +%V)
    week_day_of_Dec_31=$(date -d $year-12-31 +%u)

    if [[ "$week_day_of_Jan_1" == "0" ]]; then
      week_day_of_Jan_1 = 7
    fi

    start_Mon=$(date -d "$year-01-01 - $((week_day_of_Jan_1 - 1 )) day" +%F)
    end_Mon=$(date -d "$year-12-31 + $((7 - week_day_of_Dec_31 + 1 )) day" +%F)
    echo "--- Start-Monday=$start_Mon"
    echo "--- Start-Week=$week_num_of_Jan_1"
    echo "--- End-Monday=$end_Mon"
    echo "--- End-Week=$week_num_of_Dec_31"
    isoweek=$week_num_of_Jan_1
    isoyear=$(date -d $start_Mon +%G)

    file_cnt=0

    while [[ "$start_Mon" != "$end_Mon" ]]; do
      mon=$(date -d "$start_Mon" "$date_fmt")
      sun=$(date -d "$start_Mon + 6 day" "$date_fmt")

      # week number with leading zero
      weeklead=$(date -d "$start_Mon" "$date_weeklead_fmt")
      # Month where week monday includes
      month=$(date -d "$start_Mon" "$date_month_fmt")

      date_mon=$(date -d "$start_Mon" "$date_small_fmt")
      date_tue=$(date -d "$start_Mon + 1 day" "$date_small_fmt")
      date_wed=$(date -d "$start_Mon + 2 day" "$date_small_fmt")
      date_thu=$(date -d "$start_Mon + 3 day" "$date_small_fmt")
      date_fri=$(date -d "$start_Mon + 4 day" "$date_small_fmt")
      date_sat=$(date -d "$start_Mon + 5 day" "$date_small_fmt")
      date_sun=$(date -d "$start_Mon + 6 day" "$date_small_fmt")

      result=$(echo "$mon - $sun;$isoyear;KW$isoweek;$date_mon;$date_tue;$date_wed;$date_thu;$date_fri;$date_sat;$date_sun;$weeklead;$month")
      start_Mon=$(date -d "$start_Mon + 7 day" +%F)
      isoweek=$(date -d $start_Mon +%V)
      isoyear=$(date -d $start_Mon +%G)

      file_cnt=$((file_cnt + 1 ))
      ord=$(printf "%02d" $file_cnt)
      local src_file=${RES_DIR}/$WEEK_NOTE_PAGE_TEMP.png
      local dest_file=${BUILD_DIR}/Planner-${page_nr}-${ord}-Weekly_${year}_${weeklead}_2.png
      local month_print=${BUILD_DIR}/month_print.tmp

      #printf "%s - %s %s KW %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $mon $sun $isoyear $isoweek $date_mon $date_tue $date_wed $date_thu $date_fri $date_sat $date_sun
      #echo "\"$mon\" - \"$sun\""
      #printf "### Start-Monday=%s\n" $start_Mon
      #printf "### End-Monday=%s\n" $end_Mon
      #printf "--- %s | %s\n" $result $dest_file
      #echo "--- $result | $dest_file"

      header=$(echo "$mon - $sun")
      kw=$(echo "KW $weeklead")

      echo "--- $ord | $result | $kw"

        # -font helvetica \
        # -draw "text 550,100 '$header'" \
        # -draw "text 100,100 '$kw'" \
        # -draw "text 20,100 '$year'" \
        #
        # -draw "text 20,36 '$header'" \
        # -draw "text 390,36 '$kw'" \
        # -draw "text 760,36 '$year'" \
        #
        # -pointsize 44 \
        # -draw "text 890,190 '$header'" \
        # -draw "text 190,190 '$kw'" \
        # -draw "text 50,190 '$year'" \

      convert  \
        -font /usr/share/fonts/opentype/comic-neue/ComicNeue-Regular.otf \
        -fill black \
        -pointsize 48 \
        -draw "text 890,186 '$header'" \
        -draw "text 50,186 '$year'" \
        -draw "text 190,186 '$kw'" \
        -font helvetica \
        $src_file \
        $dest_file

      #printf "."
    done

    WEEK_COUNT=$file_cnt
    echo "--- Week Count: $WEEK_COUNT"

    echo "-- ...done"
}

function build_pdf()
{
  local year=$1

  echo "-- start building PDF..."
  #convert $BUILD_DIR/$PLAN_TEMP_PATTERN \
  #        -density 72 \
  #        -page a5 \
  #        $BUILD_DIR/tn-regular-planner-weekly-$year.pdf
  gm convert $BUILD_DIR/$PLAN_TEMP_PATTERN \
             -density 72 \
             -page a5 \
             $BUILD_DIR/planner-full-$year.pdf
  echo "-- ...done"
}

function build_pdf_book()
{
  local year=$1

  echo "-- start building PDF book..."
  pdfbook2 --paper=a2paper \
           --outer-margin=15 \
           --inner-margin=10 \
           -t 5 -b 5 \
           $BUILD_DIR/tn-passport-planner-monthly-$year.pdf
  echo "-- ...done"
}

function clean_build()
{
  echo "-- start cleaning build dir..."
  rm $BUILD_DIR/*.png
  rm $BUILD_DIR/*.pdf
  echo "-- ...done"
}

function publish_pdf_book()
{
  local year=$1

  echo "-- publish PDF book..."
  cp -v $BUILD_DIR/*$year.pdf $ARTIFACTS_DIR/
  echo "-- ...done"
}


echo "- start building calender planner of $1"

mkdir -vp $ARTIFACTS_DIR
mkdir -vp $BUILD_DIR

## build for Year
build_yearly_month $1 2
build_quartarly_plan_goal $1 3
build_monthly_calendar $1 4
build_weekly_calendar $1 6
build_weekly_plan_matrix $1 6
build_weekly_note_page $1 6
build_pdf $1
publish_pdf_book $1
#clean_build

echo "- ...finished"
