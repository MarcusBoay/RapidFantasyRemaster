@tool
extends Node2D
class_name MyResourceScript

@export var hp: int:
    get: return hp
    set(x):
        hp = clamp(x, 0, 255)

func _process(_delta):
    if Engine.is_editor_hint():
        # Code to execute in editor.
        # print("HELLO")
        pass
    if not Engine.is_editor_hint():
	    # Code to execute in game.
        # print("boo")
        pass
	# Code to execute both in editor and in game.
    pass
