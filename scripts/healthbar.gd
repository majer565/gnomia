extends ProgressBar

@onready var player = get_node("/root/world/Player")

func _ready():
	player.healthChanged.connect(update_healthbar)
	update_healthbar()

func update_healthbar():
	value = player.health * 100 / 100
