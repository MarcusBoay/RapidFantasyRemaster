extends Node

var current_area: Area


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
