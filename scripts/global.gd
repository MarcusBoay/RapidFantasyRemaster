extends Node


enum GameState {
    INITIALIZATION,
    MAINMENU,
    OVERWORLD,
    MENU,
    BATTLE,
    LOSE,
    FINALVICTORY,
    EXIT,
}


class Area:
    var id: int
    var enemies: Array[int] # enemy ids
    var background: int # TODO

    func _init(p_id: int, p_enemies: Array[int], p_background: int):
        self.id = p_id
        self.enemies = p_enemies
        self.background = p_background

# TODO: Areas

class Player:
    var x: float
    var y: float
    var stats: Stats
    var limit: int
    var area: int # area id

    func _init():
        self.x = 0
        self.y = 0
        self.stats = Stats.new()
        self.limit = 0
        self.area = 0

class Stats:
    var hp_max: int
    var mp_max: int
    var hp: int
    var mp: int
    var strength: int
    var wisdom: int
    var defense: int
    var level: int
    var experience: int
    var gold: int

    func add_item_stats(item_stats: ItemStats):
        self.hp_max += item_stats.hp_max
        self.mp_max += item_stats.mp_max
        self.hp = min(self.hp + item_stats.hp, self.hp_max)
        self.mp = min(self.mp + item_stats.mp, self.mp_max)
        self.strength += item_stats.strength
        self.wisdom += item_stats.wisdom
        self.defense += item_stats.defense

    func subtract_item_stats(item_stats: ItemStats):
        self.hp_max -= item_stats.hp_max
        self.mp_max -= item_stats.mp_max
        self.hp = max(self.hp - item_stats.hp, 0)
        self.mp = max(self.mp - item_stats.mp, 0)
        self.strength -= item_stats.strength
        self.wisdom -= item_stats.wisdom
        self.defense -= item_stats.defense



enum Element {
    NORMAL,
    FIRE,
    EARTH,
    ELECTRIC,
    WATER,
    LIGHT,
    DARK,
}



enum PlayerAttackType {
    BASIC,
    LIMIT,
    MAGIC,
}

class PlayerAttack:
    var id: int
    var name: String
    var attack_type: PlayerAttackType
    var element: Element
    var mp_use: int
    var tier: int

    func _init(p_id: int, p_name: String, p_attack_type: PlayerAttackType, p_element: Element, p_mp_use: int, p_tier: int):
        self.id = p_id
        self.name = p_name
        self.attack_type = p_attack_type
        self.element = p_element
        self.mp_use = p_mp_use
        self.tier = p_tier

# TODO PlayerAttackTable...

class PlayerEquips:
    var magic: Array[PlayerAttack] # this should be limited to 4.
    var limit: PlayerAttack

    var weapon: Item
    var armor: Item
    var accessory: Item

    func _init():
        # Player starts out with tier 1 magic equipped.
        # TODO
        # Player starts out with 1st limit break.
        # TODO

        # Player starts out naked. :O
        self.weapon = null
        self.armor = null
        self.accessory = null

class PlayerInventory:
    var attacks: Dictionary[PlayerAttack, int] # second param is unused (crude way of making a set)
    var items: Dictionary[Item, int] # item, quantity

    func _init():
        # TODO: ITEM TABLE
        # Player starts out with 5 red and blue potions.
        # self.items[]
        pass



enum ItemType {
    CONSUMABLE,
    WEAPON,
    ARMOR,
    ACCESSORY,
}

class ItemStats:
    var hp_max: int
    var mp_max: int
    var hp: int
    var mp: int
    var strength: int
    var wisdom: int
    var defense: int

    static func new_potion(p_hp: int, p_mp: int) -> ItemStats:
        var item_stats = ItemStats.new()
        item_stats.hp = p_hp
        item_stats.mp = p_mp
        return item_stats

    static func new_equip(p_hp_max: int, p_mp_max: int, p_strength: int, p_wisdom: int, p_defense: int) -> ItemStats:
        var item_stats = ItemStats.new()
        item_stats.hp_max = p_hp_max
        item_stats.mp_max = p_mp_max
        item_stats.strength = p_strength
        item_stats.wisdom = p_wisdom
        item_stats.defense = p_defense
        return item_stats

    func get_equip_stats_string() -> String:
        var stats_string = ""
        stats_string += "Max HP: %d, Max MP: %d" % [self.hp_max, self.mp_max] + "\n"
        stats_string += "Strength: %d" % self.strength + "\n"
        stats_string += "Wisdom: %d" % self.wisdom + "\n"
        stats_string += "Defense: %d" % self.defense
        return stats_string

class Item:
    var id: int
    var name: String
    var item_type: ItemType
    var stats: ItemStats

    func _init(p_id: int, p_name: String, p_item_type: ItemType, p_stats: ItemStats):
        id = p_id
        name = p_name
        item_type = p_item_type
        stats = p_stats



class TupleInt2:
    var first: int
    var second: int

    func _init(p_first: int, p_second: int):
        self.first = p_first
        self.second = p_second

class LootTable:
    var no_drop_weight: int
    var items: Array[TupleInt2] # item id, weight

    # Returns item id for a roll, otherwise, returns -1 (no item)
    func get_item_id() -> int:
        var roll = randi_range(0, get_total_weight())
        var cur_weight = no_drop_weight

        for item in items:
            if roll >= cur_weight and roll < cur_weight + item.second:
                return item.first
            cur_weight += item.second

        return -1

    func get_total_weight() -> int:
        return no_drop_weight + items.reduce(func(accum, item): return accum + item.second)
