extends Control

@onready var menu = $Pause_options
@onready var options = $Settings
@onready var world = get_node("/root/world")

func _on_resume_pressed():
	world.pauseMenu()

func _on_settings_pressed():
	show_and_hide(options, menu)

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_exit_pressed():
	world.resetPause()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	Global.reset_game()

func _on_back_button_pressed():
	show_and_hide(menu, options)

func _on_music_value_changed(value):
	volume(1, value)

func _on_sounds_value_changed(value):
	volume(2, value)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
