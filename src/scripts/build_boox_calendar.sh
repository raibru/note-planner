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

YEAR_MONTH_TEMP=Boox-Planner-Empty
YEAR_OVERVIEW_TEMP=Boox-Planner-Yearly
QUAT_PLAN_GOALS_TEMP=Boox-Planner-Quartarly
MONTH_CAL_TEMP=Boox-Planner-Monthly-6
WEEK_OVERVIEW_HORIZ=Boox-Planner-Weekly-Lane-Horiz
WEEK_OVERVIEW_VERT=Boox-Planner-Weekly-Lane-Vert
WEEK_OVERVIEW_BLOCK=Boox-Planner-Weekly-Block
PLAN_TEMP_PATTERN=Planner-*.png
RES_DIR=../res
BUILD_DIR=../../build/build_boox_calendar
ARTIFACTS_DIR=../../artifacts/Boox-Planner

WEEK_COUNT=52 # ueberschrieben in build weekly

function build_yearly_month()
{
    local year=$1
    local page_nr=$2

    echo "-- start building yearly planning page..."

    local header=$(echo "$1")
    local src_file=${RES_DIR}/$YEAR_MONTH_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Yearly_Month_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 26 \
      -draw "text 30,45 '$header'" \
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

function build_yearly_overview()
{
    local year=$1
    local page_nr=$2

    echo "-- start building yearly overview page..."

    local header=$(echo "$1")
    local src_file=${RES_DIR}/$YEAR_OVERVIEW_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Yearly_Overview_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 30,45 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      $src_file \
      $dest_file

      #gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      #convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf

    echo "-- ...done"
}

function build_quartarly_plan_goal()
{
    local year=$1
    local page_nr=$2

    echo "-- start building quatarly year pages..."

    for i in $(seq 1 4)
    do
      local header=$(echo "Year $year / Q$i")
      # local src_file_left=${RES_DIR}/$QUAT_PLAN_VISION_TEMP.png
      # local dest_file_left=${BUILD_DIR}/Planner-${page_nr}-Quartarly_${year}.${i}-1.png
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

      # echo "--- ...Q${i} | ${m1} | ${m2} | ${m3} | ${QUAT_PLAN_VISION_TEMP}"

      # convert  \
      #   -font helvetica \
      #   -fill black \
      #   -pointsize 22 \
      #   -draw "text 20,36 '$header'" \
      #   -pointsize 16 \
      #   $src_file_left \
      #   $dest_file_left

      echo "--- ...Q${i} | ${m1} | ${m2} | ${m3} | ${QUAT_PLAN_GOALS_TEMP}"

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 30,45 '$header'" \
        -pointsize 14 \
        -draw "text 300,100 '$m1'" \
        -draw "text 490,100 '$m2'" \
        -draw "text 690,100 '$m3'" \
        $src_file_right \
        $dest_file_right

    done

    echo "-- ...done"
}

function build_monthly()
{
    local year=$1
    local page_nr=$2


    echo "-- start building monthly calendar page..."

    local src_file=${RES_DIR}/$MONTH_CAL_TEMP.png

    for mon in $(seq 1 12)
    do

      # local monDays=("--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--" "--")
      # local monWeekNums=("--" "--" "--" "--" "--" "--")
      local monDays=("  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  " "  ")
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
      local header=$(echo "$monName / $year")

      convert  \
        -font helvetica \
        -fill black \
        -pointsize 22 \
        -draw "text 30,45 '$header'" \
        -font helvetica \
        -fill black \
        -pointsize 16 \
        -draw "text 50,150 '${monWeekNums[0]}'" \
        -draw "text 50,320 '${monWeekNums[1]}'" \
        -draw "text 50,485 '${monWeekNums[2]}'" \
        -draw "text 50,655 '${monWeekNums[3]}'" \
        -draw "text 50,820 '${monWeekNums[4]}'" \
        -draw "text 50,985 '${monWeekNums[5]}'" \
        -font helvetica \
        -fill black \
        -pointsize 20 \
        -draw "text 95,150 '${monDays[0]}'" \
        -draw "text 197,150 '${monDays[1]}'" \
        -draw "text 299,150 '${monDays[2]}'" \
        -draw "text 402,150 '${monDays[3]}'" \
        -draw "text 504,150 '${monDays[4]}'" \
        -draw "text 607,150 '${monDays[5]}'" \
        -draw "text 709,150 '${monDays[6]}'" \
        -draw "text 95,320 '${monDays[7]}'" \
        -draw "text 197,320 '${monDays[8]}'" \
        -draw "text 299,320 '${monDays[9]}'" \
        -draw "text 402,320 '${monDays[10]}'" \
        -draw "text 504,320 '${monDays[11]}'" \
        -draw "text 607,320 '${monDays[12]}'" \
        -draw "text 709,320 '${monDays[13]}'" \
        -draw "text 95,485 '${monDays[14]}'" \
        -draw "text 197,485 '${monDays[15]}'" \
        -draw "text 299,485 '${monDays[16]}'" \
        -draw "text 402,485 '${monDays[17]}'" \
        -draw "text 504,485 '${monDays[18]}'" \
        -draw "text 607,485 '${monDays[19]}'" \
        -draw "text 709,485 '${monDays[20]}'" \
        -draw "text 95,655'${monDays[21]}'" \
        -draw "text 197,655 '${monDays[22]}'" \
        -draw "text 299,655 '${monDays[23]}'" \
        -draw "text 402,655 '${monDays[24]}'" \
        -draw "text 504,655 '${monDays[25]}'" \
        -draw "text 607,655 '${monDays[26]}'" \
        -draw "text 709,655 '${monDays[27]}'" \
        -draw "text 95,820 '${monDays[28]}'" \
        -draw "text 197,820 '${monDays[29]}'" \
        -draw "text 299,820 '${monDays[30]}'" \
        -draw "text 402,820 '${monDays[31]}'" \
        -draw "text 504,820 '${monDays[32]}'" \
        -draw "text 607,820 '${monDays[33]}'" \
        -draw "text 709,820 '${monDays[34]}'" \
        -draw "text 95,985 '${monDays[35]}'" \
        -draw "text 197,985 '${monDays[36]}'" \
        -draw "text 299,985 '${monDays[37]}'" \
        -draw "text 402,985 '${monDays[38]}'" \
        -draw "text 504,985 '${monDays[39]}'" \
        -draw "text 607,985 '${monDays[40]}'" \
        -draw "text 709,985 '${monDays[41]}'" \
        $src_file \
        $dest_file
   
    done

    echo "-- ...done"
}

function build_weekly_overview()
{
    local year=$1
    local page_nr=$2

    echo "-- start building weekly overview page..."

    local header=$(echo "$1 - KW")
    
    local src_file=${RES_DIR}/$WEEK_OVERVIEW_HORIZ.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Weekly_Overview_Horiz_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 30,45 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      $src_file \
      $dest_file

    local src_file=${RES_DIR}/$WEEK_OVERVIEW_VERT.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Weekly_Overview_Vert_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 30,45 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      $src_file \
      $dest_file

    local src_file=${RES_DIR}/$WEEK_OVERVIEW_BLOCK.png
    local dest_file=${BUILD_DIR}/Planner-${page_nr}-Weekly_Overview_Block_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 22 \
      -draw "text 30,45 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      $src_file \
      $dest_file

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
  rm $BUILD_DIR/*.pdf
  echo "-- ...done"
}

function build_pdf_booklet()
{
  local year=$1

  echo "-- start building PDF booklet..."
  echo "-- -- 1st..."
  pdfjam --a4paper \
         --nup 2x2 \
         --scale 0.85 \
         --trim '-4mm -14mm -4mm -14mm' \
         --frame true \
         --outfile $BUILD_DIR/planner-full-booklet-1st-$year.pdf \
         $BUILD_DIR/planner-full-$year.pdf "16,17,14,19,12,21,10,23,8,25,6,27,4,29,2,31"
  echo "-- -- 2nd..."
  pdfjam --a4paper \
         --nup 2x2 \
         --scale 0.85 \
         --trim '-4mm -14mm -4mm -14mm' \
         --frame true \
         --outfile $BUILD_DIR/planner-full-booklet-2nd-$year.pdf \
         $BUILD_DIR/planner-full-$year.pdf "30,3,32,1,26,7,28,5,22,11,24,9,18,15,20,13"         
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
## build for Year
build_yearly_month $1 2
build_yearly_overview $1 3
build_quartarly_plan_goal $1 4
build_monthly $1 5
build_weekly_overview $1 6
build_pdf $1
publish_pdf_book $1
clean_build

echo "- ...finished"