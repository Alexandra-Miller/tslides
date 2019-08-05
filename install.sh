#!/bin/bash


#make directory for resources
if [ -d "resources" ]
then
    mkdir -p ~/.resources/tslides/
    cp -r resources ~/.resources/tslides/
fi

mkdir -p $HOME/bin
cp main.sh $HOME/bin/tslides
