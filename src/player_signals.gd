extends Node

# Emitted whenever player HP changes. delta is the change in HP.
# Examples: player taking damage, player healing
signal player_hp_changed(delta: int)
# Emitted after player's new HP to update UI.
signal player_hp_new(x: int)

signal player_mp_changed(delta: int)
signal player_mp_new(x: int)

signal player_hp_max_changed(delta: int)
signal player_hp_max_new(x: int)

signal player_mp_max_changed(delta: int)
signal player_mp_max_new(x: int)

signal player_level_changed(delta: int)
signal player_level_new(x: int)

signal player_exp_changed(delta: int)
signal player_exp_new(x: int)

signal player_limit_changed(delta: int)
signal player_limit_new(x: int)

signal player_strength_changed(delta: int)
signal player_strength_new(x: int)

signal player_wisdom_changed(delta: int)
signal player_wisdom_new(x: int)

signal player_defense_changed(delta: int)
signal player_defense_new(x: int)

signal player_gold_changed(delta: int)
signal player_gold_new(x: int)

signal player_items_empty()

signal player_equip_changed(equip: Item, equip_type: Globals.ItemType)
signal player_equip_new(equip: Item, equip_type: Globals.ItemType)

signal player_magic_changed(magic_equipped: PlayerAttack, idx: int)
signal player_magic_new(magic_equipped: PlayerAttack, idx: int)

signal player_limit_equip_changed(limit_equipped: PlayerAttack)
signal player_limit_equip_new(limit_equipped: PlayerAttack)
