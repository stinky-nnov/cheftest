<html><head><title>Вах!</title></head>
<body>
<img src="/chef-logo.jpg"><br><br>

<?php

session_start();

$sid = session_id();

echo "Session: ".$sid."<hr>";

date_default_timezone_set('GMT');
$db = new PDO ( 'mysql:host=sql1;dbname=example', 'webuser', 'webuser' );
//$db->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING ); // При оттадке
$db->query ( 'SET character_set_connection = utf8;' );
$db->query ( 'SET character_set_client = utf8;' );
$db->query ( 'SET character_set_results = utf8;' );

$alsos = $db->query('select * from `pathlogs` where `id`="'.$sid.'" ')->fetchAll(PDO::FETCH_ASSOC);
$backs = array();
foreach ($alsos as $also) {
    $backs = explode('|', $also['path']);
    
    foreach ($backs as $back) {
	echo $back.'<br/>';
    }
}


// phpinfo();
$host= gethostname();
//$ip = gethostbynamel($host);

$backs[] = $host;

$db->query('insert into `pathlogs` (`id`, `path`) values ("'.$sid.'", "'.implode('|',$backs).'") ON DUPLICATE KEY UPDATE `path`="'.implode('|',$backs).'"');

echo $host.' + <br/>';

?>
</body></html>