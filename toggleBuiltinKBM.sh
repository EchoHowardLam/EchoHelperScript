#!/bin/bash

getXInputDeviceID() {
	# Input: string device_name
	local xinputDeviceID=$(xinput list | grep "$1" | grep -Eo 'id=[1-9]+[0-9]*' | grep -Eo '[1-9]+[0-9]*')
	echo ${xinputDeviceID}
}

getXInputDeviceAttachedState() {
	# Input: string device_name
	local xinputDeviceAttachedState=$(xinput list | grep "$1" | grep -Eo 'floating slave')
	if [ -z "${xinputDeviceAttachedState}" ]; then
		xinputDeviceAttachedState='true'
	else
		xinputDeviceAttachedState='false'
	fi
	echo ${xinputDeviceAttachedState}
}

toggleXInputDevice() {
	# Input: string master_device_name
	# Input: string slave_device_name
	local masterDevice="$1"
	local slaveDevice="$2"
	local masterDeviceID=$(getXInputDeviceID "${masterDevice}")
	local slaveDeviceID=$(getXInputDeviceID "${slaveDevice}")
	local attached=$(getXInputDeviceAttachedState "${slaveDevice}")
	if [ "${attached}" == "true" ] ; then
		xinput float "${slaveDeviceID}"
	else
		xinput reattach "${slaveDeviceID}" "${masterDeviceID}"
	fi
}

masterPointer='Virtual core pointer'
masterKeyboard='Virtual core keyboard'
slavePointer='SynPS/2 Synaptics TouchPad'
slaveKeyboard='AT Translated Set 2 keyboard'

#xinput list

toggleXInputDevice "${masterPointer}" "${slavePointer}"
toggleXInputDevice "${masterKeyboard}" "${slaveKeyboard}"

xinput list

