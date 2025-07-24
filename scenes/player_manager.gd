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
var limit: int # this is the ONLY player-specific stat... just shove it in here

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


func _set_initial_stats():
    stats = initial_stats.duplicate(true)


func _set_initial_equips():
    # Player starts out with tier 1 magic equipped.
    equips.magic = initial_equipped_magic.duplicate(true)
    # Player starts out with 1st limit break.
    equips.limit = initial_equipped_limit.duplicate(true)


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
    EventBus.player_equip_changed.connect(update_player_equip)

func update_player_hp(delta: int):
    stats.hp = min(stats.hp_max, stats.hp+delta)
    # TODO: probably should clamp max(0, ..)
    EventBus.player_hp_new.emit(stats.hp)

func update_player_mp(delta: int):
    stats.mp = min(stats.mp_max, stats.mp+delta)
    # TODO: probably should clamp max(0, ..)
    EventBus.player_mp_new.emit(stats.mp)

func update_player_hp_max(delta: int):
    stats.hp_max += delta
    # TODO: probably should clamp max(0, ..)
    EventBus.player_hp_max_new.emit(stats.hp_max)

func update_player_mp_max(delta: int):
    stats.mp_max += delta
    # TODO: probably should clamp max(0, ..)
    EventBus.player_mp_max_new.emit(stats.mp_max)

func update_player_level(delta: int):
    stats.level += delta
    # TODO: probably should clamp max(level, 5)
    EventBus.player_level_new.emit(stats.level)

func update_player_exp(delta: int):
    stats.experience += delta
    # TODO: exp table
    EventBus.player_exp_new.emit(stats.experience)

func update_player_limit(delta: int):
    limit += delta
    # TODO: should clamp min(limit, 100)
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

func update_player_equip(new_equip: Item, equip_type: Globals.ItemType):
    var cur_equip: Item
    if equip_type == Globals.ItemType.WEAPON:
        cur_equip = equips.weapon
        equips.weapon = new_equip
    elif equip_type == Globals.ItemType.ARMOR:
        cur_equip = equips.armor
        equips.armor = new_equip
    elif equip_type == Globals.ItemType.ACCESSORY:
        cur_equip = equips.accessory
        equips.accessory = new_equip
    else:
        print_debug("NOT AN EQUIPPABLE!!!")
        return

    # HACK: this is messy code... there should be a separate function for unequipping... oh well...
    var is_unequip = (new_equip == null)
    if not new_equip:
        new_equip = Item.new()
        new_equip.stats = ItemStats.new()
    if not cur_equip:
        cur_equip = Item.new()
        cur_equip.stats = ItemStats.new()
    update_player_hp_max(new_equip.stats.hp_max - cur_equip.stats.hp_max)
    update_player_mp_max(new_equip.stats.mp_max - cur_equip.stats.mp_max)
    update_player_hp(0)
    update_player_mp(0)
    update_player_strength(new_equip.stats.strength - cur_equip.stats.strength)
    update_player_wisdom(new_equip.stats.wisdom - cur_equip.stats.wisdom)
    update_player_defense(new_equip.stats.defense - cur_equip.stats.defense)
    EventBus.player_equip_new.emit(null if is_unequip else new_equip, equip_type)

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
