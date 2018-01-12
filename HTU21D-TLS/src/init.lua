print("Device starting in 3 seconds...")
tmr.alarm(0, 3*1000, tmr.ALARM_SINGLE, function()
	dofile("main.lua")
end) -- start with some delay
