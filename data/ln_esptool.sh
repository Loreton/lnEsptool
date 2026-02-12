@echo off
# Tasmota_sonoff
# Partire da:
#      https://tasmota.github.io/docs/Arduino-IDE/
#      https://github.com/arendst/Tasmota/wiki
# https://tasmota.github.io/docs/Arduino-IDE/
#     IMPORTANT: For Windows users, before executing arduino.exe add an empty
#                folder called portable in the known folder.
#
#      Install ESP8266 board software
#        Open Arduino IDE and select File → Preferences and add the following text
#              for field Additional Boards Manager URLs:
#                  http://arduino.esp8266.com/stable/package_esp8266com_index.json and select OK.
#                  http://github.com/esp8266/Arduino/releases/download/2.6.1/package_esp8266com_index.json
#                  http://github.com/esp8266/Arduino/releases/download/3.0.2/package_esp8266com_index.json
#        Open Tools → Boards... → Boards Manager... and scroll down and click on esp8266 by ESP8266 Community.
#              Click the Install button to download and install the latest ESP8266 board software.
#                  Select Close.
#
#      Download Tasmota
#          Download the latest Tasmota release Source code from
#              https://github.com/arendst/Sonoff-Tasmota/releases and unzip to another known folder.

# https://tasmota.github.io/docs/Getting-Started/#hardware-preparation
# Ubuntu: sudo apt install cutecom (com monitor)


function get_flash_id(com_port) {
    ${ESPTOOL} ${com_port} 'flash_id'
}



###########################################################################
# - M A I N  -  M A I N  -  M A I N  -  M A I N  -  M A I N  -  M A I N  -
###########################################################################
    ESPTOOL=${which esptool}
    COM_PORT='--port /dev/ttyUSB0 -b 115200'

    get_flash_id "$COM_PORT"