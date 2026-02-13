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
goto :Process


:id
:get_flash_id
    # ${ESPTOOL} --port ${port} flash_id
    ${ESPTOOL} ${COM_PORT} flash_id
    exit /b

:backup
:save_current_firmware
    # ${ESPTOOL} --port ${port} -b 460800 read_flash 0x00000 0x100000 original_s1M.bin
    image_file=Ln_Firmware\Backup\Areazione_Superiore_2021-05-04.bin
    image_file=Ln_Firmware\Backup\SWA1_2021-10-21.bin
    ${ESPTOOL} --port ${port} -b 115200 read_flash 0x00000 0x100000 ${image_file}
    exit /b

:erase
:erase_firmware
    # ${ESPTOOL} --port ${port} erase_flash
    ${ESPTOOL} ${COM_PORT} erase_flash
    exit /b

:upload
:upload_firmware
    # image_file=Sonoff-Tasmota-6.4.1\sonoff\sonoff.ino.esp8285.bin
    # image_file=Loreto\Tasmota_sonoff.bin
    # image_file=Loreto\tasmota_sonoff.ino.LnFP25+Ln-Info.bin
    # image_file=binary_firmware\sonoff-basic_671.bin
    # image_file=binary_firmware\sonoff_671.bin
    # image_file=binary_firmware\tasmota_v851.bin
    # image_file=binary_firmware\Tasmota_v9.2.0_Julie.bin
    # image_file=binary_firmware\Tasmota_v9.3.1.bin
    # image_file=binary_firmware\Tasmota_v9.5.0.bin
    image_file=binary_firmware\tasmota_v10.1.0.bin

    echo.
    echo "writing image: ${image_file}"
    echo.
    # ${ESPTOOL} ${COM_PORT} erase_flash
    ${ESPTOOL} ${COM_PORT} write_flash -fs 1MB -fm dout 0x0 ${image_file}
    exit /b


# NOTE: When the command completes the device is out of firmware upload mode!

:Process
    port=COM5
    ESPTOOL=echo
    COM_PORT=--port /dev/ttyUSB0 -b 115200

    # https://github.com/espressif/esptool/wiki/Advanced-Options
    BEFORE=--before no_reset
    BEFORE=--before default_reset" &# defaul
    BEFORE=

    AFTER=--after hard_re  &# defaul
    AFTER=--after no_reset"  &# no reset is performed.  leaves the chip in the serial bootloade
    AFTER=


    esptool_py=%Ln_FreeDir%\Pgm\WPy-3710\python-3.7.1.amd64\Lib\site-packages\esptool.py
    ESPTOOL=python ${esptool_py} ${BEFORE} ${AFTER}
    call :$1
    # call :save_current_image
    # call :erase_firmware
    # call :upload_firmware
