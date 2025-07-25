extends Node2D

@onready var npcs: TileMapLayer = $TileMapLayerHolder/NPCs

var player_overworld = preload("res://scenes/player_overworld.tscn")


func _ready() -> void:
    # spawn player in at last saved position
    var player = player_overworld.instantiate()
    self.add_child(player)
    # initialize some player values
    player.position = PlayerManager.player_position
    player.npc_tilemaplayer = npcs
    player.facing = PlayerManager.facing_direction
    player.set_facing_texture()
