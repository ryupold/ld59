@abstract class_name Tower extends Node2D

@export var collisionArea: Area2D
var packetsColliding: Array[Packet]
@export var followsMouse := false
@export var disableEffect := false
@export var debug := true

func _ready() -> void:
	collisionArea.body_entered.connect(addCompute)
	collisionArea.body_exited.connect(removeCompute)
	collisionArea.input_event.connect(handleClick)

func _physics_process(delta: float) -> void:
	handleFollowMouse()
	if not disableEffect:
		doEffect(delta)

func addCompute(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		packetsColliding.append(packet)
	return

func removeCompute(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		var pos := packetsColliding.find(packet)
		if pos == -1:
			return
		packetsColliding.remove_at(pos);
	return

func handleFollowMouse() -> void:
	if followsMouse:
		global_position = get_global_mouse_position()

func handleClick(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			followsMouse = false
		elif event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and debug:
			print("Right mouse button clicked at:", event.position)
			followsMouse = true

func handleDisableEffect() -> void:
	if disableEffect:
		collisionArea.body_entered.disconnect(addCompute)
		var shape: CollisionShape2D = collisionArea.get_child(0)
		shape.disabled = true

func doEffect(delta: float) -> void:
	pass
