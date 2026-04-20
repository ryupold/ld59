@abstract class_name Tower extends Node2D

@export var effectArea: CollisionObject2D
@export var overlapBoundary: Area2D
@export var interactBoundary: Area2D
var packetsColliding: Array[Packet]
var _followsMouse := false
@export var followsMouse : bool :
	get:
		return _followsMouse
	set(value):
		_followsMouse = value
		GameState.onDragEvent.emit(self, _followsMouse)
@export var disableEffect := false

@abstract func towerEffect() -> Effect

enum Effect {
	NONE,
	GRAVITY,
	ANTIGRAVITY,
	SPEED,
	SLOW,
	TTL,
	PAYLOAD,
}

func _ready() -> void:
	if effectArea != null and effectArea is Area2D:
		effectArea.body_entered.connect(enterCollision)
		effectArea.body_exited.connect(exitCollision)

	interactBoundary.input_event.connect(handleClick)

func _physics_process(delta: float) -> void:
	handleFollowMouse()
	handleDisableEffect()
	if not disableEffect:
		doEffect(delta)

func enterCollision(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		packetsColliding.append(packet)
		packet.setEffect(towerEffect(), true)
	return

func exitCollision(body: Node2D) -> void:
	if body is Packet:
		var packet := body as Packet
		packet.setEffect(towerEffect(), false)
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
	return overlapBoundary.get_overlapping_areas().is_empty() and overlapBoundary.get_overlapping_bodies().is_empty()

func handleClick(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and canPlace():
			place()
		elif event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and not GameState._isDragging:
			print("Right mouse button clicked at:", event.position)
			pickup()
		elif event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and GameState._isDragging:
			placeInInventory()

func handleDisableEffect() -> void:
	if effectArea == null: return
	var shape: CollisionShape2D = effectArea.get_child(0)
	if disableEffect:
		shape.disabled = true
	else:
		shape.disabled = false

func doEffect(delta: float) -> void:
	pass

func place():
	followsMouse = false
	disableEffect = false

func pickup():
	followsMouse = true
	disableEffect = true

func placeInInventory():
	followsMouse = false
	GameState.onPlaceInventory.emit(self)
	queue_free()
