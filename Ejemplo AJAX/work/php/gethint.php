<?php
	$file = fopen("../resources/hints.txt", "r") 
	        or exit("Unable to open file!");
	//Output a line of the file until the end is reached
	while(!feof($file)){
	  $a[]=fgets($file);
	}
	fclose($file);

	//get the q parameter from URL

	if(isset($_GET["q"])){
	   $q=$_GET["q"];
	}
	else {$q="";}
	$hint="";
	//lookup all hints from array if length of q>0
	if (strlen($q) > 0){
	  
	  for($i=0; $i<count($a); $i++){
		$str = str_replace(PHP_EOL, '', $a[$i]);
		if (strtolower($q)==strtolower(substr($str, 0, strlen($q)))){
		  if ($hint==""){
			$hint='"'.$str.'"';
		  } else {
			$hint=$hint.' , "'.$str.'"';
		  }
		}
	  }
	}
	// Set output to "no suggestion" if no hint were found
	// or to the correct values
	header('Content-type: application/json');
	if ($hint == ""){
	  $response='{"hints":["no suggestion"]}';
	}else {
	    $response='{"hints":['.$hint.']}';
	}

	//output the response
	echo $response;
?>