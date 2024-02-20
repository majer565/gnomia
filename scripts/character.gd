extends Node2D

enum STATE { IDLE, WALK }
enum DIRECTION {UP, DOWN, LEFT, RIGHT, NONE}

@onready var _animated_sprite = $AnimatedSprite2D

func play_animation(state: STATE, direction: DIRECTION):
	if direction == DIRECTION.NONE:
		_animated_sprite.play("idle_down")
	match direction:
		DIRECTION.RIGHT:
			if state == STATE.IDLE:
				_animated_sprite.play("idle_right")
			elif state == STATE.WALK:
				if !Global.player_current_attack:
					_animated_sprite.play("walk_right")
		DIRECTION.LEFT:
			if state == STATE.IDLE:
				_animated_sprite.play("idle_left")
			elif state == STATE.WALK:
				if !Global.player_current_attack:
					_animated_sprite.play("walk_left")
		DIRECTION.DOWN:
			if state == STATE.IDLE:
				_animated_sprite.play("idle_down")
			elif state == STATE.WALK:
				if !Global.player_current_attack:
					_animated_sprite.play("walk_down")
		DIRECTION.UP:
			if state == STATE.IDLE:
				_animated_sprite.play("idle_up")
			elif state == STATE.WALK:
				if !Global.player_current_attack:
					_animated_sprite.play("walk_up")

func play_attack_animation(direction):
	match direction:
		DIRECTION.RIGHT:
			_animated_sprite.play("attack_right")
		DIRECTION.LEFT:
			_animated_sprite.play("attack_left")
		DIRECTION.DOWN:
			_animated_sprite.play("attack_down")
		DIRECTION.UP:
			_animated_sprite.play("attack_up")
