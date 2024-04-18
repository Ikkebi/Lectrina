extends Control

var assignment : Dictionary
var chapter_id : int

const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

func _on_Exit_pressed():
	self.hide()

func start_reading(chapter_id):
	self.chapter_id = chapter_id
	$HTTPGetChapter.request(
		"https://lectrina.dk/books/getchapter.php?chapter_id=" + str(chapter_id),
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + get_parent().token,
		],
		false
	);

func on_chapter_loaded(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(body.get_string_from_utf8());
		print("JSON failed: ", response.error_string);
		return;
	
	response = response.result;

	print(response)

	var chapter = response["chapter"]
	self.assignment = response["assignment"]

	$ScrollContainer/HBoxContainer/VBoxContainer/Title.bbcode_text = "[center]" + chapter["name"] + "[/center]"
	$ScrollContainer/HBoxContainer/VBoxContainer/Text.bbcode_text = "[fill]" + chapter["content"] + "[/fill]"
	
	$ChapterAssignment.hide()
	self.show()


func on_finish_reading():
	$ChapterAssignment.start_assignment(assignment)

func finish_chapter():
	# Finish current chapter
	$HTTPCompleteChapter.request(
		"https://lectrina.dk/books/completechapter.php?chapter_id=" + str(chapter_id),
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + get_parent().token,
		],
		false
	);

func on_complete_chapter_response(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());

	if (response.error):
		# TODO; Show error
		print(body.get_string_from_utf8());
		print("JSON failed: ", response.error_string);
		return;

	response = response.result;
	
	get_parent().chapter_completed(response["new_streak"])
