<?php
	$id = $_GET['id'];
	require('simple_html_dom.php');
	if($id == 1)
		$html = file_get_html("http://steamcommunity.com/id/profile_one"); // #1
	else
		$html = file_get_html("http://steamcommunity.com/id/profile_two"); // #6
	//echo $html;
	
	echo $html->find("a.btn_green_white_innerfade", 0)->href;
	
?>