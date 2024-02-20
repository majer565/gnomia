extends CharacterBody2D

@onready var player = get_node("/root/world/Player")
@onready var world = get_node("/root/world")

enum ENEMY_STATE {WALK, ATTACK}
var current_state = ENEMY_STATE.WALK

var health = Global.enemy_goblin_red_health

var player_in_attack_zone = false
var can_take_damage = true
var can_attack = false

var can_deal_damage = false

var enemy_speed = Global.enemy_goblin_red_speed

func _physics_process(delta):
	deal_with_damage()
	on_destroy()
	deal_damage()
	update_health()
	
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemy_speed
	play_enemy_animation(direction)
	move_and_slide()
	
func on_destroy():
	if health <= 0:
		Global.update_score("RED", false)
		world.spawnEnemies(Global.random_enemy_count())
		self.queue_free()
		
func deal_damage():
	if player_in_attack_zone and can_attack:
		player.receive_damage_hit(Global.enemy_goblin_red_damage)

func play_enemy_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	match current_state:
		ENEMY_STATE.WALK:
			$AnimatedSprite2D.play("walk")
		ENEMY_STATE.ATTACK:
			$AnimatedSprite2D.play("attack")

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true
		enemy_speed = 0
		current_state = ENEMY_STATE.ATTACK
		$deal_damage_cooldown.start()

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false
		current_state = ENEMY_STATE.WALK
		enemy_speed = Global.enemy_goblin_red_speed
		$deal_damage_cooldown.stop()

func deal_with_damage():
	if player_in_attack_zone and Global.player_current_attack == true:
		if can_take_damage:
			health = health - Global.player_strength
			can_take_damage = false
			$take_damage_cooldown.start()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_deal_damage_cooldown_timeout():
	can_attack = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health / 2
	
	if health >= 200:
		healthbar.visible = false
	else:
		healthbar.visible = true
