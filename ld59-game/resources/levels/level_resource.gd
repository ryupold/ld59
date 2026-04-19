class_name LevelResource extends Resource

@export var Title: String

@export var scene: PackedScene
@export var completed := false

@export_category("Sender")
@export var retries: int
@export var packagesSent: int
@export var winAmountPackages: int
@export var spawnInterval: float = 1
@export var spawnImpulse: float = 500
@export var spawnAngleMin: float = 0
@export var spawnAngleMax: float = PI/2
@export var spawnAngleRotationSpeed: float = 1
