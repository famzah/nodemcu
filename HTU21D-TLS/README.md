# Description

This NodeMCU Lua project measures temperature and humidity using a HTU21D sensor,
and then submits the data over HTTPS to a web server. Local Internet connectivity
is provided by a WiFi connection.

# Firmware

You need to use a custom firmware with the following modules:
```
bit
file
gpio
i2c
net
node
tmr
uart
wifi

+TLS
```

# Wiring

You need to wire only the following:
- NodeMCU power supply - either directly at the USB connector, or use the appropriate pins
- the HTU21D sensor - the "config.lua" shows where to connect the SDA and SCL pins; additionally
you need to connect GND and 3.3V to the sensor, in order to power it up

# Source code upload order

First upload all files but skip "main.lua" and "init.lua". Then upload "main.lua", wait to see if all
works properly and reset the chip. Finally, upload "init.lua" which will auto-start "main.lua"
on every chip reset or repower.

# Security

Your data is not secure and could be intercepted by someone else. Luckily, since we
are transmitting only the temperature and humidity values in some room, this shouldn't be
a huge security issue.

--

Even though the web request is done via SSL, I couldn't get NodeMCU to verify the remote
server's SSL certificate (which requires a lot of RAM, computational power, an accurate
clock, and a bugfree reliable SSL library). Therefore, you're protected against simple
man-in-the-middle sniffing activity but if the attacker controls your one of the routers
in your connection, your data is not secured.

Additionally, WiFi itself is not very secure either (even not only on NodeMCU). First, there was
a recent WPA2 attack known as [KRACK](https://www.krackattacks.com/) which attacks the clients of
a WiFi network. I'm not sure whether NodeMCU is patched against this, yet. Second, someone
in close physical proximity can announce the same WiFi network SSID as yours which would trick
NodeMCU (and other WiFi clients) to connect to this rogue WiFi AP. This WiFi can become an
active man-in-the-middle which is a problem when the SSL certificate is not verified properly
(see the previous paragraph).

# Web server

The environment data is transmitted every minute to a remote web server via
a standard GET HTTP request. You can review my [sample PHP script](web-server/temphumi.php)
which handles the input, but most probably you will write your own.
