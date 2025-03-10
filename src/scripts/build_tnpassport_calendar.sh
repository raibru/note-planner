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

YEAR_CAL_TEMP=TNPassport-Planner-Yearly
YEAR_FIRST_CAL_TEMP=TNPassport-Planner-Yearly
YEAR_SECOND_CAL_TEMP=TNPassport-Planner-Yearly
QUAT_PLAN_VISION_TEMP=TNRegular-Planner-Quatarly-Vision
QUAT_PLAN_GOALS_TEMP=TNRegular-Planner-Quatarly-Goals
MONTH_CAL_TEMP=TNPassport-Planner-Monthly
MONTH_FIRST_CAL_TEMP=TNPassport-Planner-Monthly-6-1
MONTH_SECOND_CAL_TEMP=TNPassport-Planner-Monthly-6-2
EMPTY_CAL_TEMP=TNPassport-Planner-Empty
PLAN_TEMP_PATTERN=Planner-*.png
RES_DIR=../res
BUILD_DIR=../../build/build_tnpassport_calendar

WEEK_COUNT=52 # ueberschrieben in build weekly

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
      -draw "text 20,28 '$header'" \
      $src_file \
      $dest_file

      #gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      #convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf

    echo "-- ...done"
}

function build_yearly_first_calendar()
{
    local year=$1
    local page_nr=$2

    echo "-- start building yearly first page..."

    local header=$(echo "Year $1")
    local src_file=${RES_DIR}/$YEAR_FIRST_CAL_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Yearly_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 20,28 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      -draw "text 10, 70  '$(gcal -K --iso-week-number=yes -H no -s 1 1 ${year})'" \
      -draw "text 10, 200  '$(gcal -K --iso-week-number=yes -H no -s 1 2 ${year})'" \
      -draw "text 10, 330  '$(gcal -K --iso-week-number=yes -H no -s 1 3 ${year})'" \
      -draw "text 200, 70  '$(gcal -K --iso-week-number=yes -H no -s 1 4 ${year})'" \
      -draw "text 200, 200  '$(gcal -K --iso-week-number=yes -H no -s 1 5 ${year})'" \
      -draw "text 200, 330  '$(gcal -K --iso-week-number=yes -H no -s 1 6 ${year})'" \
      $src_file \
      $dest_file

      #gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      #convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf

    echo "-- ...done"
}

