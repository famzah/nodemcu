dofile("config.lua")
dofile("wifi.lua")
dofile("htu21-proc.lua")
dofile("watchdogs.lua")
dofile("http.lua")

function wf_start()
	if not wf_init_done then
		wf_init_done = true
		print("\nStarting the workflow loop\n")		
		i2c.setup(0, config["sensor"]["sda"], config["sensor"]["scl"], i2c.SLOW)		
	end

	temp_value = -999 -- global; populated by htu21_request_temp()
	humi_value = -999 -- global; populated by htu21_request_humi()
	program_timeouts = 0 -- reset watchdog
	node.task.post(wf_req_temp)
end
function wf_req_temp()
	htu21_request_temp(wf_got_temp)
end
function wf_got_temp()
	node.task.post(wf_req_humi)
end
function wf_req_humi()
	htu21_request_humi(wf_got_humi)
end
function wf_got_humi()
	node.task.post(wf_req_report)
end
function wf_req_report()
	report_over_http(temp_value, humi_value, config["http_server"], wf_end)
end
function wf_end()
	print("\nWorkflow end; sleeping and starting over\n")
	
	-- debug memory leaks
	--for k,v in pairs(debug.getregistry()) do print (k,v) end
	
	-- sleep and start again
	tmr.alarm(0, config["reading_loop_sleep"]*1000, tmr.ALARM_SINGLE, wf_start)
end

wifi_ok = false -- updated by the WiFi monitor callback handlers
wf_init_done = false
setup_wifi(config["wifi"], wf_start) -- starts the workflow on successful connect

-- Watchdogs (Timer #6)
wifi_bad_checks = 0
program_timeouts = 0
tmr.alarm(6, 1*1000, tmr.ALARM_AUTO, watchdogs)