extends Control

const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

func _ready():
	$HTTPGetLeaderboard.request(
		"https://lectrina.dk/leaderboard/getleaderboard.php",
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + get_parent().token,
		],
		false
	);


func on_leaderboard_response(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(body.get_string_from_utf8());
		print("JSON failed: ", response.error_string);
		return;
	
	response = response.result
	
	for i in range(len(response["leaderboard"])):
		var entry = response["leaderboard"][i]
		var leaderboard_entry = load("res://Scenes/LeaderboardEntry.tscn").instance()
		
		leaderboard_entry.set_entry(i+1, entry["username"], entry["exp"])
		$VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer.add_child(leaderboard_entry)
