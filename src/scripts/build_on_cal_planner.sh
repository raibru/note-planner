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

YEAR_CAL_TEMP=Planner-Yearly-Onenote
QUAT_PLAN_TEMP=Planner-Quartarly-Onenote
WEEK_PLAN_TEMP=Planner-Weekly-Onenote
DAY_PLAN_TEMP=Planner-Daily-Onenote
PLAN_TEMP_PATTERN=Planner-*.png
RES_DIR=../res
BUILD_DIR=../../build_on_planner


function build_empty_page()
{
    local year=$1
    local page_nr=$2

    echo "-- start building empty page..."

    local header=$(echo "Year $1")
    local src_file=${RES_DIR}/$YEAR_CAL_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Yearly_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 20 \
      -draw "text 30,45 '$header'" \
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
      -pointsize 20 \
      -draw "text 40,45 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 20  \
      -draw "text 80, 110 '$(ncal -bhwM -d ${year}-1)'" \
      -draw "text 80, 280 '$(ncal -bhwM -d ${year}-3)'" \
      -draw "text 80, 450 '$(ncal -bhwM -d ${year}-5)'" \
      -draw "text 80, 620 '$(ncal -bhwM -d ${year}-7)'" \
      -draw "text 80, 790 '$(ncal -bhwM -d ${year}-9)'" \
      -draw "text 80, 960 '$(ncal -bhwM -d ${year}-11)'" \
      -draw "text 420, 110 '$(ncal -bhwM -d ${year}-2)'" \
      -draw "text 420, 280 '$(ncal -bhwM -d ${year}-4)'" \
      -draw "text 420, 450 '$(ncal -bhwM -d ${year}-6)'" \
      -draw "text 420, 620 '$(ncal -bhwM -d ${year}-8)'" \
      -draw "text 420, 790 '$(ncal -bhwM -d ${year}-10)'" \
      -draw "text 420, 960 '$(ncal -bhwM -d ${year}-12)'" \
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
      -pointsize 20 \
      -draw "text 40,45 '$header'" \
      $src_file \
      $dest_file

      #gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      #convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf

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
      local src_file=${RES_DIR}/$QUAT_PLAN_TEMP.png
      local dest_file=${BUILD_DIR}/Planner-${page_nr}-Quartarly_${year}.${i}.png

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

      echo "--- ...Q${i} | ${m1} | ${m2} | ${m3} | ${dest_file}"

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 24 \
        -draw "text 20,40 '$header'" \
        -pointsize 16 \
        -draw "text 1030,83 '$m1'" \
        -draw "text 1215,83 '$m2'" \
        -draw "text 1400,83 '$m3'" \
        $src_file \
        $dest_file

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
      local src_file=${RES_DIR}/$WEEK_PLAN_TEMP.png
      local dest_file=${BUILD_DIR}/Planner-${page_nr}-${ord}-Weekly_${year}_${weeklead}.png
      local month_print=${BUILD_DIR}/month_print.tmp

      #printf "%s - %s %s KW %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $mon $sun $year $week $date_mon $date_tue $date_wed $date_thu $date_fri $date_sat $date_sun
      #echo "\"$mon\" - \"$sun\""
      #printf "### Start-Monday=%s\n" $start_Mon
      #printf "### End-Monday=%s\n" $end_Mon
      #printf "--- %s | %s\n" $result $dest_file
      echo "--- $result | $dest_file"

      header=$(echo "$mon - $sun")
      kw=$(echo "KW $weeklead")

      #  -draw "text 710,50 '$year'" \
      convert  \
        -font helvetica \
        -fill black \
        -pointsize 24 \
        -draw "text 20,40 '$header'" \
        -draw "text 380,40 '$kw'" \
        -font FreeMono \
        -fill black \
        -pointsize 24  \
        -draw "text 380, 100 '$(gcal -K -H no -s 1 ${month} ${year} |tail -n +3)'" \
        -font helvetica \
        -fill black \
        -pointsize 20 \
        -draw "text 900,300 '$date_mon'" \
        -draw "text 900,420 '$date_tue'" \
        -draw "text 900,540 '$date_wed'" \
        -draw "text 900,660 '$date_thu'" \
        -draw "text 900,778 '$date_fri'" \
        -draw "text 900,897 '$date_sat'" \
        -draw "text 900,1018 '$date_sun'" \
        $src_file \
        $dest_file

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
          -pointsize 24 \
          -draw "text 20,50 '$header'" \
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
build_quartarly $1 2
#build_empty_page $1 2
#build_yearly $1 3
#build_empty_page $1 4
build_weekly $1 3
build_daily $1 3 12 4
build_pdf $1
#build_pdf_book $1
#clean_build

echo "- ...finished"