function watchdogs()
	if not wifi_ok then
		wifi_bad_checks = wifi_bad_checks + 1
		-- print("Bad WiFi check; total count is "..wifi_bad_checks)
		if wifi_bad_checks >= config["wifi"]["setup_timeout"] then
			print("Too many bad WiFi checks. Restarting...")
			node.restart()
		end
	else
		wifi_bad_checks = 0
	end
	
	program_timeouts = program_timeouts + 1
	if program_timeouts >= config["reading_loop_sleep"]*2 then
		print("Program stall detected! Restarting...")
		node.restart()
	end
end