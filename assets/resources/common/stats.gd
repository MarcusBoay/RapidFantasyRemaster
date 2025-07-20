class_name Stats
extends Resource

@export var hp_max: int
@export var mp_max: int
@export var hp: int
@export var mp: int
@export var strength: int
@export var wisdom: int
@export var defense: int
@export var level: int
@export var experience: int
@export var gold: int

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