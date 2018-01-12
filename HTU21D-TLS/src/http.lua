function report_over_http(temp, humi, http_config, wf_callback)
	print("Temperature: "..temp.." *C")
	print("Humidity   : "..humi.." %")
	print("")

	net.cert.verify(false) -- out-of-memory issues :( very hard to get running: https://github.com/nodemcu/nodemcu-firmware/issues/1707
	local connection = net.createConnection(net.TCP, 1) -- secure connection
	
	local function tear_down(socket, got_timeout)
		if connection == nil then -- if already closed (due to a timeout or another socket handler)
			return
		end
		
		print("HTTP: close connection // tear_down()")
		socket:close()
		
		if got_timeout then
			-- fix a memory leak by calling this internal function
			-- the leak happens when the connection to the server times out
			-- __gc -> LFUNCVAL( net_socket_delete ) in "nodemcu-firmware/blob/1.5.4.1-final/app/modules/net.c"
			connection:__gc()
		end
		
		connection = nil
		
		node.task.post(wf_callback)
	end
	
	connection:on("connection", function(socket)
		print("HTTP event: connection established")
		socket:send(
			'GET '..http_config["uri"]..
				'?dev_id='..wifi.sta.getmac()..
				'&temperature='..temp..
				'&humidity='..humi..
				' HTTP/1.1\r\n'..
			'Host: '..http_config["vhost"]..'\r\n'..
			'Accept: */*\r\n'..
			'User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n'..
			'\r\n'
		)
	end)

	connection:on("sent", function(socket)
		print("HTTP event: data sent")
		--tear_down(socket, false) -- wait for the HTTP reply, in order to show it as debug info below
	end)

	connection:on("receive", function(socket, payload)
		print("HTTP event: received data")
		print("HTTP received payload:\n"..payload)
		tear_down(socket, false)
	end)

	connection:on("disconnection", function(socket)
		print("HTTP event: disconnection")
		tear_down(socket, false)
	end)

	print("HTTP: sending data to https://"..http_config["vhost"]..http_config["uri"])
	connection:connect(443, http_config["vhost"])
	
	tmr.alarm(1, 5*1000, tmr.ALARM_SINGLE, function() -- HTTP transfer timeout
		if connection ~= nil then -- if not already closed
			print("HTTP event: transfer timeout; force close")
			tear_down(connection, true)
		end
	end)
end