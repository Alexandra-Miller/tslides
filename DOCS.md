# FILE NAME: undefined
### REPOSITORY: undefined
### CREATOR:  Alexandra Marie Miller
### DESCRIPTION:

###DEPENDENCIES: 
 bash, jp2a, figlet 



## CLASSES:

## FUNCTIONS: 
### NAME:  cutTransition
#### DESCRIPTION:
Transitions in text instantly.
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1 transition text
#### SIDE EFFECTS:
 sends text to STDOUT
#### RETURNS:
 none




### NAME:  ttyTransition
#### DESCRIPTION:
Transitions in text like a TTY terminal running on a high baud modem.
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1 transition text
#### SIDE EFFECTS:
 sends text to STDOUT
#### RETURNS:
 none




### NAME:  lineTransition
#### DESCRIPTION:
Fades in text line by line.
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1 transition text
#### SIDE EFFECTS:
 sends text to STDOUT
#### RETURNS:
 none




### NAME:  transition
#### DESCRIPTION:
Transitions text in terminal.
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1 transition text, $2  transition type
#### SIDE EFFECTS:
 sends text to STDOUT
#### RETURNS:
 nothing




### NAME:  evalCode
#### DESCRIPTION:
Evaluates a line of code and returns the text sent to STDOUT from program to terminal.
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1 line of code to be evaluated
#### SIDE EFFECTS:
 Executes line of code and substitutes it into string.
#### RETURNS:
 text sent to STDOUT by program




### NAME: 
#### DESCRIPTION:
Displays image in terminal.
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1  line of code containing image text
#### SIDE EFFECTS:
 prints image in terminal
#### RETURNS:
 nothing




### NAME:  playVideo
#### DESCRIPTION:
Plays video in the terminal 
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1  line of code containing video text
#### SIDE EFFECTS:
 plays video in new window
#### RETURNS:
 nothing




### NAME:  printHeader
#### DESCRIPTION:
Prints a line of special text as defined by a delimiter.
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1  line of code containing text, $2  text designatot, $3 font
#### SIDE EFFECTS:
 prints to terminal
#### RETURNS:
 nothing




### NAME:  parseLine
#### DESCRIPTION:
Parses a line of code from the input file.
  DEPENDENCIES: undefined
#### ARGUMENTS: 
 $1  line of code to be evaluated
#### SIDE EFFECTS:
 subprocesses print to terminal and may execute system commands
#### RETURNS:
 nothing

