extends Control

@onready var world = get_node("/root/world")

func _ready():
	world.end_game.connect(play_end_game)

func play_end_game():
	if Global.play_endgame_music:
		$Gameover.play()
		Global.play_endgame_music = false

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	Engine.time_scale = 1
	Global.reset_game()
