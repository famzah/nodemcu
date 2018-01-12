function setup_wifi(station_config, success_callback)
	print("WiFi: Apply configuration")

	wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
		wifi_ok = false
		print("\nWIFI - CONNECTED".."\nSSID: "..T.SSID.."\nBSSID: "..T.BSSID.."\nChannel: "..T.channel)
	end)

	wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
		wifi_ok = false
		print("\nWIFI - DISCONNECTED".."\nSSID: "..T.SSID.."\nBSSID: "..T.BSSID.."\nreason: "..T.reason)
	end)

	wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T)
		print("\nWIFI - AUTHMODE CHANGE".."\nold_auth_mode: "..T.old_auth_mode.."\nnew_auth_mode: "..T.new_auth_mode)
	end)

	wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
		wifi_ok = true
		print("\nWIFI - GOT IP".."\nStation IP: "..T.IP.."\nSubnet mask: "..T.netmask.."\nGateway IP: "..T.gateway)
		node.task.post(success_callback)
	end)

	wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function()
		wifi_ok = false
		print("\nWIFI - DHCP TIMEOUT")
	end)
	
	wifi.setmode(wifi.STATION)
	wifi.sta.config(station_config)
end
