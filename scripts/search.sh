#!/bin/bash

#Repos STD
repos="BG4RFF dzarda Electro707 gerard-hm gerard-hm Hailong123-Qu INTI-CMNB nobodywasishere NT7S"

CURRENT_DIR=$(pwd)

function downloadRepo()
{
    REPO=$1
    DIR=$2

    echo testing $REPO
    if [ -d $DIR ];
    then
        cd $DIR 
        git pull
        cd ../..
    else
        git clone https://github.com/$REPO $DIR 
    fi
}

if [ ! -d repos ];
then
    mkdir repos
    for repo in $repos
    do
        downloadRepo  $repo/PcbDraw-Lib repos/$repo
    done

    downloadRepo kekcheburec/PcbDraw-Lib-for-crabik repos/kekcheburec
    #All repos
fi

repos="$repos kekcheburec"

if [ $# -ne 3 ]; 
then 
    echo "illegal number of parameters"
    echo "ussage $0 [LIB] [FULL_NAME] [ALT_NAME]"
    exit 1
fi

LIBNAME=$1
COMPONENT=$2

echo searching $COMPONENT of $LIBNAME
find . -name *$3*

