extends Label

func _process(delta):
	if Global.player_health <= 0:
		self.text = "0%"
	else:
		self.text = str(Global.player_health) + "%"
