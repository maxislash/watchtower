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

  $id=$_GET["id"];
  $luminosity=$_GET["luminosity"];
  $temperature=$_GET["temperature"];
  $x=$_GET["x"];
  $y=$_GET["y"];
  $z=$_GET["z"];
  $alert=$_GET["alert"];
  //$query = "INSERT INTO `tutorial_database`.`sensors` (`timeStamp`, `id`, `luminosity`, `temperature`, `x`, `y`, `z`, `alert`)
  //VALUES (CURRENT_TIMESTAMP, '".$id."','".$luminosity."','".$temperature."','".$x."','".$y."','".$z."','".$alert."')";

  // code to insert new record
  /* Prepared statement, stage 1: prepare */
  if (!($stmt = $link->prepare("INSERT INTO sensor(timeStamp, id, luminosity, temperature, x, y, z, alert) VALUES (CURRENT_TIMESTAMP,?,?,?,?,?,?,?)"))) {
    echo "Prepare failed: (" . $stmt->errno . ") " . $stmt->error;
  }
  // prepared statements will not accept literals (pass by reference) in bind_params, you need to declare variables
  $stmt->bind_param("iidiiii",$id,$luminosity,$temperature,$x,$y,$z,$alert);

  if (!$stmt->execute()) {
    echo "Execute failed: (" . $stmt->errno . ") " . $stmt->error;
  }

  //printf("%d Row inserted.\n", $stmt->affected_rows);


  /* explicit close recommended */
  $stmt->close();


  //mysql_query($query,$link);
  //mysql_close($link);
  $link->close();

// Send SNS notification to the customer of succeess.
       $sns = new Aws\Sns\SnsClient([
          'version' => 'latest',
          'region'  => 'us-west-2'
       ]);

       $snsresult = $sns->listTopics([
       ]);
       $topicArn = $snsresult['Topics'][0]['TopicArn'];


$message = "Breach door " . $id . "\n" . "luminosity =" . $luminosity
. "\n" . "temperature =" . $temperature;

       $sns->publish([
         'TopicArn' => $topicArn,
         'Message' => $message
       ]);

  header("Location: read.php");

?>
