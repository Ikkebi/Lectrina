extends Node2D
var HomeScreen : Control
var Training : Control
var Books : Control
var Leaderboard : Control
var Profile : Control

func _ready():
	# Load the references to the menu scenes
	HomeScreen = get_node("HomeScreen")
	Training = get_node("Training")
	Books = get_node("Books")
	Leaderboard = get_node("Leaderboard")
	Profile = get_node("Profile")
	
	# Initially hide all scenes except the home scene
	hide_all_scenes()
	HomeScreen.visible = true

func hide_all_scenes():
	HomeScreen.visible = false
	Training.visible = false
	Books.visible = false
	Leaderboard.visible = false
	Profile.visible = false

func _on_HomeNav_pressed():
	hide_all_scenes()
	HomeScreen.visible = true

func _on_TrainingNav_pressed():
	hide_all_scenes()
	Training.visible = true

func _on_BooksNav_pressed():
	hide_all_scenes()
	Books.visible = true

func _on_LeaderboardNav_pressed():
	hide_all_scenes()
	Leaderboard.visible = true

func _on_ProfileNav_pressed():
	hide_all_scenes()
	Profile.visible = true
