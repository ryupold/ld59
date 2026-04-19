@tool
extends Wall

class_name CircleWall

func _ready():
	onResize()
	resized.connect(onResize)

func onResize():
	$TextureRect.size = size
	($StaticBody2D/CollisionShape2D.shape as CircleShape2D).radius = size.x / 2
	$StaticBody2D/CollisionShape2D.position = size / 2
