#!/bin/bash
#
# collect all weeks per page into printable PDF
#

year=$1
WEEK_PLAN_TEMP=Planner-Weekly-regular
PLAN_TEMP_PATTERN=Planner-*.png
RES_DIR=../res
BUILD_DIR=../../build

echo "starting converting to PDF..."
convert $BUILD_DIR/$PLAN_TEMP_PATTERN \
        -density 72 \
        -page a5 \
        $BUILD_DIR/planner-weekly-$year.pdf
#gm convert $BUILD_DIR/${WEEK_PLAN_TEMP}_*.png -density 72 -page a5 $BUILD_DIR/planner-weekly-$year.pdf
echo "...finish"

# EOF