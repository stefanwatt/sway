#!/usr/bin/env bash

currentSinkId=$(\
  ponymix defaults |\
  sed -e '/^source/,+2d'\
  -e '/^sink/{n;N;d}' |\
  awk '{print $2}' |\
  sed 's/://'\
)

headset="sink [0-9]+: alsa_output.usb-Logitech_PRO_X_Wireless_Gaming_Headset-00.analog-stereo"
speaker="sink [0-9]+: bluez_output.08_EB_ED_CD_CB_02.1"
interface="sink [0-9]+: alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo"
# Get the list of device IDs
deviceIds=(\
  $(ponymix -t sink list |\
  sed -E -e "/$headset|$speaker|$interface/,+2!d"\
  -e '/Avg/d' \
  -e '/^\s/d' \
  -e 's/sink ([0-9]+)/\1/' |\
  awk -F'[: ]' '{print $1}') 
)

# iterate over the list of device IDs and print the current index if it matches the current sink ID
echo "Device IDs:" 
for i in "${!deviceIds[@]}"; do
  if [[ "${deviceIds[$i]}" = "${currentSinkId}" ]]; then
    currentIndex="$i"
  fi
done

nextIndex=$(((currentIndex + 1) % ${#deviceIds[@]}))

echo current index $currentIndex
echo next index $nextIndex
# Set the new sink ID to the next device
newSinkId=${deviceIds[$nextIndex]}
newSinkId=${newSinkId%:}
ponymix set-default -d "$newSinkId"

echo "Current sink ID: $currentSinkId"
echo "New sink ID: $newSinkId"
ponymix set-default -d "$newSinkId"
echo "Current sink ID: $currentSinkId"
echo "New sink ID: $newSinkId"
newSinkId=${newSinkId%:}
ponymix set-default -d "$newSinkId"
inputIds=$(\
  ponymix list -t sink-input |\
  sed '/^sink/!d' |\
  awk '{print $2}' |\
  sed 's/://'\
)

IFS=$'\n'
set -f 
for i in $inputIds; do
  ponymix -t sink-input -d "$i" move "$newSinkId"
done