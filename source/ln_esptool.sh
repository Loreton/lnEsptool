#!/bin/bash


# ./esptool --port /dev/ttyUSB0 flash-id
# ./esptool --port /dev/ttyUSB0 read-flash 0x00000 0x100000 sonoff-r2-1mb.orig.bin
# ./esptool --port /dev/ttyUSB0 erase-flash
# ./esptool --port /dev/ttyUSB0 write-flash -fs 1MB -fm dout 0x0 tasmota.bin
# ./esptool --port /dev/ttyUSB0 verify-flash -fs 1MB -fm dout 0x0 tasmota.bin

function parseInput() { # solo per console
    fEXECUTE='0'
    args="$@"
    [[ $fDEBUG == '1' ]] && echo $args

    word='--go';    [[ " $args " == *" $word "* ]] && { args=${args//$word/}; fEXECUTE='--go'; }
    word='--id';    [[ " $args " == *" $word "* ]] && { args=${args//$word/}; FUNCTION_ACTION='get_flash_id'; }
    word='--erase'; [[ " $args " == *" $word "* ]] && { args=${args//$word/}; FUNCTION_ACTION='erase'; }
    word='--read';  [[ " $args " == *" $word "* ]] && { args=${args//$word/}; FUNCTION_ACTION='read'; }
    word='--write'; [[ " $args " == *" $word "* ]] && { args=${args//$word/}; FUNCTION_ACTION='write'; }
    word='--verify';[[ " $args " == *" $word "* ]] && { args=${args//$word/}; FUNCTION_ACTION='verify'; }

    g_rest_arguments=$(echo $args) # strip text
    [[ $fDEBUG == '1' ]] && echo "g_rest_arguments: $g_rest_arguments"
}


function checkPort() {
    local port_number="${1:-11}"
    if [[ $port_number =~ ^[0-2]+$ ]]; then
        return 0
    else
        echo "Enter a valid number for usb port [0-2]"
        return 1
    fi
}

function read() {
    set -u
    local port_number="${1:-11}"
    if checkPort "$port_number"; then
        echo "port ok"
    else
        echo "port bad"
    fi

    exit

    local image_file="${2:-"undefined"}"

    [[ $port_number =~ ^[0-2]+$ ]] || { echo "Enter a valid number for usb port [0-2]"; return; }
    local parent_dir=$(dirname $image_file)
    if [[ ! -d "$parent_dir" || "$image_file" == '/' ]]; then
        echo "["$parent_dir"] not valid. Please enter a valid filename path where to save firmware"
        return
    elif [[ -e "$image_file" ]]; then
        echo "["$image_file"] already exists!"
        return
    fi

    usb_port="/dev/ttyUSB${port_number}"

    # cmd="esptool --port ${usb_port} -b 115200 read-flash 0x00000 0x100000 ${image_file}"
    cmd="esptool --port ${usb_port} -b 460800 read-flash 0 ALL ${image_file}"
    echo -e "\n${cmd}\n"
    if [[ "$fEXECUTE" == '--go' ]]; then
        $cmd
    fi
}

function write() {
    set -u
    local port_number="${1:-11}"
    local image_file="${2:-"undefined"}"

    [[ $port_number =~ ^[0-2]+$ ]] || { echo "Enter a valid number for usb port [0-2]"; return; }
    if [[ ! -f "$image_file" ]]; then
        echo "["$image_file"] does not exist!"
        return
    fi

    usb_port="/dev/ttyUSB${port_number}"

    # cmd="esptool --port ${usb_port} -b 115200 read-flash 0x00000 0x100000 ${image_file}"
    cmd="esptool --port ${usb_port} -b 460800 write-flash 0 "${image_file}" --erase-all"
    echo -e "\n${cmd}\n"
    if [[ "$fEXECUTE" == '--go' ]]; then
        $cmd
    fi
}


function verify() {
    set -u
    local port_number="${1:-11}"
    local image_file="${2:-"undefined"}"

    [[ $port_number =~ ^[0-2]+$ ]] || { echo "Enter a valid number for usb port [0-2]"; return; }
    if [[ ! -f "$image_file" ]]; then
        echo "["$image_file"] does not exist!"
        return
    fi

    usb_port="/dev/ttyUSB${port_number}"

    # cmd="esptool --port ${usb_port} -b 115200 read-flash 0x00000 0x100000 ${image_file}"
    cmd="esptool --port ${usb_port} -b 460800 verify-flash 0 ${image_file}"
    echo -e "\n${cmd}\n"
    if [[ "$fEXECUTE" == '--go' ]]; then
        $cmd
    fi
}



function erase() {
    set -u
    local port_number="${1:-11}"

    [[ $port_number =~ ^[0-2]+$ ]] || { echo "Enter a valid number for usb port [0-2]"; return; }
    usb_port="/dev/ttyUSB${port_number}"


    # cmd="esptool --port ${usb_port} -b 115200 read-flash 0x00000 0x100000 ${image_file}"
    cmd="esptool --port ${usb_port} -b 460800 erase-flash"
    echo -e "\n${cmd}\n"
    if [[ "$fEXECUTE" == '--go' ]]; then
        $cmd
    fi
}




function get_flash_id() {
    local port_number="$1"
    [[ $port_number =~ ^[0-2]+$ ]] || { echo "Enter a valid number for usb port [0-2]"; return; }
    usb_port="/dev/ttyUSB${port_number}"

    # esptool --port ${usb_port} -b 115200 flash-id
    esptool --port ${usb_port} -b 9600 flash-id
}



###########################################################################
# - M A I N  -  M A I N  -  M A I N  -  M A I N  -  M A I N  -  M A I N  -
###########################################################################
    fDEBUG='0'
    parseInput "$@"
    # get_flash_id '0'
    # echo $FUNCTION_ACTION
    eval $FUNCTION_ACTION $g_rest_arguments