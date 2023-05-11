#!/bin/bash

#
# Build a A4 Planner with yearly, quartarly, weekly and daily pages of w year
# call: build_a4_cal_planner.sh Year
#
# Requisites: ncal, tex {for: pdf, booklet}, imagemagik {for: convert}
#

set -eu
set -o pipefail

ARGS=("$@")

YEAR_CAL_TEMP=TNRegular-Planner-Yearly
YEARLY_FIRST_CAL_TEMP=TNRegular-Planner-Yearly-1st
YEARLY_SECOND_CAL_TEMP=TNRegular-Planner-Yearly-2nd
EMPTY_CAL_TEMP=TNRegular-Planner-Empty
QUAT_PLAN_VISION_TEMP=TNRegular-Planner-Quatarly-Vision
QUAT_PLAN_GOALS_TEMP=TNRegular-Planner-Quatarly-Goals
WEEK_PLAN_DAYS_TEMP=TNRegular-Planner-Weekly-Days
WEEK_PLAN_NOTES_TEMP=TNRegular-Planner-Weekly-Notes
DAY_PLAN_TEMP=Planner-Daily-TNRegular
PLAN_TEMP_PATTERN=Planner-*.png
RES_DIR=../res
BUILD_DIR=../../build/build_tnreg_planner


function build_empty_page()
{
    local year=$1
    local page_nr=$2

    echo "-- start building empty page..."

    local header=$(echo "Year $1")
    local src_file=${RES_DIR}/$EMPTY_CAL_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Empty_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 20,36 '$header'" \
      $src_file \
      $dest_file

      #gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      #convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf

    echo "-- ...done"
}

function build_yearly_calendar()
{
    local year=$1
    local page_nr=$2

    echo "-- start building yearly page..."

    local header=$(echo "Year $1")
    local src_file=${RES_DIR}/$YEAR_CAL_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Yearly_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 20,36 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      -draw "text 40, 70  '$(gcal -K --iso-week-number=yes -H no -s 1 1 ${year})'" \
      -draw "text 40, 200  '$(gcal -K --iso-week-number=yes -H no -s 1 3 ${year})'" \
      -draw "text 40, 330  '$(gcal -K --iso-week-number=yes -H no -s 1 5 ${year})'" \
      -draw "text 40, 460  '$(gcal -K --iso-week-number=yes -H no -s 1 7 ${year})'" \
      -draw "text 40, 590  '$(gcal -K --iso-week-number=yes -H no -s 1 9 ${year})'" \
      -draw "text 40, 720  '$(gcal -K --iso-week-number=yes -H no -s 1 11 ${year})'" \
      -draw "text 260, 70 '$(gcal -K --iso-week-number=yes -H no -s 1 2 ${year})'" \
      -draw "text 260, 200 '$(gcal -K --iso-week-number=yes -H no -s 1 4 ${year})'" \
      -draw "text 260, 330 '$(gcal -K --iso-week-number=yes -H no -s 1 6 ${year})'" \
      -draw "text 260, 460 '$(gcal -K --iso-week-number=yes -H no -s 1 8 ${year})'" \
      -draw "text 260, 590 '$(gcal -K --iso-week-number=yes -H no -s 1 10 ${year})'" \
      -draw "text 260, 720 '$(gcal -K --iso-week-number=yes -H no -s 1 12 ${year})'" \
      $src_file \
      $dest_file

      #gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      #convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf

    echo "-- ...done"
}

function build_yearly()
{
    local year=$1
    local page_nr=$2

    echo "-- start building yearly planning page..."

    local header=$(echo "Year $1")
    local src_file=${RES_DIR}/$YEAR_PLAN_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Yearly_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 20,36 '$header'" \
      $src_file \
      $dest_file

      #gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      #convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf

    echo "-- ...done"
}

function build_yearly_half()
{
    local year=$1
    local page_nr=$2

    echo "-- start building empty page..."

    local header=$(echo "Year $1")
    local src_file_left=${RES_DIR}/$YEARLY_FIRST_CAL_TEMP.png
    local dest_file_left=${BUILD_DIR}/Planner-${page_nr}-Yearly-Half_${year}-1.png
    local src_file_right=${RES_DIR}/$YEARLY_SECOND_CAL_TEMP.png
    local dest_file_right=${BUILD_DIR}/Planner-${page_nr}-Yearly-Half_${year}-2.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 20,36 '$header'" \
      $src_file_left \
      $dest_file_left

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 20,36 '$header'" \
      $src_file_right \
      $dest_file_right

    echo "-- ...done"
}

function build_quartarly()
{
    local year=$1
    local page_nr=$2

    echo "-- start building quatarly year pages..."

    for i in $(seq 1 4)
    do
      local header=$(echo "Year $year / Q$i")
      local src_file_left=${RES_DIR}/$QUAT_PLAN_VISION_TEMP.png
      local dest_file_left=${BUILD_DIR}/Planner-${page_nr}-Quartarly_${year}.${i}-1.png
      local src_file_right=${RES_DIR}/$QUAT_PLAN_GOALS_TEMP.png
      local dest_file_right=${BUILD_DIR}/Planner-${page_nr}-Quartarly_${year}.${i}-2.png

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

      echo "--- ...Q${i} | ${m1} | ${m2} | ${m3} | ${dest_file_left}"

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 20,36 '$header'" \
        -pointsize 16 \
        $src_file_left \
        $dest_file_left

      echo "--- ...Q${i} | ${m1} | ${m2} | ${m3} | ${dest_file_right}"

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 20,36 '$header'" \
        -pointsize 14 \
        -draw "text 133,65 '$m1'" \
        -draw "text 246,65 '$m2'" \
        -draw "text 360,65 '$m3'" \
        $src_file_right \
        $dest_file_right

    done

    echo "-- ...done"
}

