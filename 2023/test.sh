#!/bin/sh

if [ -z "$T" ]; then T=$(echo $1.t*); fi
for TESTFILE in $T; do
    if ! [ -e $TESTFILE ]; then
        echo no tests
        continue
    fi
    echo "./$1 < $TESTFILE"
    ANS=$(./$1 < $TESTFILE)
    echo "$ANS"
    CMPFILE=$(echo $TESTFILE | sed 's/\.t\([0-9]\)\+$/\.a\1/')
    if [ $TESTFILE != $CMPFILE ] && [ -e $CMPFILE ]; then
        CMPANS=$(cat $CMPFILE)
        if [ "$ANS" = "$CMPANS" ]; then
            echo pass
        else
            echo fail: $CMPANS
        fi
    else
        echo no cmp file
    fi
done
