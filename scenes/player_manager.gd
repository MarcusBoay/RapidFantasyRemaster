extends Node

@export_group("Initial Values")
@export var initial_attacks: Dictionary[PlayerAttack, int] # second param is unused (crude way of making a set)
@export var initial_items: Dictionary[Item, int] # item, quantity
@export var initial_stats: Stats
@export var initial_limit: PlayerAttack
@export var initial_magic: Array[PlayerAttack]

var equips: PlayerEquips
var inventory: PlayerInventory
var stats: Stats

func _ready():
	inventory = PlayerInventory.new()
	stats = Stats.new()
	equips = PlayerEquips.new()
	_set_initial_equips()
	_set_initial_stats()
	_set_initial_equips()

func _set_initial_inventory():
	# Player starts out with Tackle, tier 1 limit, and tier 1 magic.
	inventory.attacks.clear()
	inventory.attacks = initial_attacks.duplicate(true)
	# Player starts with 5 Red Potion I and 5 Blue Potion I.
	inventory.items.clear()
	inventory.items = initial_items.duplicate(true)

	# for atk in inventory.attacks:
	# 	print(atk.name + " - tier: " + str(atk.tier))
	# for item in inventory.items:
	# 	print(item.name + " - count: " + str(inventory.items[item]))

func _set_initial_stats():
	stats = initial_stats.duplicate(true)

	# print(stats.battle_sprite.resource_path)

func _set_initial_equips():
	# Player starts out with tier 1 magic equipped.
	equips.magic = initial_magic.duplicate(true)
	# Player starts out with 1st limit break.
	equips.limit = initial_limit.duplicate(true)

	# print(equips.limit.name)
	# for m in equips.magic:
	# 	print(m.name)


class PlayerEquips:
	var magic: Array[PlayerAttack] # this should be limited to 4.
	var limit: PlayerAttack

	var weapon: Item
	var armor: Item
	var accessory: Item
