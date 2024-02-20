extends StaticBody2D

@onready var _tree = get_node("AnimatedTree")

func _ready():
	_tree.play_anim()
