class_name Sender extends Node2D

@export var packetScene: PackedScene = preload("res://entities/packet/packet.tscn")
@export var packetParent: Node2D
@export var spawnDistance: float
@export var spawnInterval: float = 1:
	get:
		return $PacketCreationTimer.wait_time
	set(value):
		$PacketCreationTimer.wait_time = value

@export var spawnImpulse: float = 1000
@export var spawnAngleMin: float = 0
@export var spawnAngleMax: float = PI/2
@export var spawnAngleRotationSpeed: float = 1
@onready var _spawnAngle: float = (spawnAngleMin + spawnAngleMax) / 2
var inFlightPackets : int = 0

func _ready():
	$PacketCreationTimer.timeout.connect(sendPacketIfNeeded)
	GameState.onPacketReceived.connect(func(p): inFlightPackets -= 1)
	GameState.onPacketLost.connect(func(): inFlightPackets -= 1)

func _physics_process(delta):
	var nextAngle := wrapf(_spawnAngle + spawnAngleRotationSpeed * delta, spawnAngleMin, spawnAngleMax)
	if spawnAngleRotationSpeed > 0 and nextAngle < _spawnAngle:
		spawnAngleRotationSpeed *= -1
		_spawnAngle = spawnAngleMax
	elif spawnAngleRotationSpeed < 0 and nextAngle > _spawnAngle:
		spawnAngleRotationSpeed *= -1
		_spawnAngle = spawnAngleMin
	else:
		_spawnAngle = nextAngle

func sendPacketIfNeeded():
	if GameState.packetsToSend - inFlightPackets > 0:
		var packet : Packet = packetScene.instantiate()
		var position := global_position + Vector2.from_angle(_spawnAngle) * spawnDistance
		packet.global_position = global_position
		packet.apply_impulse(Vector2.from_angle(_spawnAngle) * spawnImpulse)
		packetParent.add_child(packet)
		inFlightPackets += 1
