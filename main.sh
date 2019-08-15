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
FONT_DIR="$HOME/.resources/tslides/fonts"

# MUTABLE VARS
current_transition="cut"

title_font="epic"
subtitle_font="standard"
header_font="mini"

pause_on="slides"

# ====================  FUNCTIONS  ============================================
: '
@function
  @name: cutTransition
  @description
Transitions in text instantly.
  @description
  @ependencies: none
  @args: $1 transition text
  @sideEffects: sends text to STDOUT
  @returns: none
@function
'
cutTransition() {
    echo "$1"
}

: '
@function
  @name: ttyTransition
  @description
Transitions in text like a TTY terminal running on a high baud modem.
  @description
  @ependencies: none
  @args: $1 transition text
  @sideEffects: sends text to STDOUT
  @returns: none
@function
'
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

: '
@function
  @name: lineTransition
  @description
Fades in text line by line.
  @description
  @ependencies: none
  @args: $1 transition text
  @sideEffects: sends text to STDOUT
  @returns: none
@function
'
lineTransition () {
    IFS=$'\n'
    echo "$1" |
    while read -r line
    do
        echo "$line"
        sleep 0.1
    done
}

: '
@function
  @name: transition
  @description
Transitions text in terminal.
  @description
  @ependencies: cutTransition, ttyTransition, lineTransition
  @args: $1 transition text, $2  transition type
  @sideEffects: sends text to STDOUT
  @returns: nothing
@function
'
transition() {
    [ "$2" = "cut" ] && cutTransition "$1"
    [ "$2" = "tty" ] && ttyTransition "$1"
    [ "$2" = "line" ] && lineTransition "$1"
}

: '
@function
  @name: evalCode
  @description
Evaluates a line of code and returns the text sent to STDOUT from program to terminal.
  @description
  @ependencies: nothing
  @args: $1 line of code to be evaluated
  @sideEffects: Executes line of code and substitutes it into string.
  @returns: text sent to STDOUT by program
@function
'
evalCode() {
    code=`sed 's/.*|>\(.*\)<|.*/\1/' <<< "$1"`
    front=`sed 's/|>.*//' <<< "$1"`
    back=`sed 's/.*<|//' <<< "$1"`
    evalResult=`( eval "$code" )`
    echo -e "$front $evalResult $back"
}

: '
@function
  @name:
  @description
Displays image in terminal.
  @description
  @ependencies: jp2a, transition
  @args: $1  line of code containing image text
  @sideEffects: prints image in terminal
  @returns: nothing
@function
'
printImg() {
    clear
    imgfile=`sed 's/\;i\[\(.*\)\]/\1/' <<< "$1"`
    image=`jp2a "$imgfile"`
    transition "$image" "$current_transition"
}

# TODO: make video play in same terminal
: '
@function
  @name: playVideo
  @description
Plays video in the terminal 
  @description
  @ependencies: caca, mplayer
  @args: $1  line of code containing video text
  @sideEffects: plays video in new window
  @returns: nothing
@function
'
playVideo() {
    termwide_width=`(( $TERM_HEIGHT * 16 / 9 ))`
    
    videoFile=`sed 's/\;v\[\(.*\)\]/\1/' <<< "$1"`
    mplayer -vo caca -quiet "$videoFile"
}

: '
@function
  @name: printHeader
  @description
Prints a line of special text as defined by a delimiter.
  @description 
  @ependencies: figlet
  @args: $1  line of code containing text, $2  text designatot, $3 font
  @sideEffects: prints to terminal
  @returns: nothing
@function
'
printText() {
    text=`sed "s/$2\(.*\)/\1/" <<< "$1"`
    figText=`figlet -t -f "$FONT_DIR/$3.flf" "$text"`
    transition "$figText" "$current_transition"
}

: '
@function
  @name: parseLine
  @description
Parses a line of code from the input file.
  @description
  @ependencies: printHeader, printSubtitle, printTitle, printImg, showVideo, transition, evalCode
  @args: $1  line of code to be evaluated
  @sideEffects: subprocesses print to terminal and may execute system commands
  @returns: nothing
@function
'
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
            printText "$val" "#" "$title_font"  
        elif [[ "$val" =~ ^##\ \ *.*$  ]]
        then
            printText "$val" "##" "$subtitle_font"  
        elif [[ "$val" =~ ^###\ \ *.*$  ]]
        then
            printText "$val" "###" "$header_font"  
 
        # this matches images 
        elif [[ "$val" =~ ^\;i\[.*\]$\ * ]]
        then
            printImg "$val"
 
        # this matches videos 
        elif [[ "$val" =~ ^\;v\[.*\]$\ * ]]
        then
            playVideo "$val"
 
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


# ==================== PROCEDURAL CODE =========================================

# get start time
start=`date +%s`
startDate=`date -Is`

# execute slideshow
cat "$1" |
while read -r line
do
    parseLine "$line"
done

# get end time
end=`date +%s`
endDate=`date -Is`

# get runtime
runtime=$((end-start))

# display runtime and end time
echo "slideshow finished"
echo "start: $startDate end: $endDate runtime: $runtime"

