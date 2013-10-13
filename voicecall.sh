#!/bin/bash

#
# voicecall.sh by inf
#
# use huawei voice-enabled modem to call someone
# confirmed to work with EM770W (no firmware modifications needed)
# only audio receive right now
#
# you may want to start `cat /dev/ttyUSB0` in another terminal
#
# usage: ./voicecall.sh 800700200
#

NUMBER=$1
CONTROL_DEVICE=/dev/ttyUSB0
AUDIO_IN_DEVICE=/dev/ttyUSB1

at_command()
{
    echo -e "$*\r" > $CONTROL_DEVICE
    echo "> $*"
    sleep 0.1
}

control_c()
{
    echo "Hanging up"
    at_command "ATH"
}

# Prepare device
at_command "AT^DDSETEX=2"
at_command "AT+CVHU=0"
at_command "AT+CRC=1"
at_command "AT+CLIP=1"

trap control_c SIGINT

# Actual calling
at_command "ATDT$NUMBER;"
at_command "AT^DDSETEX=2"

echo "Receiving..."
aplay $AUDIO_IN_DEVICE -f S16_LE