function build_weekly()
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
    week=$week_num_of_Jan_1

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

      result=$(echo "$mon - $sun;KW $week;$date_mon;$date_tue;$date_wed;$date_thu;$date_fri;$date_sat;$date_sun;$weeklead;$month")
      start_Mon=$(date -d "$start_Mon + 7 day" +%F)
      week=$(date -d $start_Mon +%V)

      file_cnt=$((file_cnt + 1 ))
      ord=$(printf "%02d" $file_cnt)
      local src_file_left=${RES_DIR}/$WEEK_PLAN_DAYS_TEMP.png
      local dest_file_left=${BUILD_DIR}/Planner-${page_nr}-${ord}-Weekly_${year}_${weeklead}_1.png
      local src_file_right=${RES_DIR}/$WEEK_PLAN_NOTES_TEMP.png
      local dest_file_right=${BUILD_DIR}/Planner-${page_nr}-${ord}-Weekly_${year}_${weeklead}_2.png
      local month_print=${BUILD_DIR}/month_print.tmp

      #printf "%s - %s %s KW %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $mon $sun $year $week $date_mon $date_tue $date_wed $date_thu $date_fri $date_sat $date_sun
      #echo "\"$mon\" - \"$sun\""
      #printf "### Start-Monday=%s\n" $start_Mon
      #printf "### End-Monday=%s\n" $end_Mon
      #printf "--- %s | %s\n" $result $dest_file
      #echo "--- $result | $dest_file_left"

      header=$(echo "$mon - $sun")
      kw=$(echo "KW $weeklead")

      echo "--- $result | $kw"

      #  -draw "text 710,50 '$year'" \
      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 20,36 '$header'" \
        -draw "text 360,36 '$kw'" \
        -font helvetica \
        -fill black \
        -pointsize 20 \
        -draw "text 80,234 '$date_mon'" \
        -draw "text 80,326 '$date_tue'" \
        -draw "text 80,417 '$date_wed'" \
        -draw "text 80,511 '$date_thu'" \
        -draw "text 80,602 '$date_fri'" \
        -draw "text 80,693 '$date_sat'" \
        -draw "text 80,785 '$date_sun'" \
        $src_file_left \
        $dest_file_left

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 20,36 '$year'" \
        -draw "text 360,36 '$kw'" \
        -font FreeMono \
        -fill black \
        -pointsize 14  \
        -draw "text 245, 75 '$(gcal -K --iso-week-number=yes -H no -s 1 ${month} ${year} |tail -n +2)'" \
        $src_file_right \
        $dest_file_right

      #printf "."
    done

    echo "-- ...done"
}

function build_daily()
{
    local year=$1
    local month_start=$2
    local month_end=$3
    local page_nr=$4

    echo "-- start building daily pages..."

    local date_fmt="+%a %d. %B %Y"
    #local date_small_fmt="+%a %d"

    for month in $(seq $month_start $month_end)
    do
      local start_day=1
      local end_day=$(date -d "$year-$month-01 +1 month -1 day" +%d)
      local month_name=$(date -d "$year-$month-01" +%B)

      echo -n "--- $month_name "

      for i in $(seq 1 $end_day)
      do
        local day=$(date -d "$year-$month-$i" "$date_fmt")
        local daynum=$(date -d "$year-$month-$i" "+%d")
        local src_file=${RES_DIR}/$DAY_PLAN_TEMP.png
        local dest_file=${BUILD_DIR}/Planner-${page_nr}-Daily_${year}${month}${daynum}.png
        local month_print=${BUILD_DIR}/month_print.tmp

        echo -n "[$i]"
        header=$(echo "$day")

        #  -draw "text 710,50 '$year'" \
        #  -draw "text 420, 120 '$(ncal -bhwM -d ${year}-${month} |tail -n +2)'" \
        convert  \
          -font helvetica \
          -fill black \
          -pointsize 22 \
          -draw "text 20,36 '$header'" \
          -font FreeMono \
          -fill black \
          -pointsize 24  \
          -draw "text 410, 110 '$(gcal -K -H no -s 1 ${month} ${year} |tail -n +3)'" \
          $src_file \
          $dest_file

      done

      echo "[ok]"
    done
    echo "[ok]"

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
             $BUILD_DIR/planner-$year.pdf
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
           $BUILD_DIR/tn-regular-planner-weekly-$year.pdf
  echo "-- ...done"
}

function clean_build()
{
  echo "-- start cleaning build dir..."
  rm $BUILD_DIR/*.png
  echo "-- ...done"
}

echo "- start building calender planner of $1"
## build for Year
build_yearly_calendar $1 1
build_yearly_half $1 2
build_quartarly $1 3
build_weekly $1 4
build_empty_page $1 5
build_empty_page $1 6
build_empty_page $1 7
build_empty_page $1 8
#build_yearly $1 3
#build_empty_page $1 4
#build_daily $1 3 12 4
build_pdf $1
build_pdf_book $1
clean_build

echo "- ...finished"