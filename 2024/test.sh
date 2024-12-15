#!/bin/sh

if [ -z "$T" ]; then T=$(echo $1.t*); fi
for TESTFILE in $T; do
    if ! [ -e $TESTFILE ]; then
        echo no tests
        continue
    fi
    echo "./$1.rb < $TESTFILE"
    ANS=$(./$1.rb < $TESTFILE)
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
if [ -e $1.ans ] && ! [ -e $1.skip ]; then
    echo "./$1.rb < ${1%%?}.in"
    ANS=$(./$1.rb < ${1%%?}.in)
    echo "$ANS"
    REALANS=$(echo "$ANS" | tail -n 1)
    CMPANS=$(cat $1.ans)
    if [ "$REALANS" = "$CMPANS" ]; then
        echo pass
    else
        echo FAIL: $CMPANS
    fi
fi
