@tool
extends Wall

class_name RectangleWall

func _ready():
	onResize()
	resized.connect(onResize)

func onResize():
	($TextureRect/CollisionShape2D.shape as RectangleShape2D).size = size
	$TextureRect/CollisionShape2D.position = size / 2
