extends Node2D

signal end_game

@onready var pause_menu = $CanvasLayer/Pause_menu
@onready var gameover_menu = $CanvasLayer/Gameover_menu

var paused = false

var goblin_red = preload("res://scenes/goblin_enemy_red.tscn")
var goblin_blue = preload("res://scenes/goblin_enemy_blue.tscn")
var goblin_purple = preload("res://scenes/goblin_enemy_purple.tscn")

var enemies = [goblin_red, goblin_blue, goblin_purple]

func _process(delta):
	if Input.is_action_just_pressed("pause") and !Global.gameover:
		pauseMenu()
	elif Global.gameover:
		gameoverMenu()

func gameoverMenu():
	gameover_menu.show()
	Engine.time_scale = 0
	$battle_music.stop()
	end_game.emit()

func _init():
	spawnEnemies(1)

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused

func resetPause():
	paused = false
	Engine.time_scale = 1

func spawnEnemies(amount):
	randomize()
	for n in amount:
		var index = randi() % enemies.size()
		var kinds = enemies[index]
		var enemy = kinds.instantiate()
		enemy.scale = Vector2(0.8, 0.8)
		enemy.position = Vector2(randi_range(10, 990), randi_range(10, 990))
		add_child(enemy)
