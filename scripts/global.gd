extends Node

signal healthChanged

var gameover = false
var play_endgame_music = true

var player_health = 100
var player_speed = 150
var player_strength = 20

var player_current_attack = false

var enemy_goblin_blue_health = 100
var enemy_goblin_blue_speed = 40
var enemy_goblin_blue_damage = 20

var enemy_goblin_red_health = 200
var enemy_goblin_red_speed = 60
var enemy_goblin_red_damage = 10

var enemy_goblin_purple_health = 60
var enemy_goblin_purple_speed = 50
var enemy_goblin_purple_damage = 40

var killed_enemies = 0

func update_player_health(value, ud):
	if ud == "heal":
		if player_health < 1000:
			player_health += value
	else:
		player_health -= value
	healthChanged.emit()

func update_score(enemy_kind, exploaded):
	killed_enemies += 1
	update_player_speed()
	update_player_strength()
	if enemy_kind == "BLUE":
		if !exploaded:
			update_player_health(20, "heal")
	elif enemy_kind == "PURPLE":
		update_player_health(10, "heal")
	elif enemy_kind == "RED":
		update_player_health(30, "heal")

func update_player_speed():
	player_speed += 2

func update_player_strength():
	player_strength += 0.5

func random_enemy_count():
	randomize()
	var amount = (randi() % 3) + 1
	return amount
	
func reset_game():
	gameover = false
	player_health = 100
	player_speed = 150
	player_strength = 20
	killed_enemies = 0
