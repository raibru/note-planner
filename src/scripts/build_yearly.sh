#!/bin/bash
#
# call: build_yearly.sh Year
#

YEAR_PLAN_TEMP=Planner-yearly-regular
RES_DIR=../res
BUILD_DIR=../../build

function build_yearly()
{
    local year=$1
    local header=$(echo "Year $1")

    local src_file=${RES_DIR}/$YEAR_PLAN_TEMP.png
    local dest_file=${BUILD_DIR}/Planner-1-Yearly_${year}.png

    convert  \
      -font helvetica \
      -fill black \
      -pointsize 20 \
      -draw "text 30,45 '$header'" \
      -font FreeMono \
      -fill black \
      -pointsize 12  \
      -draw "text 40, 90 '$(ncal -bhwM -d ${year}-1)'" \
      -draw "text 40, 210 '$(ncal -bhwM -d ${year}-2)'" \
      -draw "text 40, 330 '$(ncal -bhwM -d ${year}-3)'" \
      -draw "text 40, 450 '$(ncal -bhwM -d ${year}-4)'" \
      -draw "text 40, 570 '$(ncal -bhwM -d ${year}-5)'" \
      -draw "text 40, 690 '$(ncal -bhwM -d ${year}-6)'" \
      -draw "text 250, 90 '$(ncal -bhwM -d ${year}-7)'" \
      -draw "text 250, 210 '$(ncal -bhwM -d ${year}-8)'" \
      -draw "text 250, 330 '$(ncal -bhwM -d ${year}-9)'" \
      -draw "text 250, 450 '$(ncal -bhwM -d ${year}-10)'" \
      -draw "text 250, 570 '$(ncal -bhwM -d ${year}-11)'" \
      -draw "text 250, 690 '$(ncal -bhwM -d ${year}-12)'" \
      $src_file \
      $dest_file

      gm convert $BUILD_DIR/Planner*.png -density 72 -page a5 $BUILD_DIR/planner-$year.pdf
      echo -n "."

    echo "done"
}

build_yearly $1
