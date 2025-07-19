@tool
extends Resource
class_name MyResourceScript

@export var hp: int:
    get: return hp
    set(x):
        hp = clamp(x, 0, 255)
