class_name LevelResource extends Resource

@export var title: String

@export var scene: PackedScene
@export var completed := false

@export_category("Sender")
@export var packetsToSend: int = 100
@export var signalThreshold: float = 1.0
@export var spawnInterval: float = 0.2
@export var spawnImpulse: float = 1000
@export var spawnAngleMin: float = 0
@export var spawnAngleMax: float = PI/2
@export var spawnAngleRotationSpeed: float = 1
