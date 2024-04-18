extends Control

# Declare member variables here. Examples:
var http : HTTPRequest;
var httpclient : HTTPClient;
var username : LineEdit;
var password : LineEdit;

# Simply er nogen adems så vi skal fake UA
const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

# Called when the node enters the scene tree for the first time.
func _ready():
	http = get_node("HTTPRequest");
	http.connect("request_completed", self, "_on_request_complete");
	httpclient = HTTPClient.new();
	
	username = get_node("ColorRect/VBoxContainer/Username");
	password = get_node("ColorRect/VBoxContainer/Password");


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LoginButton_pressed():
	var request_data = httpclient.query_string_from_dict({
		#"username": username.text,
		"username": "varbil",
		#"password": password.text
		"password": "studios",
	});

	http.request(
		"https://lectrina.dk/user/login.php",
		[
			"User-Agent: " + USER_AGENT,
			"Content-Type: application/x-www-form-urlencoded"
		],
		false,
		HTTPClient.METHOD_POST,
		request_data
	);

func _on_request_complete(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(response.error_string);
		return;
	
	response = response.result;
	
	print("Login data: ", response)
	
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
	get_tree().root.add_child(mainscene);
	get_tree().current_scene.queue_free()
