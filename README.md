# Projects for the NodeMCU platform written in Lua

I am not an experienced developer on the [NodeMCU](http://www.nodemcu.com) platform. But since I like to play with embedded devices as a hobby, I'm publishing my results in case this could be of use to someone else.

- [HTU21D-TLS](HTU21D-TLS/): Measure temperature and humidity, and submit the result to a web server.

# Tools

## Firmware build

Tailoring your NodeMCU firmware is a must, so that you can enable only the modules that you really need. This way you will have more free RAM for your uploaded program.

Building a custom NodeMCU is very easy using the [nodemcu-build.com](https://nodemcu-build.com/) free service.

There are different versions of the firmware. So far I've found out that the old stable "1.5.4.1-final" provides me with all I need. Each firmware version has a corresponding documentation page. For "1.5.4.1-final" use [this one](http://nodemcu.readthedocs.io/en/1.5.4.1-final/).

## Firmware upload

On my Windows machine I use the [esptool](https://github.com/espressif/esptool) in the following way:
```
esptool.py.exe --port com8 erase_flash
esptool.py.exe --port com8 write_flash -fm dio 0x00000 xxx_file.bin
```

## USB terminal

There are times when you want to have more direct access to the USB console. The [nodemcu-uploader](https://github.com/kmpm/nodemcu-uploader) works great:
```
nodemcu-uploader.exe --port com8 terminal
nodemcu-uploader.exe --port com8 --start_baud 9600 --baud 9600 terminal
```

## Source code upload and debug

The [ESPlorer](https://esp8266.ru/esplorer/) is an easy to use IDE which let's you upload your code and debug it during runtime.

Note that I don't use the ESPlorer builtin editor to write my source code. In the Settings tab I've selected "Use external editor" and then manage my Lua files with my favorite text editor. The downside is that I have to remember to click the "Reload" icon for each modified file before uploading it to the NodeMCU microcontroller.
