extends TextureProgressBar

func _ready():
	Global.healthChanged.connect(update_healthbar)
	update_healthbar()

func update_healthbar():
	value = Global.player_health * 100 / 100
