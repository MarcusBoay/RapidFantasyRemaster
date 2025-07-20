@tool
extends Node2D
class_name MyTools

@export var player: PlayerCharacter
@export_tool_button("Place player back", "Callable") var place_player_back = place_player_back_func
@export_tool_button("Generate Player Attacks Resources", "Callable") var generate_player_attacks_tool = generate_player_attacks

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

func generate_player_attacks():
    if true:
        return
    # no longer needed :)
    var file = FileAccess.open("res://assets/tables/player_attacks.json", FileAccess.READ)
    var json_str = file.get_as_text()
    # print(json_str)
    var data = JSON.parse_string(json_str)
    for atk in data["attacks"]:
        var file_name = atk["name"]
        file_name = file_name.replace(" ", "") # get rid of spaces for the file name.
        var res = PlayerAttack.new()
        res.id = atk["id"] as int
        res.name = atk["name"]

        if atk["type"] == "Basic":
            res.type = Globals.PlayerAttackType.BASIC
        elif atk["type"] == "Limit":
            res.type = Globals.PlayerAttackType.LIMIT
        elif atk["type"] == "Magic":
            res.type = Globals.PlayerAttackType.MAGIC

        if atk["element"] == "Normal":
            res.element = Globals.Element.NORMAL
        elif atk["element"] == "Fire":
            res.element = Globals.Element.FIRE
        elif atk["element"] == "Earth":
            res.element = Globals.Element.EARTH
        elif atk["element"] == "Electric":
            res.element = Globals.Element.ELECTRIC
        elif atk["element"] == "Water":
            res.element = Globals.Element.WATER
        elif atk["element"] == "Light":
            res.element = Globals.Element.LIGHT
        elif atk["element"] == "Dark":
            res.element = Globals.Element.DARK

        res.element = atk["element"]
        res.mp_use = atk["mp_use"] as int
        res.tier = atk["tier"] as int

        var save_res = ResourceSaver.save(res, 'res://assets/resources/player_attacks/'+file_name+'.tres')
        if save_res != OK:
            print(save_res)