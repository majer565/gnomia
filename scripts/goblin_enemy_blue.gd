extends CharacterBody2D

@onready var player = get_node("/root/world/Player")
@onready var world = get_node("/root/world")
@onready var bomb_sound = $AudioStreamPlayer2D

enum ENEMY_STATE {WALK, ATTACK, DEATH, EXPLOSION}
var current_state = ENEMY_STATE.WALK

var health = Global.enemy_goblin_blue_health

var player_in_attack_zone = false
var can_take_damage = true
var is_exploding = false
var is_dead = false
var can_deal_damage = false

var enemy_speed = Global.enemy_goblin_blue_speed

func _physics_process(delta):
	deal_with_damage()
	on_attack()
	on_destroy()
	deal_damage()
	update_health()
	
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemy_speed
	play_enemy_animation(direction)
	move_and_slide()
	
func on_destroy():
	if health <= 0:
		if is_dead:
			Global.update_score("BLUE", true)
		else:
			Global.update_score("BLUE", false)
		world.spawnEnemies(Global.random_enemy_count())
		self.queue_free()
		
func deal_damage():
	if can_deal_damage and is_dead:
		player.receive_damage_hit(Global.enemy_goblin_blue_damage)

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
		ENEMY_STATE.DEATH:
			$AnimatedSprite2D.play("death")
		ENEMY_STATE.EXPLOSION:
			$AnimatedSprite2D.play("explosion")

func on_attack():
	if player_in_attack_zone and is_exploding and !is_dead:
		bomb_sound.play()
		$death_duration.start()
		is_dead = true
		current_state = ENEMY_STATE.EXPLOSION

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true
		enemy_speed = 0
		current_state = ENEMY_STATE.ATTACK
		$explosion_cooldown.start()

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player") and is_dead == false:
		player_in_attack_zone = false
		current_state = ENEMY_STATE.WALK
		enemy_speed = Global.enemy_goblin_blue_speed
		is_exploding = false
		$explosion_cooldown.stop()

func deal_with_damage():
	if player_in_attack_zone and Global.player_current_attack == true:
		if can_take_damage:
			health = health - Global.player_strength
			$take_damage_cooldown.start()
			can_take_damage = false

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_explosion_cooldown_timeout():
	is_exploding = true

func _on_death_duration_timeout():
	health = 0

func _on_explosion_zone_body_entered(body):
	if body.has_method("player"):
		can_deal_damage = true

func _on_explosion_zone_body_exited(body):
	if body.has_method("player"):
		can_deal_damage = false
		
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
