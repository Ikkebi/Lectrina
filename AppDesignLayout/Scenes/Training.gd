extends Control

const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

var active_assignment = null;
var loading_assignment = false;

func _ready():
	get_new_assignment()

func get_new_assignment():
	loading_assignment = true;
	$HTTPGetAssignment.request(
		"https://lectrina.dk/assignments/getassignment.php",
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + get_parent().token,
		],
		false
	);

func on_assignment_response(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(body.get_string_from_utf8());
		print("JSON failed: ", response.error_string);
		return;
	
	response = response.result
	
	active_assignment = response["assignment"]
	loading_assignment = false

	render_assignment()

func render_assignment():
	if not active_assignment:
		# Handle no assignment
		return
	
	$Question.text = active_assignment["question"]
	$Answer1.text = active_assignment["answer1"]
	$Answer2.text = active_assignment["answer2"]
	$Answer3.text = active_assignment["answer3"]
	$Answer4.text = active_assignment["answer4"]

func reset_assignment():
	active_assignment = null
	$Question.text = ""
	$Answer1.text = ""
	$Answer2.text = ""
	$Answer3.text = ""
	$Answer4.text = ""

func on_answer_pressed(selected_answer):
	if not active_assignment:
		$IndicatorLabel.text = "No more assignments available!"
		return;

	$ResetTextTimer.start(2)

	if selected_answer != active_assignment["correct_answer"]:
		$IndicatorLabel.text = "Incorrect!"
		return;
	
	$IndicatorLabel.text = "Correct!"
	
	loading_assignment = true;
	$HTTPCompleteAssignment.request(
		"https://lectrina.dk/assignments/completeassignment.php?assignment_id=" + str(active_assignment["id"]),
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + get_parent().token,
		],
		false
	);

	reset_assignment()

func on_assignment_complete_response(result, response_code, headers, body):
	get_new_assignment()


func on_reset_text_timeout():
	$IndicatorLabel.text = ""
	
	if not loading_assignment and not active_assignment:
		$IndicatorLabel.text = "No more assignments available!"
