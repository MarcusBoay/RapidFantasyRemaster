extends Node

# TODO: should we be keeping track of this..?
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

enum ItemType {
    CONSUMABLE,
    WEAPON,
    ARMOR,
    ACCESSORY,
}

# TODO: to clean up
# class Player:
#     var x: float
#     var y: float
#     var stats: Stats
#     var limit: int
#     var area: int # area id

#     func _init():
#         self.x = 0
#         self.y = 0
#         self.stats = Stats.new()
#         self.limit = 0
#         self.area = 0
