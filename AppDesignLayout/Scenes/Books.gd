extends Control

const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPGetBooks.request(
		"https://lectrina.dk/books/getbooks.php",
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + get_parent().token,
		],
		false
	);

func get_books_response(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(body.get_string_from_utf8());
		print("JSON failed: ", response.error_string);
		return;
	
	response = response.result;

	var texture = load("res://Scenes/temp (filtrer gennem inden aflevering for ubrugte assets)/BookCover.png")

	for book in response["books"]:
		var texture_rect = TextureRect.new()
		texture_rect.texture = texture
		
		var texture_button = TextureButton.new()
		
		texture_button.connect("pressed", self, "on_book_change", [book["id"]])
		
		texture_button.expand = true
		texture_button.anchor_top = 0
		texture_button.anchor_bottom = 1
		texture_button.anchor_left = 0
		texture_button.anchor_right = 1
		
		texture_rect.add_child(texture_button)
		$ScrollContainer/HBoxContainer/VBoxContainer/GridContainer.add_child(texture_rect)
		
		if not book["cover_url"]:
			# Burde ikke ske
			continue
		
		var request = HTTPRequest.new()
		add_child(request)
		
		request.connect("request_completed", self, "on_book_cover_response", [texture_button])
		
		request.request(
			book["cover_url"],
			[
				"User-Agent: " + USER_AGENT,
			],
			false
		);

func on_book_cover_response(result, response_code, headers, body, texture_button):
	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	texture_button.texture_normal = texture

func on_book_change(book_id):
	if $HTTPChangeBook.is_connected("request_completed", self, "on_change_book_response"):
		$HTTPChangeBook.disconnect("request_completed", self, "on_change_book_response")
	
	$HTTPChangeBook.connect("request_completed", self, "on_change_book_response", [book_id])
	
	$HTTPChangeBook.request(
		"https://lectrina.dk/user/selectbook.php?book_id=" + str(book_id),
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + get_parent().token,
		],
		false
	);


func on_change_book_response(result, response_code, headers, body, book_id):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(body.get_string_from_utf8());
		print("JSON failed: ", response.error_string);
		return;
	
	get_parent().load_book(book_id)
	get_parent()._on_HomeNav_pressed()