function build_yearly_second_calendar()
{
    local year=$1
    local page_nr=$2

    echo "-- start building yearly second page..."

    local header=$(echo "Year $1")
    local src_file=${RES_DIR}/$YEAR_SECOND_CAL_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Yearly_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 270,28 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      -draw "text 10, 70 '$(gcal -K --iso-week-number=yes -H no -s 1 7 ${year})'" \
      -draw "text 10, 200 '$(gcal -K --iso-week-number=yes -H no -s 1 8 ${year})'" \
      -draw "text 10, 330 '$(gcal -K --iso-week-number=yes -H no -s 1 9 ${year})'" \
      -draw "text 200, 70 '$(gcal -K --iso-week-number=yes -H no -s 1 10 ${year})'" \
      -draw "text 200, 200 '$(gcal -K --iso-week-number=yes -H no -s 1 11 ${year})'" \
      -draw "text 200, 330 '$(gcal -K --iso-week-number=yes -H no -s 1 12 ${year})'" \
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

      echo "--- ...Q${i} | ${m1} | ${m2} | ${m3} | ${QUAT_PLAN_VISION_TEMP}"

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 20,36 '$header'" \
        -pointsize 16 \
        $src_file_left \
        $dest_file_left

      echo "--- ...Q${i} | ${m1} | ${m2} | ${m3} | ${QUAT_PLAN_GOALS_TEMP}"

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

function build_monthly_calendar()
{
    local year=$1
    local page_nr=$2


    echo "-- start building monthly calendar page..."

    local src_file_1st=${RES_DIR}/$MONTH_FIRST_CAL_TEMP.png
    local src_file_2nd=${RES_DIR}/$MONTH_SECOND_CAL_TEMP.png

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

      local dest_file_1st=${BUILD_DIR}/Planner-${page_nr}-${monNum}-Monthly_1st_${year}.png
      local dest_file_2nd=${BUILD_DIR}/Planner-${page_nr}-${monNum}-Monthly_2nd_${year}.png

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 20,28 '$monName'" \
        -font helvetica \
        -fill black \
        -pointsize 12 \
        -draw "text 21,75 '${monWeekNums[0]}'" \
        -draw "text 21,149 '${monWeekNums[1]}'" \
        -draw "text 21,223 '${monWeekNums[2]}'" \
        -draw "text 21,297 '${monWeekNums[3]}'" \
        -draw "text 21,371 '${monWeekNums[4]}'" \
        -draw "text 21,445 '${monWeekNums[5]}'" \
        -font helvetica \
        -fill black \
        -pointsize 16 \
        -draw "text 47,75 '${monDays[0]}'" \
        -draw "text 114,75 '${monDays[1]}'" \
        -draw "text 182,75 '${monDays[2]}'" \
        -draw "text 248,75 '${monDays[3]}'" \
        -draw "text 317,75 '${monDays[4]}'" \
        -draw "text 47,149 '${monDays[7]}'" \
        -draw "text 114,149 '${monDays[8]}'" \
        -draw "text 182,149 '${monDays[9]}'" \
        -draw "text 248,149 '${monDays[10]}'" \
        -draw "text 317,149 '${monDays[11]}'" \
        -draw "text 47,223 '${monDays[14]}'" \
        -draw "text 114,223 '${monDays[15]}'" \
        -draw "text 182,223 '${monDays[16]}'" \
        -draw "text 248,223 '${monDays[17]}'" \
        -draw "text 317,223 '${monDays[18]}'" \
        -draw "text 47,297'${monDays[21]}'" \
        -draw "text 114,297 '${monDays[22]}'" \
        -draw "text 182,297 '${monDays[23]}'" \
        -draw "text 248,297 '${monDays[24]}'" \
        -draw "text 317,297 '${monDays[25]}'" \
        -draw "text 47,371 '${monDays[28]}'" \
        -draw "text 114,371 '${monDays[29]}'" \
        -draw "text 182,371 '${monDays[30]}'" \
        -draw "text 248,371 '${monDays[31]}'" \
        -draw "text 317,371 '${monDays[32]}'" \
        -draw "text 47,445 '${monDays[35]}'" \
        -draw "text 114,445 '${monDays[36]}'" \
        -draw "text 182,445 '${monDays[37]}'" \
        -draw "text 248,445 '${monDays[38]}'" \
        -draw "text 317,445 '${monDays[39]}'" \
        $src_file_1st \
        $dest_file_1st

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 20,28 '$monName'" \
        -draw "text 330,28 '$year'" \
        -font helvetica \
        -fill black \
        -pointsize 16 \
        -draw "text 21,75 '${monDays[5]}'" \
        -draw "text 88,75 '${monDays[6]}'" \
        -draw "text 21,149 '${monDays[12]}'" \
        -draw "text 88,149 '${monDays[13]}'" \
        -draw "text 21,223 '${monDays[19]}'" \
        -draw "text 88,223 '${monDays[20]}'" \
        -draw "text 21,297 '${monDays[26]}'" \
        -draw "text 88,297 '${monDays[27]}'" \
        -draw "text 21,371 '${monDays[33]}'" \
        -draw "text 88,371 '${monDays[34]}'" \
        -draw "text 21,445 '${monDays[40]}'" \
        -draw "text 88,445 '${monDays[41]}'" \
        $src_file_2nd \
        $dest_file_2nd

   
    done

    echo "-- ...done"
}

#function build_planning_pdf()
#{
#  local year=$1
#  local usefiles=""
#  usefiles="$usefiles $(ls $BUILD_DIR/Planner-1-Yearly_*.png)"
#  usefiles="$usefiles $(ls $BUILD_DIR/Planner-3-Quartarly_*.png)"
#  usefiles="$usefiles $(ls $BUILD_DIR/Planner-*-Empty_*.png)"
#
#  echo "-- start building planning PDF..."
#  gm convert $usefiles \
#             -density 72 \
#             -page a5 \
#             $BUILD_DIR/planner-planning-$year.pdf
#  echo "-- ...done"
#}

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
  echo "-- ...done"
}

echo "- start building calender planner of $1"
## build for Year
build_empty_page $1 1
build_yearly_first_calendar $1 2
build_yearly_second_calendar $1 3
#build_quartarly $1 4
build_monthly_calendar $1 4
build_empty_page $1 5
build_empty_page $1 6
build_empty_page $1 7
build_empty_page $1 8
build_empty_page $1 9
build_pdf $1
build_pdf_book $1
#build_planning_pdf $1
#build_weekly_parts_pdf $1 2
clean_build

echo "- ...finished"