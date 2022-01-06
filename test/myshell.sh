#!/bin/bash

lan="kor"

function learn() {

   local learn_lan="English"
   echo "I am learning $learn_lan"
}

function print() {

   echo "I can speak $1"

}

learn
print $lan
print $learn_lan
