@tool
extends Node2D
class_name MyTools

@export var player: PlayerOverworld
@export_tool_button("Place player back to start position", "Callable") var place_player_back = place_player_back_func
# @export_tool_button("Generate Player Attacks Resources", "Callable") var generate_player_attacks_tool = generate_player_attacks
# @export_tool_button("Generate Items", "Callable") var generate_items_tool = generate_items
# @export_tool_button("Generate Enemies", "Callable") var generate_enemies_tool = generate_enemies

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




### Functions to import JSON data as resources

func generate_enemies():
    if true:
        return
    # no longer needed :)
    var file = FileAccess.open("res://assets/tables/enemies.json", FileAccess.READ)
    var json_str = file.get_as_text()
    var data = JSON.parse_string(json_str)
    # print(data)
    # return
    for d in data["enemies"]:
        var file_name = d["enemy_stats"]["name"]
        file_name = file_name.replace(" ", "") # get rid of spaces for the file name.
        var res = Enemy.new()
        res.enemy_stats = EnemyStats.new()
        res.stats = Stats.new()
        # enemy stats
        res.enemy_stats.id = d["enemy_stats"]["id"]
        res.enemy_stats.name = d["enemy_stats"]["name"]
        res.enemy_stats.description = d["enemy_stats"]["description"]
        if d["enemy_stats"]["element"] == "Basic":
            res.enemy_stats.element = Globals.Element.NORMAL
        if d["enemy_stats"]["element"] == "Earth":
            res.enemy_stats.element = Globals.Element.EARTH
        if d["enemy_stats"]["element"] == "Fire":
            res.enemy_stats.element = Globals.Element.FIRE
        if d["enemy_stats"]["element"] == "Water":
            res.enemy_stats.element = Globals.Element.WATER
        if d["enemy_stats"]["element"] == "Electric":
            res.enemy_stats.element = Globals.Element.ELECTRIC
        if d["enemy_stats"]["element"] == "Dark":
            res.enemy_stats.element = Globals.Element.DARK
        if d["enemy_stats"]["element"] == "Light":
            res.enemy_stats.element = Globals.Element.LIGHT
        res.enemy_stats.next_phase = d["enemy_stats"]["next_phase"]
        # stats
        res.stats.hp_max = d["stats"]["hp_max"]
        res.stats.mp_max = d["stats"]["mp_max"]
        res.stats.hp = d["stats"]["hp"]
        res.stats.mp = d["stats"]["mp_max"]
        res.stats.strength = d["stats"]["strength"]
        res.stats.wisdom = d["stats"]["wisdom"]
        res.stats.defense = d["stats"]["defense"]
        res.stats.level = d["stats"]["level"]
        res.stats.experience = d["stats"]["experience"]
        res.stats.gold = d["stats"]["gold"]
        # enemy attacks
        for atk_json in d["enemy_attacks"]:
            var atk = EnemyAttack.new()
            atk.name = atk_json["name"]
            atk.damage_modifier = atk_json["damage_modifier"]
            atk.mp_use = atk_json["mp_use"]
            if atk_json["attack_type"] == "Magic":
                atk.attack_type = EnemyAttack.EnemyAttackType.MAGIC
            if atk_json["attack_type"] == "Normal":
                atk.attack_type = EnemyAttack.EnemyAttackType.NORMAL
            if atk_json["attack_type"] == "Percentile":
                atk.attack_type = EnemyAttack.EnemyAttackType.PERCENTILE
            res.attacks.push_back(atk)
        # loot table
        for lt_json in d["loot_table"]:
            var lt = LootTable.new()
            lt.no_drop_weight = lt_json["no_drop_weight"]
            for item_json in lt_json["items"]:
                var dir = DirAccess.open("res://assets/resources/items")
                var item_file_names = dir.get_files()
                for item_file_name in item_file_names:
                    if not item_file_name.contains(".tres"):
                        continue
                    var item_res = load("res://assets/resources/items/"+item_file_name)
                    if item_res.id == item_json["id"]:
                        lt.items[item_res] = item_json["weight"] as int
                        break
            res.loot_table.push_back(lt)


        print("saving...")
        print(d)
        var save_res = ResourceSaver.save(res, 'res://assets/resources/enemies/'+file_name+'.tres')
        # if save_res != OK:
        print(save_res)

func generate_items():
    if true:
        return
    # no longer needed :)
    var file = FileAccess.open("res://assets/tables/items.json", FileAccess.READ)
    var json_str = file.get_as_text()
    var data = JSON.parse_string(json_str)
    # print(data)
    # return
    for d in data["items"]:
        var file_name = d["name"]
        file_name = file_name.replace(" ", "") # get rid of spaces for the file name.
        var res = Item.new()
        res.id = d["id"] as int
        res.name = d["name"]
        if d["type"] == "Consumable":
            res.item_type = Globals.ItemType.CONSUMABLE
        if d["type"] == "Weapon":
            res.item_type = Globals.ItemType.WEAPON
        if d["type"] == "Armor":
            res.item_type = Globals.ItemType.ARMOR
        if d["type"] == "Accessory":
            res.item_type = Globals.ItemType.ACCESSORY
        var stats = ItemStats.new()
        stats.hp_max = d["stats"]["hp_max"]
        stats.mp_max = d["stats"]["mp_max"]
        stats.hp = d["stats"]["hp"]
        stats.mp = d["stats"]["mp"]
        stats.strength = d["stats"]["strength"]
        stats.wisdom = d["stats"]["wisdom"]
        stats.defense = d["stats"]["defense"]
        res.stats = stats
        print("saving...")
        print(d)
        var save_res = ResourceSaver.save(res, 'res://assets/resources/items/'+file_name+'.tres')
        # if save_res != OK:
        print(save_res)

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
