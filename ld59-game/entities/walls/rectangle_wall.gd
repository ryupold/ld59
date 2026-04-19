@tool
extends Wall

class_name RectangleWall

func _ready():
	onResize()
	resized.connect(onResize)

func onResize():
	($StaticBody2D/CollisionShape2D.shape as RectangleShape2D).size = size
	$StaticBody2D/CollisionShape2D.position = size / 2
	pivot_offset = size / 2
