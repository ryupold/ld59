extends Node2D

func _ready() -> void:
	get_tree().change_scene_to_packed.call_deferred(GameState.levels[0].scene)
