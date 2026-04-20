extends Node

var _currentLevel : LevelResource

var _wave: int
var _patience: float

var _packetsLost: int
var _packetsReceived: int
var _payloadReceived: int
var _payloadBuffer: int
var _payloadPerSecond: float

## this is the indicator for a good or bad signal
## patience is lost when this value stays below a threshold
var _signal: float
var _timePassed: float

var _isDragging: bool = false

var packetsToSend: int:
	get:
		return _currentLevel.packetsToSend - _packetsReceived

@export var allTowers: TowersResource
@export var unlockedTowers: TowersResource
@export var levels: Array[LevelResource]
@onready var _gameTickTimer: Timer = Timer.new()

signal onDragEvent(node: Node2D, state: bool)
signal onPacketLost()
signal onPacketReceived()
signal onLevelCreated()
signal onGameTick()
signal onNextWave(wave: int)

func _ready():
	onDragEvent.connect(func(n, state): _isDragging = state)
	onPacketLost.connect(lostPacket)
	onPacketReceived.connect(receivePacket)
	onLevelCreated.connect(setupLevel)
	onGameTick.connect(updateGameState)
	onNextWave.connect(startWave)
	_currentLevel = levels[0]	
	_gameTickTimer.wait_time = 1
	_gameTickTimer.autostart = true
	_gameTickTimer.timeout.connect(func(): onGameTick.emit())
	add_child(_gameTickTimer)

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
	_signal = 0
	_packetsReceived = 0
	_payloadBuffer = 0
	_patience = _currentLevel.patience

	level.sender.spawnInterval = _currentLevel.spawnInterval
	level.sender.spawnImpulse = _currentLevel.spawnImpulse
	level.sender.spawnAngleMin = _currentLevel.spawnAngleMin
	level.sender.spawnAngleMax = _currentLevel.spawnAngleMax
	level.sender.spawnAngleRotationSpeed = _currentLevel.spawnAngleRotationSpeed
	
	startWave(1)

func updateGameState():
	_payloadPerSecond = _payloadBuffer
	_payloadBuffer = 0
	# reduce patience when signal is bad
	if not isConnectionGood:
		_patience -= 1.0

var isConnectionGood: bool:
	get:
		return _signal >= _currentLevel.signalThreshold

func lostPacket():
	_packetsLost += 1

func receivePacket(payload: int):
	_payloadReceived += payload
	_payloadBuffer += payload
	_packetsReceived += 1
	if _packetsReceived == _currentLevel.packetsToSend:
		onNextWave.emit(_wave + 1)
	
func startWave(nr: int):
	print("starting wave " + str(nr) + "...")
	if nr > 1:
		await get_tree().create_timer(10).timeout
	_wave = nr
	_signal = 0
	_payloadReceived = 0
	_timePassed = 0
	_packetsReceived = 0
	_payloadBuffer = 0

func _physics_process(delta):
	_timePassed += delta
	_signal = _payloadPerSecond * _payloadReceived / _timePassed

enum GameState {
	MainMenu,
	ChoosingLevel,
	IngameBuildChooser,
	IngameLevelUpChooser,
	GameOverScreen,
}
