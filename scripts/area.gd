extends Node2D

@onready var camera = $Camera2D
@onready var area2d = $Area2D

func _ready() -> void:
	area2d.connect("area_entered", _on_area_2d_area2d_entered)

func _on_area_2d_area2d_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		camera.make_current()
