extends Node

var _currentLevel : LevelResource

var _wave: int = 1
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
		return _currentLevel.packetsToSend + sqrt(_currentLevel.packetsToSend * _wave) - _packetsReceived

var _inventory: Dictionary[TowerResource, int]
var inventory: Dictionary[TowerResource, int] :
	get: return _inventory
	set(value):
		_inventory = value
		onInventoryChanged.emit()

func setInventory(key: TowerResource, value: int):
	inventory[key] = value
	onInventoryChanged.emit()

@export var allTowers: TowersResource
@export var levels: Array[LevelResource]
@onready var _gameTickTimer: Timer = Timer.new()

signal onDragEvent(node: Node2D, state: bool)
signal onPacketLost()
signal onPacketReceived()
signal onLevelCreated()
signal onGameTick()
signal onNextWave(wave: int)
signal onPlaceInventory(tower: Tower)
signal onInventoryChanged()
signal onLevelUp(towers: Array[TowerResource])
signal onGameOver

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
	inventory[allTowers.towers[0]] = 1
	inventory[allTowers.towers[1]] = 1
	inventory[allTowers.towers[4]] = 1

func restartLevel() -> void:
	get_tree().change_scene_to_packed(_currentLevel.scene)
	get_tree().paused = false

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

	level.sender.spawnInterval = _currentLevel.spawnInterval
	level.sender.spawnImpulse = _currentLevel.spawnImpulse
	level.sender.spawnAngleMin = _currentLevel.spawnAngleMin
	level.sender.spawnAngleMax = _currentLevel.spawnAngleMax
	level.sender.spawnAngleRotationSpeed = _currentLevel.spawnAngleRotationSpeed

	startWave(1)

func updateGameState():
	_payloadPerSecond = _payloadBuffer
	_payloadBuffer = 0

var isConnectionGood: bool:
	get: return _signal >= minSignal

var minSignal: float:
	get: return _currentLevel.signalThreshold + sqrt(_timePassed * _wave)

func lostPacket():
	_packetsLost += 1

func receivePacket(payload: int):
	_payloadReceived += payload
	_payloadBuffer += payload
	_packetsReceived += 1
	if packetsToSend == 0:
		onNextWave.emit(_wave + 1)

func startWave(nr: int):
	get_tree().paused = false
	if nr != 1 && _wave != nr: triggerLevelUp()
	print("starting wave " + str(nr) + "...")
	_wave = nr
	_signal = 0
	_payloadReceived = 0
	_packetsLost = 0
	_packetsReceived = 0
	_payloadBuffer = 0
	_timePassed = 0

func triggerLevelUp() -> void:
	var list: Array[TowerResource] = []
	for i in range(0,3):
		var randomTower = allTowers.towers.get((randf() * (allTowers.towers.size() - 1)))
		while list.has(randomTower):
			randomTower = allTowers.towers.get((randf() * (allTowers.towers.size() - 1)))
		list.append(randomTower)
	onLevelUp.emit(list)

func _physics_process(delta):
	_timePassed += delta
	_signal = (_payloadPerSecond + _signal * _currentLevel.signalLag) / (_currentLevel.signalLag+1)

enum GameState {
	MainMenu,
	ChoosingLevel,
	IngameBuildChooser,
	IngameLevelUpChooser,
	GameOverScreen,
}
