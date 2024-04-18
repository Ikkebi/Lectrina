extends Node2D
var HomeScreen : Control
var Training : Control
var Books : Control
var Leaderboard : Control
var Profile : Control

var HomeNav : Button
var TrainingNav : Button
var BooksNav : Button
var LeaderboardNav : Button
var ProfileNav : Button

var token : String;
var streak : int;
var active_book_id : int

var http : HTTPClient;

const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";

func _ready():
	http = HTTPClient.new();
	
	$TopBar/Streak.text = str(streak);
	
	# Load the references to the menu scenes
	HomeScreen = get_node("HomeScreen")
	Training = get_node("Training")
	Books = get_node("Books")
	Leaderboard = get_node("Leaderboard")
	Profile = get_node("Profile")
	
	HomeNav = get_node("NavBar/HomeNav")
	TrainingNav = get_node("NavBar/TrainingNav")
	BooksNav = get_node("NavBar/BooksNav")
	LeaderboardNav = get_node("NavBar/LeaderboardNav")
	ProfileNav = get_node("NavBar/ProfileNav")
	
	# Initially hide all scenes except the home scene
	_on_HomeNav_pressed()
	
	load_book(active_book_id)

func hide_all_scenes():
	HomeScreen.visible = false
	Training.visible = false
	Books.visible = false
	Leaderboard.visible = false
	Profile.visible = false
	
	HomeNav.disabled = false
	TrainingNav.disabled = false
	BooksNav.disabled = false
	LeaderboardNav.disabled = false
	ProfileNav.disabled = false

func _on_HomeNav_pressed():
	hide_all_scenes()
	HomeNav.disabled = true
	HomeScreen.visible = true

func _on_TrainingNav_pressed():
	hide_all_scenes()
	TrainingNav.disabled = true
	Training.visible = true

func _on_BooksNav_pressed():
	hide_all_scenes()
	BooksNav.disabled = true
	Books.visible = true

func _on_LeaderboardNav_pressed():
	hide_all_scenes()
	LeaderboardNav.disabled = true
	Leaderboard.visible = true

func _on_ProfileNav_pressed():
	hide_all_scenes()
	ProfileNav.disabled = true
	Profile.visible = true

func load_book(book_id: int):
	$HTTPGetBook.request(
		"https://lectrina.dk/books/getbook.php?book_id=" + str(book_id),
		[
			"User-Agent: " + USER_AGENT,
			"X-Token: " + token,
		],
		false
	);



func on_load_book_request(result, response_code, headers, body):
	var response = JSON.parse(body.get_string_from_utf8());
	
	if (response.error):
		# TODO; Show error
		print(body.get_string_from_utf8());
		print("JSON failed: ", response.error_string);
		return;
	
	response = response.result;

	$TopBar/BookName.text = response["name"]
	
	var default_icon = preload("res://Scenes/temp (filtrer gennem inden aflevering for ubrugte assets)/ChapterButton.png")
	var completed_icon = preload("res://Scenes/temp (filtrer gennem inden aflevering for ubrugte assets)/ChapterButtonCompleted.png")
	
	for i in range(20):
		var btn: Button = get_node("HomeScreen/ScrollContainer/GridContainer/Chapter"+str(i+1))
		if btn.is_connected("pressed", self, "on_chapter_pressed"):
			btn.disconnect("pressed", self, "on_chapter_pressed")
	
	for i in range(len(response["chapters"])):
		var btn: Button = get_node("HomeScreen/ScrollContainer/GridContainer/Chapter"+str(i+1))
		var chapter = response["chapters"][i]
		btn.connect("pressed", self, "on_chapter_pressed", [chapter["id"]])
		if chapter["completed"]:
			btn.icon = completed_icon
		else:
			btn.icon = default_icon

func on_chapter_pressed(chapter_id):
	$Reading.start_reading(chapter_id)

func chapter_completed(new_streak):
	if new_streak != null:
		self.streak = new_streak
		$TopBar/Streak.text = str(self.streak)
	
	load_book(active_book_id)
	$Reading.hide()
