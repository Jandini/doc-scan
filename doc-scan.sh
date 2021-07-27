#!/bin/bash

# Requirements
# apt-get install libtiff-tools
# apt-get install sane sane-utils
# apt-get install sendemail
# apt-get install libjpeg-dev

TARGET_FOLDER=/mnt/raid/scans
RESOLUTION=200
MODE=Gray
KEEP_IMAGES=0

ERROR_COUNT=0
FIRST_RUN=1

while true; do

    if [ $KEEP_IMAGES == 1 ];
    then temp=$TARGET_FOLDER/~temp
    else temp=/tmp/doc_scan; fi

    batch=$(date +%Y%m%d_%H%M%S)
    mkdir -p $temp
    scanimage --format tiff --batch=$temp/$(date +%Y%m%d_%H%M%S)_%04d.tif --resolution $RESOLUTION --mode $MODE --source "ADF Duplex"

    if [ $? == 0 ]; then
	tiffcp $temp/*.tif $temp/output.tiff
	tiff2pdf -j -o $TARGET_FOLDER/$batch.pdf $temp/output.tiff

	if [ $KEEP_IMAGES == 1 ]; then
	    mv $temp $TARGET_FOLDER/$batch
	    chmod 666 $TARGET_FOLDER/$batch/*
	    chmod 777 $TARGET_FOLDER/$batch
	else
	    rm -f $temp/*
	fi

	ERROR_COUNT=0
	FIRST_RUN=0
    else
	rm -f $temp/*
	sleep 1
	((ERROR_COUNT++))
	echo $ERROR_COUNT
    fi

    if [ $FIRST_RUN -eq 1 ] && [ $ERROR_COUNT -gt 15 ]; then exit; fi

done
