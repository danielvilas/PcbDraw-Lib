#!/bin/bash

#R_1206_3216Metric
MODS="1206:3216Metric 0805:2012Metric"
SUFFIXES=".svg .back.svg"

function changeOne(){
    LIB=$1
    PREFIX=$2
    short=$3
    metric=$4
    SUFFIX=$5
    shortFile="KiCAD-base/$LIB/$PREFIX$short$SUFFIX"
    metricFile="KiCAD-base/$LIB/$PREFIX${short}_$metric$SUFFIX"
    [ -L $metricFile ] && echo exists && return  
    if [ -f  $shortFile ];
    then
        echo  $shortFile - $metricFile
        ln -s $PREFIX$short$SUFFIX $metricFile
    fi 
}


function changeAll(){
    LIB=$1
    PREFIX=$2
    for MOD in $MODS
    do
        modArray=(${MOD//:/ })
        short=${modArray[0]}
        metric=${modArray[1]}
        echo  Changing $LIB: $short to $metric
        for SUFFIX in $SUFFIXES
        do
            changeOne $LIB $PREFIX $short $metric $SUFFIX
        done
    done   
}

function linkOverDirsOne(){
    LIB=$1
    PREFIX=$2
    DST=$3
    short=$4
    SUFFIX=$5

    LibFile="KiCAD-base/$LIB/$PREFIX$short$SUFFIX"

    [ ! -f $LibFile ] && return
    DSTFILE="KiCAD-base/$DST/$PREFIX$short$SUFFIX"
    
    [ -f $DSTFILE ] && echo exists && return  
    ln -s ../$LIB/$PREFIX$short$SUFFIX $DSTFILE

}

function linkOverDirs(){
    LIB=$1
    PREFIX=$2
    DST=$3

    for MOD in $MODS
    do
        modArray=(${MOD//:/ })
        short=${modArray[0]}
        echo  Linking $LIB: $short to $DST
        for SUFFIX in $SUFFIXES
        do
            linkOverDirsOne $LIB $PREFIX $DST $short $SUFFIX
        done
        
    done   
}

function linkLibrary(){
    LIB=$1
    DST=$2

    echo Linking $DST to $LIB
    [ -f "KiCAD-base/$DST" ] && echo exists && return  
    [ ! -f "KiCAD-base/$LIB" ] && return
    ln -s $LIB KiCAD-base/$DST
}

function linkToDummy(){
    LIB=$1
    OBJECT=$2
    echo Dummy to $LIB $OBJECT

    [ ! -d KiCAD-base/$LIB/ ] && mkdir KiCAD-base/$LIB
    [ -f "KiCAD-base/$LIB/$OBJECT.svg" ] && echo exists && return  
    ln -s ../dummy/dummy.svg KiCAD-base/$LIB/$OBJECT.svg
}

linkOverDirs LEDs LED_ LED_SMD

#R_1210.svg
changeAll Resistor_SMD R_
changeAll Capacitor_SMD C_
changeAll LED_SMD LED_

linkLibrary TO_SOT_Packages_SMD Package_TO_SOT_SMD
linkToDummy Jumper SolderJumper-2_P1.3mm_Bridged_RoundedPad1.0x1.5mm
linkToDummy Jumper SolderJumper-2_P1.3mm_Open_RoundedPad1.0x1.5mm
linkToDummy MountingHole MountingHole_2.7mm_M2.5_DIN965_Pad
#Package_TO_SOT_SMD TO_SOT_Packages_SMD/SOT-23.svg