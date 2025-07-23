extends Node

@export_group("Initial Inventory")
@export var initial_attacks: Dictionary[PlayerAttack, int] # second param is unused (crude way of making a set)
@export var initial_items: Dictionary[Item, int] # item, quantity
@export var initial_stats: Stats

@export_group("Initial Equips")
@export var initial_equipped_limit: PlayerAttack
@export var initial_equipped_magic: Array[PlayerAttack]

var equips: PlayerEquips
var inventory: PlayerInventory
var stats: Stats
var limit: int # this is the ONLY player stat... just shove it in here

func _ready():
    # set initial values
    inventory = PlayerInventory.new()
    stats = Stats.new()
    equips = PlayerEquips.new()
    _set_initial_inventory()
    _set_initial_stats()
    _set_initial_equips()
    limit = 0

    connect_signals()

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
    equips.magic = initial_equipped_magic.duplicate(true)
    # Player starts out with 1st limit break.
    equips.limit = initial_equipped_limit.duplicate(true)

    # print(equips.limit.name)
    # for m in equips.magic:
    # 	print(m.name)

func connect_signals():
    EventBus.player_hp_changed.connect(update_player_hp)
    EventBus.player_mp_changed.connect(update_player_mp)
    EventBus.player_level_changed.connect(update_player_level)
    EventBus.player_exp_changed.connect(update_player_exp)
    EventBus.player_limit_changed.connect(update_player_limit)
    EventBus.player_strength_changed.connect(update_player_strength)
    EventBus.player_wisdom_changed.connect(update_player_wisdom)
    EventBus.player_defense_changed.connect(update_player_defense)
    EventBus.player_gold_changed.connect(update_player_gold)

func update_player_hp(delta: int):
    stats.hp = min(stats.hp_max, stats.hp+delta)
    EventBus.player_hp_new.emit(stats.hp)

func update_player_mp(delta: int):
    stats.mp = min(stats.mp_max, stats.mp+delta)
    EventBus.player_mp_new.emit(stats.mp)

func update_player_level(delta: int):
    stats.level += delta
    EventBus.player_level_new.emit(stats.level)

func update_player_exp(delta: int):
    stats.experience += delta
    EventBus.player_exp_new.emit(stats.experience)

func update_player_limit(delta: int):
    limit += delta
    EventBus.player_limit_new.emit(limit)

func update_player_strength(delta: int):
    stats.strength += delta
    EventBus.player_strength_new.emit(stats.strength)

func update_player_wisdom(delta: int):
    stats.wisdom += delta
    EventBus.player_wisdom_new.emit(stats.wisdom)

func update_player_defense(delta: int):
    stats.defense += delta
    EventBus.player_defense_new.emit(stats.defense)

func update_player_gold(delta: int):
    stats.gold += delta
    EventBus.player_gold_new.emit(stats.gold)

func use_item(item: Item):
    if item.item_type != Globals.ItemType.CONSUMABLE:
        print_debug("item is not consumable!! oopsie!!!")
        return
    update_player_hp(item.stats.hp)
    update_player_mp(item.stats.mp)
    inventory.items[item] -= 1
    if inventory.items[item] == 0:
        inventory.items.erase(item)

    if inventory.items.size() == 0:
        EventBus.player_items_empty.emit()


class PlayerEquips:
    var magic: Array[PlayerAttack] # this should be limited to 4.
    var limit: PlayerAttack

    var weapon: Item
    var armor: Item
    var accessory: Item
