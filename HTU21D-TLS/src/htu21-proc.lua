function htu21_request_data(reg, alarm_id, callback)
	local res
	
	i2c.start(0)
	res = i2c.address(0, config["sensor"]["sensor_addr"], i2c.TRANSMITTER)
	if not res then
		print("i2c.address.TX: got no ACK")
	end
	i2c.write(0, reg)
	i2c.stop(0)
	
	i2c.start(0)
	res = i2c.address(0, config["sensor"]["sensor_addr"], i2c.RECEIVER)
	if not res then
		print("i2c.address.RX: got no ACK")
	end
	
	tmr.alarm(alarm_id, 50, tmr.ALARM_SINGLE, function() -- wait for measurment
		local r = i2c.read(0, 3)
		i2c.stop(0)
		
		callback(r)
	end)
end

function htu21_request_temp(callback)
	htu21_request_data(config["sensor"]["temp_reg"], 0, function(r)
		-- this HTU21D I2C implementation is based on source code by pavel.janko@fancon.cz
		temp_value = (bit.band((bit.lshift(string.byte(r,1),8)+string.byte(r,2)),0xfffc)*17572)/65536-4685
		temp_value = temp_value / 100
		
		node.task.post(callback)
	end)
end

function htu21_request_humi(callback)
	htu21_request_data(config["sensor"]["humi_reg"], 0, function(r)
		-- this HTU21D I2C implementation is based on source code by pavel.janko@fancon.cz
		humi_value = (bit.band((bit.lshift(string.byte(r,1),8)+string.byte(r,2)),0xfffc)*12500)/65536-600
		humi_value = humi_value / 100
	
		node.task.post(callback)
	end)
end