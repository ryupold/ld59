extends VBoxContainer

@export var restartLevel: Button
@export var restartWave: Button

func _ready() -> void:
	get_tree().paused = true
	restartLevel.pressed.connect(GameState.restartLevel)
	restartWave.pressed.connect(restartWaveF)

func restartWaveF():
	GameState.onNextWave.emit(GameState._wave)
	queue_free()
