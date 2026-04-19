extends Node

var _packetsLost: int
var _payloadReceived: int

## this is the indicator for a good or bad signal
## patience is lost when this value stays below a threshold
var _payloadPerSecond: float
var _currentPayloadBuffer: float
var _currentPayloadBufferTime: float
var _patience: float
var _isDragging: bool = false
var _currentLevel : LevelResource

@export var allTowers: TowersResource
@export var unlockedTowers: TowersResource
@export var levels: Array[LevelResource]

signal onDragEvent(node: Node2D, state: bool)
signal onPacketLost()
signal onPacketReceived()
signal onLevelCreated()
signal onGameTick()

func _ready():
	onDragEvent.connect(func(n, state): _isDragging = state)
	onPacketLost.connect(increasePacketLossCounter)
	onPacketReceived.connect(receivePacket)
	onLevelCreated.connect(setupLevel)
	onGameTick.connect(updateGameState)
	_currentLevel = levels[0]

func restartLevel() -> void:
	get_tree().change_scene_to_packed(_currentLevel.scene)

func loadLevel(resource: LevelResource) -> void:
	_currentLevel = resource
	get_tree().change_scene_to_packed(_currentLevel.scene)

func setupLevel() -> void:
	var scene := get_tree().current_scene
	if scene is not Level: return
	var level := scene as Level

	_packetsLost = 0
	_payloadReceived = 0
	_payloadPerSecond = 0
	_patience = _currentLevel.health

	level.sender.spawnInterval = _currentLevel.spawnInterval
	level.sender.spawnImpulse = _currentLevel.spawnImpulse
	level.sender.spawnAngleMin = _currentLevel.spawnAngleMin
	level.sender.spawnAngleMax = _currentLevel.spawnAngleMax
	level.sender.spawnAngleRotationSpeed = _currentLevel.spawnAngleRotationSpeed

func updateGameState():
	# reduce patience when signal is bad
	if not isConnectionGood:
		_patience -= 1.0

var isConnectionGood: bool:
	get:
		return _payloadPerSecond >= _currentLevel.payloadPerSecondDamageThreshold

func increasePacketLossCounter():
	_packetsLost += 1

func receivePacket(payload: int):
	_payloadReceived += payload
	_currentPayloadBuffer += payload

func _process(delta):
	_currentPayloadBufferTime += delta
	if _currentPayloadBufferTime >= 1:
		_currentPayloadBufferTime -= 1
		_payloadPerSecond = (_payloadPerSecond + _currentPayloadBuffer) / 2
		_currentPayloadBuffer = 0
		onGameTick.emit()
		
enum GameState {
	MainMenu,
	ChoosingLevel,
	IngameBuildChooser,
	IngameLevelUpChooser,
	GameOverScreen,
}
