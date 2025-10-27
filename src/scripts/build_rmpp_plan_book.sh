#!/bin/bash

#
# Build a reMarkable Paper Pro  Planner with yearly, quartarly, weekly planning
# matrix 
# call: build_rmpp_plan_book.sh Year
#
# Requisites: ncal, tex {for: pdf, booklet}, imagemagik {for: convert}
#

set -eu
set -o pipefail

ARGS=("$@")

YEAR_MONTH_TEMP=RMPP-Planner-Empty
YEAR_OVERVIEW_TEMP=RMPP-Planner-Yearly
QUAT_PLAN_GOALS_TEMP=RMPP-Planner-Quartarly
WEEK_PLAN_MATRIX_TEMP=RMPP-Planner-Task-Matrix
PLAN_TEMP_PATTERN=Planner-*.png
RES_DIR=../res
BUILD_DIR=../../build/build_rmpp_planner
ARTIFACTS_DIR=../../artifacts/RMPP-Planner

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
      -font /usr/share/fonts/truetype/msttcorefonts/comic.ttf \
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
        -font /usr/share/fonts/truetype/msttcorefonts/comic.ttf \
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

function build_weekly_plan_matrix()
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
      local src_file=${RES_DIR}/$WEEK_PLAN_MATRIX_TEMP.png
      local dest_file=${BUILD_DIR}/Planner-${page_nr}-${ord}-Weekly_matrix_${year}_${weeklead}_1.png
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
        -font /usr/share/fonts/truetype/msttcorefonts/comic.ttf \
        -fill black \
        -pointsize 22 \
        -draw "text 20,36 '$header'" \
        -draw "text 390,36 '$kw'" \
        -draw "text 760,36 '$year'" \
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
build_quartarly_plan_goal $1 4
build_weekly_plan_matrix $1 6
build_pdf $1
publish_pdf_book $1
#clean_build

echo "- ...finished"
