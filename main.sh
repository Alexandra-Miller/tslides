#!/bin/bash

: '
@project: tslides
@repo: https://github.com/Alexandra-Miller/tslides
@creator: Alexandra Marie Miller
@description

@description
@dependencies: bash 
'

# ====================  GLOBAL VARS  ===========================================

# CONSTANTS

HELPMSG="USAGE: tslides FILE || OPTIONS
OPTIONS:
-v  --version   prints version and then exits
-h  --help      prints this message and then exits
"

# MUTABLE VARS

current_transition="instant"


# ====================  FUNCTIONS  ============================================


cutTransition() {
    echo $1
}

ttyTransition () {
    echo $1 |
    while read -r line
    do
        echo $line |
        while  read -r -n1 char
        do
            echo -n "$char"
            sleep 0.00006944444
        done
        echo ""
    done
}

# args: transition text, transition type
transition() {
    [ "$2" = "cut" ] && cutTransition $1;
    [ "$2" = "tty" ] && ttyTransition $1;
    [ "$2" = "fade" ] && fadeTransition $1;
}

evalCode() {
    front=`cut -d "\`" -f1 <<< "$1"`
    back=`cut -d "\`" -f3 <<< $1`
    code=`cut -d "\`" -f2 <<< "$1"`
    
    result="`eval $code`"

}

# shows images as single slides
showimg() {
    imgfile=`sed 's/\;\[\(.*\)\]/\1/' <<< "$1"`
    image=`jp2a ./"$imgfile"`
    transition "$image" "$currentTransition"
}


cat "$1" |
while read -r line
do

    # this executes embedded code
    [[ "$1" =~ \`.*\`  ]] && 1=`evalCode`

    # this matches indicators for slide changes
    if [[ "$1" =~ \;SLIDE\s* ]]
    then
        read test
        echo skipped
        # clear 
    fi

    # this matches setters for various fonts
    

    # this matches headers and titles
    [[ "$1" =~ ^#\s.*$ ]] && printTitle
    [[ "$1" =~ ^###\s.*$ ]] && printSubtitle



    # this matches images 
    [[ "$1" =~ ^\;\[.*\]$ ]] && showimg $1

done
