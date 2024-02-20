extends CharacterBody2D

enum STATE { IDLE, WALK }
enum DIRECTION {UP, DOWN, LEFT, RIGHT, NONE}

var enemy_in_attack_range = false
var is_player_alive = true
var can_be_hurt = true

var attack_in_progress = false

@onready var _character = get_node("Character")
@onready var world = get_node("/root/world")
@onready var sword_audio = $SwordAudio
@onready var hurt_audio = $HurtAudio

var current_state = STATE.IDLE
var current_dir = DIRECTION.NONE

func set_new_state(new_state):
	if new_state == self.current_state:
		return
	self.current_state = new_state
	
func set_new_direction(new_dir):
	if new_dir == self.current_dir:
		return
	self.current_dir = new_dir

func _ready():
	_character.play_animation(current_state, current_dir)

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	player_movement(delta, direction)
	attack()
	player_death()

func player_death():
	if Global.player_health <= 0:
		Global.gameover = true

func player_movement(delta, direction):
	if Input.is_action_pressed("move_right"):
		set_new_direction(DIRECTION.RIGHT)
		set_new_state(STATE.WALK)
		_character.play_animation(current_state, current_dir)
	elif Input.is_action_pressed("move_left"):
		set_new_direction(DIRECTION.LEFT)
		set_new_state(STATE.WALK)
		_character.play_animation(current_state, current_dir)
	elif Input.is_action_pressed("move_down"):
		set_new_direction(DIRECTION.DOWN)
		set_new_state(STATE.WALK)
		_character.play_animation(current_state, current_dir)
	elif Input.is_action_pressed("move_up"):
		set_new_direction(DIRECTION.UP)
		set_new_state(STATE.WALK)
		_character.play_animation(current_state, current_dir)
	else:
		if !attack_in_progress:
			set_new_state(STATE.IDLE)
			_character.play_animation(STATE.IDLE, current_dir)
	velocity = direction * Global.player_speed
	move_and_slide()
	
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		sword_audio.play()
		Global.player_current_attack = true
		attack_in_progress = true
		_character.play_attack_animation(dir)
		$deal_attack_timer.start()
		

func receive_damage_hit(damage):
	if can_be_hurt:
		Global.update_player_health(damage, "damage")
		hurt_audio.play()
		can_be_hurt = false
		$attack_cooldown.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_in_progress = false

func _on_attack_cooldown_timeout():
	can_be_hurt = true
