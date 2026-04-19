@abstract class_name Tower extends Node2D

@export var effectArea: Area2D
@export var towerboundary: Area2D
var packetsColliding: Array[Packet]
var _followsMouse := false
@export var followsMouse : bool :
	get:
		return _followsMouse
	set(value):
		_followsMouse = value
		GameState.onDragEvent.emit(self, _followsMouse)

@export var disableEffect := false
@export var debug := true

func _ready() -> void:
	if effectArea != null:
		effectArea.body_entered.connect(enterCollision)
		effectArea.body_exited.connect(exitCollision)

	towerboundary.body_entered.connect(enterCollision)
	towerboundary.body_exited.connect(exitCollision)
	towerboundary.input_event.connect(handleClick)

func _physics_process(delta: float) -> void:
	handleFollowMouse()
	if not disableEffect:
		doEffect(delta)

func enterCollision(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		packetsColliding.append(packet)
	return

func exitCollision(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		var pos := packetsColliding.find(packet)
		if pos == -1:
			return
		packetsColliding.remove_at(pos);
	return

func handleFollowMouse() -> void:
	if followsMouse:
		modulate =  Color.WHITE if canPlace() else Color.RED
		global_position = get_global_mouse_position()

func canPlace() -> bool:
	return towerboundary.get_overlapping_areas().is_empty() and towerboundary.get_overlapping_bodies().is_empty()

func handleClick(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and canPlace():
			followsMouse = false
		elif event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and debug and not GameState._isDragging:
			print("Right mouse button clicked at:", event.position)
			followsMouse = true

func handleDisableEffect() -> void:
	if disableEffect:
		effectArea.body_entered.disconnect(enterCollision)
		var shape: CollisionShape2D = effectArea.get_child(0)
		shape.disabled = true

func doEffect(delta: float) -> void:
	pass
