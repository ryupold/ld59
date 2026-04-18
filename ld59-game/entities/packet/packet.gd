extends RigidBody2D

class_name Packet

@export_category("Properties")
@export var ttl: int = 5;
@export var payload: int = 1;
@export var degradation: int;
@export var speed: Vector2;

func _ready():
	body_entered.connect(onCollision)
	pass
	
#func _physics_process(delta):
	#var x := move_and_collide(Vector2(0,0))
	#if x:
		#print(x.get_position())

func onCollision(body: Node2D):
	ttl -= 1
	if ttl <= 0:
		GameState.packetsLost += 1
		queue_free()
