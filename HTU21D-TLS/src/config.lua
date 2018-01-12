config = {}

config["wifi"] = {}
config["wifi"]["ssid"] = "%your-wireless-ssid%"
config["wifi"]["pwd"]  = "%your-wireless-password%"
config["wifi"]["setup_timeout"] = 15 -- seconds

config["reading_loop_sleep"] = 60  -- period reading and sending sensors in seconds

config["sensor"] = {}
config["sensor"]["sda"] = 3 -- GPIO0 (pin D3) -- connect to SDA pin of HTU21
config["sensor"]["scl"] = 4 -- GPIO2 (pin D4) -- connect to SCL pin of HTU21
config["sensor"]["sensor_addr"] = 0x40 -- HTU21 I2C address
config["sensor"]["humi_reg"] = 0xE5 -- HTU21 humidity register address
config["sensor"]["temp_reg"] = 0xE3 -- HTU21 temperature register address

config["http_server"] = {}
config["http_server"]["vhost"] = "www.example.com"
config["http_server"]["uri"] = "/iot-submit/temphumi.php"
