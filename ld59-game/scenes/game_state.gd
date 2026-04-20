extends Node

var _currentLevel : LevelResource

var _wave: int = 1
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
	
var maxWaves : int = 5

@export var allTowers: TowersResource
@export var levels: Array[LevelResource]
@onready var _gameTickTimer: Timer = Timer.new()

signal onDragEvent(node: Node2D, state: bool)
signal onPacketLost()
signal onPacketReceived()
signal onLevelCreated()
signal onGameTick()
signal onNextWave(wave: int)
signal onWaveFinished(wave: int)
signal onPlaceInventory(tower: Tower)
signal onInventoryChanged()
signal onLevelUp(towers: Array[TowerResource])
signal onGameOver
signal onGameFinished

func _ready():
	loadGame()
	onDragEvent.connect(func(n, state): _isDragging = state)
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
	_inventory = {}
	inventory[allTowers.towers[0]] = 1
	inventory[allTowers.towers[1]] = 1
	inventory[allTowers.towers[4]] = 1
	get_tree().change_scene_to_packed(_currentLevel.scene)
	get_tree().paused = false

func loadLevel(resource: LevelResource) -> void:
	_inventory = {}
	inventory[allTowers.towers[0]] = 1
	inventory[allTowers.towers[1]] = 1
	inventory[allTowers.towers[4]] = 1
	_currentLevel = resource
	get_tree().change_scene_to_packed(_currentLevel.scene)

func setupLevel() -> void:
	var scene := get_tree().current_scene
	if scene is not Level: return
	var level := scene as Level

	_signal = 0
	_packetsReceived = 0
	_payloadReceived = 0
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

func receivePacket(payload: int):
	_payloadReceived += payload
	_payloadBuffer += payload
	_packetsReceived += 1
	if packetsToSend == 0:
		onWaveFinished.emit(_wave)
		if _wave < maxWaves:
			triggerLevelUp()
		else:
			triggerLevelCompleted()

func startWave(nr: int):
	get_tree().paused = false
	print("starting wave " + str(nr) + "...")
	_wave = nr
	_signal = 0
	_packetsReceived = 0
	_payloadReceived = 0
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
	
func triggerLevelCompleted():
	_currentLevel.completed = true
	saveGame()
	var nextLvl := 0
	for lvl in levels.size():
		if levels[lvl] == _currentLevel:
			nextLvl = lvl + 1
			break
	if nextLvl < levels.size():
		loadLevel(levels[nextLvl])
	else:
		onGameFinished.emit()
		print("you finished the game!")

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

func saveGame():
	var config := ConfigFile.new()
	for lvl in levels:
		config.set_value("completed-levels", lvl.title, lvl.completed)
	config.save("user://save_game.cfg")

func loadGame():
	var config := ConfigFile.new()
	config.load("user://save_game.cfg")
	if not config.has_section("completed-levels"): return
	
	var keys := config.get_section_keys("completed-levels")
	for key in keys:
		for lvl in levels:
			if lvl.title == key:
				lvl.completed = config.get_value("completed-levels", key)
				break
