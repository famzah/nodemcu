<?php
function assert_is_float($id, $s) {
	if (!preg_match('/^\d{1,4}(\.\d{1,32})?$/', $s)) {
		throw new Exception("Bad $id: $s");
	}
}

if (!in_array($_SERVER['REMOTE_ADDR'], array('x.x.x.x'))) {
	throw new Exception("Unauthorized IP address: ".$_SERVER['REMOTE_ADDR']);
}

$dev_id = $_GET['dev_id'];
if (!preg_match('/^[a-z0-9:\-]{3,64}$/', $dev_id)) {
	throw new Exception("Bad dev_id: $dev_id");
}

$temp = $_GET['temperature'];
assert_is_float('temp', $temp);

$humi = $_GET['humidity'];
assert_is_float('humi', $humi);

$rrdfile = "/var/lib/www-data/iot/temphumi/$dev_id.rrd";
if (!file_exists($rrdfile)) {
	$hbeat = 70;
	$rdef = array(
		'--step', '60',
		'DS:temp:GAUGE:'.$hbeat.':-40:100',
		'DS:humi:GAUGE:'.$hbeat.':0:100',
		'RRA:AVERAGE:0.5:1:10080',
	);

	$d = array(
		5 => 8928,
		30 => 8928,
		60 => 89280,
	);
	foreach ($d as $kt => $vt) {
		foreach (array('AVERAGE', 'MIN', 'MAX') as $func) {
			$rdef[] = sprintf('RRA:%s:0.5:%d:%d', $func, $kt, $vt);
		}
	}

	if (!rrd_create($rrdfile, $rdef)) {
		throw new Exception("rrd_create($rrdfile): failed");
	}
}

if (!rrd_update($rrdfile, array(sprintf('N:%s:%s', $temp, $humi)))) {
	throw new Exception("rrd_update($rrdfile): failed");
}

echo "OK\n";
