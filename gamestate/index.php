<?php
echo "fetched!";
$postdata = json_decode(file_get_contents("php://input"), true);
$CTScore = $postdata['map']['team_ct']['score'];
$TScore = $postdata['map']['team_t']['score'];
$currentTeam = $postdata['player']['team'];
$phase = $postdata['round']['phase']; //freezetime / live
$roundKills = $postdata['player']['state']['round_kills'];
$warmup = $postdata['map']['phase'];
$kills = $postdata['player']['match_stats']['kills'];
if($kills == 0)
	return;

file_put_contents("php://stdout", print_r($postdata, 1));
file_put_contents("php://stdout", "\nCTScore: $CTScore");
file_put_contents("php://stdout", "\nTScore: $TScore");
file_put_contents("php://stdout", "\nCurrentTeam: $currentTeam");
file_put_contents("php://stdout", "\nPhase: $phase");

file_put_contents("php://stdout", "\n");

file_put_contents("output.txt", "$CTScore\r\n$TScore\r\n$currentTeam\r\n$phase\r\n$warmup");