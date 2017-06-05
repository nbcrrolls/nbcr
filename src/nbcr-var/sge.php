<?php
/* Script form rocks mailing list. Displays SGE nodes (qhost -xml), 
   the queue (qstat -u '*' -g c -xml) and running jobs (qstat -u '*' -ext -xml).
*/
putenv("SGE_ROOT=/opt/gridengine");
putenv("SGE_QMASTER_PORT=536");
putenv("SGE_EXECD_PORT=537");

$cfgSGEBin = "/opt/gridengine/bin/linux-x64/";

/* Run qhost, output as xml and store the result */
$command = $cfgSGEBin."qhost -xml";
$output = shell_exec($command);
$xml = simplexml_load_string($output);
$output = NULL;
echo "<div class='well'>";
/* Look for available hosts */
if (isset($xml->host)) {
    /* We have running nodes */
    echo "<p>Node overview:</p>";
    echo "<table cellspacing='2' cellpadding='2'><thead><tr><th>Hostname</th><th>Cores</th><th>Load average</th><th>Used memory</th><th>Total memory</th></tr></thead><tbody>";
    foreach ($xml->host as $host_list) {
    	if ($host_list->attributes()->name != "global") {
			echo
"<tr><td>".$host_list->attributes()->name."</td><td>".$host_list->hostvalue[1]."</td><td>".$host_list->hostvalue[2]."</td><td>".$host_list->hostvalue[4]."</td><td>".$host_list->hostvalue[3]."</td><tr>";
		}
    }
    echo "</tbody></table><br>";
} else {
	echo "No hosts found<br>";
}

/* Run qstat to find queue info, output as xml and store the result */
$command = $cfgSGEBin."qstat -u '*' -g c -xml";
$output = shell_exec($command);
$xml = simplexml_load_string($output);
$output = NULL;

/* Look for queued jobs */
if (isset($xml->cluster_queue_summary)) {
    echo "<p>Queue overview:</p>";
    echo "<table cellspacing='2' cellpadding='2'><thead><tr><th>Queue name</th><th>Slots used</th><th>Slots available</th><th>Slots total</th><th>Unavailable</th></tr></thead><tbody>";
    foreach ($xml->cluster_queue_summary as $queue_list) {
		echo "<tr><td>".$queue_list->name."</td><td>".$queue_list->used."</td><td>".$queue_list->available."</td><td>".$queue_list->total."</td><td>".$queue_list->manual_intervention."</td><tr>";
    }
    echo "</tbody></table><br>";
} else {
	echo "No queues found<br>";
}

/* Run qstat, output as xml and store the result */
$command = $cfgSGEBin."qstat -u '*' -ext -xml";
$output = shell_exec($command);
$xml = simplexml_load_string($output);
$output = NULL;

/* Look for queued jobs */
if (isset($xml->queue_info->job_list) || isset($xml->job_info->job_list)) {
    echo "<p>Queued jobs:</p>";
    /* We have queued jobs */
    echo "<table cellspacing='2' cellpadding='2'><thead><tr><th>Job state</th><th>Job id</th><th>Used slots</th><th>Job name</th><th>Queue</th></tr></thead><tbody>";
    foreach ($xml->queue_info->job_list as $job_list) {
	echo "<tr><td>".$job_list->attributes()->state."</td><td>".$job_list->JB_job_number."</td><td>".$job_list->slots."</td><td>".$job_list->JB_name."</td><td>".$job_list->queue_name."</td><tr>";
    }
    foreach ($xml->job_info->job_list as $job_list) {
	echo "<tr><td>".$job_list->attributes()->state."</td><td>".$job_list->JB_job_number."</td><td>".$job_list->slots."</td><td>".$job_list->JB_name."</td><td>".$job_list->queue_name."</td><tr>";
    }
    echo "</tbody></table>";
}

echo "</div>";
?>
