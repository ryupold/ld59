extends Tower

@export var collisionArea: Area2D;

func _ready() -> void:
	collisionArea.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name + "entered")
	pass # Replace with function body.
