extends Control

const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

func _ready():
	$HTTPGetStats.request(
		"https://lectrina.dk/user/getstats.php",
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + get_parent().token,
		],
		false
	);


func on_stats_response(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(body.get_string_from_utf8());
		print("JSON failed: ", response.error_string);
		return;
	
	var stats = response.result["stats"]
	
	$StatLabels/BooksReadStat.text = str(stats["books_read"])
	$StatLabels/ChaptersReadStat.text = str(stats["chapters_read"])
	$StatLabels/StreakStat.text = str(stats["streak"])
	$StatLabels/xpStat.text = str(stats["exp"])
	$StatLabels/TasksCompletedStat.text = str(stats["assignments_completed"])
	$StatLabels/AverageChaptersDailyStat.text = str(stats["chapters_per_day"])
	
