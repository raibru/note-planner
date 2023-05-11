#!/bin/bash

#
# Build a booklet weekly calendar with yearly overview in
# travelerr's notebook regular format 21x15 cm. The print
# out is in A5 and has to be cutted 
# call: build_tn_regular_cal_weekly.sh Year
#
# Requisites: ncal, tex {for: pdf, booklet}, imagemagik {for: convert}
#

YEAR_CAL_TEMP=Planner-Yearly-TNRegular
YEAR_PLAN_TEMP=Planner-YearlyHoriL-regular
WEEK_PLAN_TEMP=Planner-Weekly-regular
PLAN_TEMP_PATTERN=Planner-*.png
RES_DIR=../res
BUILD_DIR=../../build

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
      -draw "text 30,45 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      -draw "text 40, 90 '$(ncal -bhwM -d ${year}-1)'" \
      -draw "text 40, 210 '$(ncal -bhwM -d ${year}-3)'" \
      -draw "text 40, 330 '$(ncal -bhwM -d ${year}-5)'" \
      -draw "text 40, 450 '$(ncal -bhwM -d ${year}-7)'" \
      -draw "text 40, 570 '$(ncal -bhwM -d ${year}-9)'" \
      -draw "text 40, 690 '$(ncal -bhwM -d ${year}-11)'" \
      -draw "text 250, 90 '$(ncal -bhwM -d ${year}-2)'" \
      -draw "text 250, 210 '$(ncal -bhwM -d ${year}-4)'" \
      -draw "text 250, 330 '$(ncal -bhwM -d ${year}-6)'" \
      -draw "text 250, 450 '$(ncal -bhwM -d ${year}-8)'" \
      -draw "text 250, 570 '$(ncal -bhwM -d ${year}-10)'" \
      -draw "text 250, 690 '$(ncal -bhwM -d ${year}-12)'" \
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
      -draw "text 30,45 '$header'" \
      $src_file \
      $dest_file

      #gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      #convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf

    echo "-- ...done"
}

function build_weekly()
{
    local year=$1
    #local -n result=$2
    echo "-- start building weekly pages..."

    local date_fmt="+%a %d. %b"
    local date_small_fmt="+%a %d"
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
      #printf "%s - %s %s KW %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" $mon $sun $year $week $date_mon $date_tue $date_wed $date_thu $date_fri $date_sat $date_sun
      #echo "\"$mon\" - \"$sun\""
      echo "--- $result"
      #printf "### Start-Monday=%s\n" $start_Mon
      #printf "### End-Monday=%s\n" $end_Mon

      file_cnt=$((file_cnt + 1 ))
      ord=$(printf "%02d" $file_cnt)
      local src_file=${RES_DIR}/$WEEK_PLAN_TEMP.png
      local dest_file=${BUILD_DIR}/${WEEK_PLAN_TEMP}_${ord}_${year}_$weeklead.png
      local month_print=${BUILD_DIR}/month_print.tmp

      header=$(echo "$mon - $sun")
      kw=$(echo "KW $weeklead")

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 20 \
        -draw "text 30,40 '$header'" \
        -draw "text 380,40 '$kw'" \
        -pointsize 17 \
        -draw "text 30,233 '$date_mon'" \
        -draw "text 30,323 '$date_tue'" \
        -draw "text 30,413 '$date_wed'" \
        -draw "text 30,503 '$date_thu'" \
        -draw "text 30,593 '$date_fri'" \
        -draw "text 30,683 '$date_sat'" \
        -draw "text 30,773 '$date_sun'" \
        -pointsize 12 \
        -draw "text 220,860 '$year'" \
        $src_file \
        $dest_file

      #printf "."
    done

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
             $BUILD_DIR/tn-regular-planner-weekly-$year.pdf
  echo "-- ...done"
}

function build_pdf_book()
{
  local year=$1

  echo "-- start building PDF book..."
  pdfbook2 --paper=a4paper \
           --outer-margin=22 \
           --inner-margin=17 \
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

echo "- start building calender booklet of $1"
## build for Year
build_yearly_calendar $1 1
build_empty_page $1 2
build_yearly $1 3
build_empty_page $1 4
build_weekly $1
build_pdf $1
build_pdf_book $1
clean_build

echo "- ...finished"