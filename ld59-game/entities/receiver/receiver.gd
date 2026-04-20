extends Node2D
class_name Receiver


func _ready():
	GameState.onGameTick.connect(updateAnimation)

func updateAnimation():
	if GameState.isConnectionGood:
		$AnimatedSprite2D.animation = "good"
	else:
		$AnimatedSprite2D.animation = "bad"
