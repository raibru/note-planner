#!/bin/bash
#
# call: build_daily.sh Day-Number-Begin Day-Number-End Year
#

DAY_PLAN_TEMP=Planner-Daily
RES_DIR=../res
BUILD_DIR=../../build

function daysPerMonth()
{
    local month=$1
    local year=$2
    local -n result=$3

    #local date_fmt="+%a %d. %b"
    local date_fmt="+%A_%d._%B"
    local date_month_fmt="+%m"
    local date_day_fmt="+%d"
    local date_woy_fmt="+%W"
    local dom
    local day
    local monthNum
    local dayNum
    local weekNum

    dom=$(cal $i $year | awk 'NF {DAYS = $NF}; END {print DAYS}')
    for i in $(seq 1 $dom)
    do
      dd="${year}-${month}-${i}"
      day=$(date -d $dd "$date_fmt")
      monthNum=$(date -d $dd "$date_month_fmt")
      dayNum=$(date -d $dd "$date_day_fmt")
      weekNum=$(date -d $dd "$date_woy_fmt")
      if [[ "$weekNum" == "00" ]]
      then
        weekNum=$(date -d $(expr $year - 1)-12-31 "$date_woy_fmt")
      fi
      dayData=$(echo "$day;$i;$monthNum;$dayNum;$weekNum ")
      #echo "$dayData"
      result+=${dayData}
    done
}

function buildDaily
{
    local mstart=$1
    local mend=$2
    local year=$3


    local src_file=${RES_DIR}/$DAY_PLAN_TEMP.png
    local dest_file
    local header

     for i in $(seq $mstart $mend)
     do
      local dayList=()
      local header
      local day_num
      local month_num
      local week_num

      daysPerMonth $i $year dayList
      for j in $dayList
      do
        header=$(echo $j |cut -d';' -f1 |tr -s "_" " ")
        day_idx=$(echo $j |cut -d';' -f2)
        month_num=$(echo $j |cut -d';' -f3)
        day_num=$(echo $j |cut -d';' -f4)
        week_num=$(echo $j |cut -d';' -f5)
        dest_file=${BUILD_DIR}/${DAY_PLAN_TEMP}_${year}_${month_num}_${day_num}.png
        convert  \
          -font helvetica \
          -fill black \
          -pointsize 24 \
          -draw "text 30,50 '$header'" \
          -draw "text 700,50 'KW $week_num'" \
          $src_file \
          $dest_file
        echo -n "."
      done
      echo -n "#"
      convert $BUILD_DIR/${DAY_PLAN_TEMP}_${year}_${month_num}_*.png $BUILD_DIR/planner-daily-${year}-${month_num}.pdf
      echo "done for $(echo $header |cut -d" " -f3)"
    done
    echo "done all"
}

buildDaily $1 $2 $3
