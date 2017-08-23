<?php

   require 'vendor/autoload.php';

   use Aws\Rds\RdsClient;
   $client = RdsClient::factory(array(
        'version' => 'latest',
        'region'  => 'us-west-2'
   ));

   $result = $client->describeDBInstances(array(
        'DBInstanceIdentifier' => 'db-nighters',
   ));

   $endpoint = $result->search('DBInstances[0].Endpoint.Address');

   $link = mysqli_connect($endpoint,"nighter","nighter-password","nighters") or die("Error " . mysqli_error($link));

   /* check connection */
   if (mysqli_connect_errno()) {
       printf("Connect failed: %s\n", mysqli_connect_error());
       exit();
   }


  $create_table = 'CREATE TABLE IF NOT EXISTS sensor 
    (
        timeStamp TIMESTAMP NOT NULL PRIMARY KEY,
        id int(2) NOT NULL,
        luminosity int(4) NOT NULL,
        temperature float(5,2) NOT NULL,
        x int(4) NOT NULL,
        y int(4) NOT NULL,
        z int(4) NOT NULL,
        alert int(2) NOT NULL
    )';

   $create_tbl = $link->query($create_table);
   if ($create_table) {
        echo "\n Table has created \n";
   }
   else {
       // echo "error creation table!";
   }

   $link->close();
?>
