extends Control

# Declare member variables here. Examples:
var http : HTTPRequest;
var httpclient : HTTPClient;

# Simply er nogen adems så vi skal fake UA
const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

# Called when the node enters the scene tree for the first time.
func _ready():
	httpclient = HTTPClient.new();

func on_login_pressed():
	var request_data = httpclient.query_string_from_dict({
		"username": $ColorRect/VBoxContainer/Username.text,
		"password": $ColorRect/VBoxContainer/Password.text
	});

	$HTTPLoginRequest.request(
		"https://lectrina.dk/user/login.php",
		[
			"User-Agent: " + USER_AGENT,
			"Content-Type: application/x-www-form-urlencoded"
		],
		false,
		HTTPClient.METHOD_POST,
		request_data
	);

func on_register_pressed():
	var request_data = httpclient.query_string_from_dict({
		"username": $ColorRect/VBoxContainer/Username.text,
		"password": $ColorRect/VBoxContainer/Password.text
	});

	$HTTPRegisterRequest.request(
		"https://lectrina.dk/user/register.php",
		[
			"User-Agent: " + USER_AGENT,
			"Content-Type: application/x-www-form-urlencoded"
		],
		false,
		HTTPClient.METHOD_POST,
		request_data
	);

func on_login_response(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(response.error_string);
		print(body.get_string_from_utf8())
		return;
	
	response = response.result;

	switch_scene(
		response["token"],
		response["streak"],
		response["active_book_id"]
	);

func switch_scene(token, streak, active_book_id):
	var mainscene = preload("res://Scenes/Lectrina.tscn").instance();
	mainscene.token = token;
	mainscene.streak = streak;
	mainscene.active_book_id = active_book_id;
	get_tree().root.add_child(mainscene)
	get_tree().current_scene.queue_free()

func on_register_response(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(response.error_string);
		print(body.get_string_from_utf8())
		return;
	
	print("Register success: ", response.result["status"])


