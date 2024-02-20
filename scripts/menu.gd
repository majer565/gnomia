extends Control

@onready var menu = $Main_menu
@onready var options = $Settings

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	Global.play_endgame_music = true

func _on_settings_pressed():
	show_and_hide(options, menu)

func _on_quit_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	show_and_hide(menu, options)

func show_and_hide(first, second):
	first.show()
	second.hide()

func _on_sounds_value_changed(value):
	volume(2, value)

func _on_music_value_changed(value):
	volume(1, value)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
