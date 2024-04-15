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

func _ready():
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
