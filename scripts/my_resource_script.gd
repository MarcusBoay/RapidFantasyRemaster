@tool
extends Node2D
class_name MyTools

@export var player: PlayerCharacter
@export_tool_button("Place player back", "Callable") var place_player_back = place_player_back_func

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

func place_player_back_func():
    if not player:
        print("pls place player node in me c:")
    else:
        # starting position of player in the overworld
        player.position.x = 984.0
        player.position.y = 10080.0