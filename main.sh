#!/bin/bash

: '
@project: tslides
@repo: https://github.com/Alexandra-Miller/tslides
@creator: Alexandra Marie Miller
@description

@description
@dependencies: bash, jp2a, figlet 
'

# ====================  GLOBAL VARS  ===========================================


# CONSTANTS
HELPMSG="USAGE: tslides FILE || OPTIONS
OPTIONS:
-v  --version   prints version and then exits
-h  --help      prints this message and then exits
"
TERM_WIDTH=`tput cols`
TERM_HEIGHT=`tput lines`
FONT_DIR="$HOME/.resources/tslides/resources/fonts"

# MUTABLE VARS
current_transition="cut"

title_font="3-d"
subtitle_font="standard"
header_font="mini"

pause_on="slides"

# ====================  FUNCTIONS  ============================================


cutTransition() {
    echo "$1"
}

ttyTransition () {
    IFS=$'\n'
    echo "$1" |
    while read -r line
    do
        echo "$line" |
        while  read -r -n1 char
        do
            echo -n "$char"
            sleep 0.0000694444
        done
        echo ""
    done
}

lineTransition () {
    IFS=$'\n'
    echo "$1" |
    while read -r line
    do
        echo "$line"
        sleep 0.1
    done
}

# args: transition text, transition type
transition() {
    [ "$2" = "cut" ] && cutTransition "$1"
    [ "$2" = "tty" ] && ttyTransition "$1"
    [ "$2" = "line" ] && lineTransition "$1"
}

evalCode() {
    code=`sed 's/.*|>\(.*\)<|.*/\1/' <<< "$1"`
    front=`sed 's/|>.*//' <<< "$1"`
    back=`sed 's/.*<|//' <<< "$1"`
    evalResult=`( eval "$code" )`
    echo -e "$front $evalResult $back"
}

# shows images as single slides
printImg() {
    clear
    imgfile=`sed 's/\;i\[\(.*\)\]/\1/' <<< "$1"`
    image=`jp2a "$imgfile"`
    transition "$image" "$current_transition"
}

showVideo() {
    caca_width=`(( $TERM_HEIGHT * 16 / 9 ))`
    CACA_GEOMETRY="$TERM_HEIGHT x $TERM_WIDTH"
    echo $CACA_GEOMETRY
    sleep 3
    videoFile=`sed 's/\;v\[\(.*\)\]/\1/' <<< "$1"`
    mplayer -vo caca -quiet "$videoFile"
}

printTitle() {
    text=`sed 's/#\(.*\)/\1/' <<< "$1"`
    figText=`figlet -w "$TERM_WIDTH" -f "$FONT_DIR/$title_font.flf" "$text"`
    transition "$figText" "$current_transition"
}

printSubtitle() {
    text=`sed 's/##\(.*\)/\1/' <<< "$1"`
    figText=`figlet -w "$TERM_WIDTH" -f "$FONT_DIR/$subtitle_font.flf" "$text"`
    transition "$figText" "$current_transition"
}

printHeader() {
    text=`sed 's/###\(.*\)/\1/' <<< "$1"`
    figText=`figlet -w "$TERM_WIDTH" -f "$FONT_DIR/$header_font.flf"  "$text"`
    transition "$figText" "$current_transition"
}

parseLine() {
    val="$1"
    # this executes embedded code
    if [[ "$1" =~ ^.*\|\>.*\<\|.*$ ]]
    then
        val=`evalCode "$1"`
    fi

    #this catches setters
    if [[ "$val" =~ ^\;\;.*$ ]]
    then
        # this matches setters for various fonts
        if [[ "$val" =~ ^\;\;transition:\ \ *.*$  ]]
        then
                current_transition=`sed 's/\;\;transition:\ *\(.*\)\ */\1/' <<< "$val"`
        elif [[ "$val" =~ ^\;\;titleFont:\ \ *.*$  ]] 
        then
            title_font=`sed 's/\;\;titleFont:\ *\(.*\)\ */\1/' <<< "$val"`
        elif [[ "$val" =~ ^\;\;subtitleFont:\ \ *.*$  ]]  
        then
            subtitle_font=`sed 's/\;\;subtitleFont:\ *\(.*\)\ */\1/' <<< "$val"`
        elif [[ "$val" =~ ^\;\;headerFont:\ \ *.*$  ]] 
        then
            header_font=`sed 's/\;\;headerFont:\ *\(.*\)\ */\1/' <<< "$val"`
 
        # this matches pause on inidcators
        elif [[ "$val" =~ ^\;\;pauseOn:\ \ *.*$  ]] 
        then
            pause_on=`sed 's/\;\;pauseOn:\ *\(.*\)\ */\1/' <<< "$val"`
        fi
    else 
        # this matches indicators for slide changes
        if [[ "$val" =~ ^\;slide\ *$ ]]
        then
            read -rsn 1 -u 1
            clear
            return 0 
        
        # this matches headers and titles
        elif [[ "$val" =~ ^#\ \ *.*$  ]]
        then
            printTitle "$val" 
        elif [[ "$val" =~ ^##\ \ *.*$  ]]
        then
            printSubtitle "$val"
        elif [[ "$val" =~ ^###\ \ *.*$  ]]
        then
            printHeader "$val"
 
        # this matches images 
        elif [[ "$val" =~ ^\;i\[.*\]$\ * ]]
        then
            printImg "$val"
 
        # this matches videos 
        elif [[ "$val" =~ ^\;v\[.*\]$\ * ]]
        then
            showVideo "$val"
 
        # this prints any text that was not matched by previous patterns
        else
            transition "$val" "$current_transition"
        fi
 
        if [ "$pause_on" = "line" ]
        then
            read -rsn 1 -u 1
        fi
    fi
}

cat "$1" |
while read -r line
do
    parseLine "$line"
done
