#!/bin/sh

if [ -z "$T" ]; then T=$(echo $1.t*); fi
for TESTFILE in $T; do
    if ! [ -e $TESTFILE ]; then
        echo no tests
        continue
    fi
    ARGSFILE=$(echo $TESTFILE | sed 's/\.t\([0-9]\)\+$/\.i\1/')
    [ -f "$ARGSFILE" ] && ARGS="$(cat $ARGSFILE) "
    echo "./$1 $ARGS< $TESTFILE"
    ANS=$(./$1 $ARGS< $TESTFILE)
    echo "$ANS"
    REALANS=$(echo "$ANS" | tail -n 1)
    CMPFILE=$(echo $TESTFILE | sed 's/\.t\([0-9]\)\+$/\.a\1/')
    if [ $TESTFILE != $CMPFILE ] && [ -e $CMPFILE ]; then
        CMPANS=$(cat $CMPFILE)
        if [ "$REALANS" = "$CMPANS" ]; then
            echo pass
        else
            echo FAIL: $CMPANS
        fi
    else
        echo no cmp file
    fi
    echo ---
done
