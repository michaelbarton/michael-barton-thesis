#!/bin/sh

# Targets
SRC=src
LIB=lib
IMAGE=image
OUT=out
TEMP=tmp

ARTICLE=thesis

# Clean directory
if [ -d $TEMP ] ; then
        rm $TEMP/*
        rmdir $TEMP
fi	
mkdir $TEMP

# Copy required files
cp $SRC/* $TEMP
cp $LIB/* $TEMP
cp $IMAGE/* $TEMP

# Create the pdf and ps files
make thesis -C $TEMP

# Copy produced files to out
cp $TEMP/$ARTICLE.pdf $OUT
cp $TEMP/$ARTICLE.ps $OUT

# Remove the temporary directory
#rm $TEMP/*
#rmdir $TEMP
