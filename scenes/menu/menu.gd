extends Control

@onready var items_container: ItemList = %ItemsContainer
@onready var item_stat_container: VBoxContainer = %ItemStatContainer

@onready var equipment_container: VBoxContainer = %EquipmentContainer
@onready var equip_stats_container: VBoxContainer = %EquipStatsContainer
@onready var equips_container: ItemList = %EquipsContainer

@onready var magic_equipped_container: MagicEquippedContainer = %MagicEquippedContainer
@onready var attack_stat_container: AttackStatContainer = %AttackStatContainer
@onready var attacks_container: ItemList = %AttacksContainer

### Lifecycle

func _ready() -> void:
    _connect_signals()


### Signals

func _connect_signals() -> void:
    MenuSignals.use_item.connect(_use_item)
    EventBus.player_items_empty.connect(_populate_items_container)
    MenuSignals.magic_equipped_button_pressed.connect(_on_magic_equipped_button_pressed)
    MenuSignals.attack_stat_container_unequip_button_pressed.connect(func(): attack_stat_container.visible = false)
    MenuSignals.magic_change_button_pressed.connect(func(_idx: int): _populate_attacks_container(Globals.PlayerAttackType.MAGIC); attack_stat_container.visible = false)
    MenuSignals.limit_change_button_pressed.connect(func(): _populate_attacks_container(Globals.PlayerAttackType.LIMIT))
    EventBus.player_limit_equip_new.connect(func(new_limit: PlayerAttack): attack_stat_container.populate_info(new_limit))

### Actions Container

func _hide_all_containers() -> void:
    items_container.visible = false
    item_stat_container.visible = false

    equipment_container.visible = false
    equip_stats_container.visible = false
    equips_container.visible = false

    magic_equipped_container.visible = false
    attack_stat_container.visible = false
    attacks_container.visible = false

func _hide_all_but_toggle(cont: Control) -> void:
    var orig_visibility = cont.visible
    _hide_all_containers()
    cont.visible = !orig_visibility


func _on_items_button_pressed() -> void:
    _hide_all_but_toggle(items_container)
    if not items_container.visible:
        return
    _populate_items_container()


func _on_equipment_button_pressed() -> void:
    _hide_all_but_toggle(equipment_container)
    equipment_container.populate_equipment_container()


func _on_magic_button_pressed() -> void:
    _hide_all_but_toggle(magic_equipped_container)
    magic_equipped_container.populate_buttons(PlayerManager.equips.magic)


func _on_limit_button_pressed() -> void:
    _hide_all_containers()
    attack_stat_container.populate_info(PlayerManager.equips.limit)
    attack_stat_container.visible = true


func _on_settings_button_pressed() -> void:
    #_hide_all_but_toggle(items_container)
    print_debug("TODO: SHOW SETTINGS")


func _on_save_button_pressed() -> void:
    print_debug("TODO: SAVE FUNCTIONALITY")


func _on_exit_button_pressed() -> void:
    print_debug("TODO: EXIT MENU, RETURN TO OVERWORLD")


### TEST
func _on_add_hp_pressed() -> void:
    EventBus.player_hp_changed.emit(randi_range(-5, 5))
    EventBus.player_mp_changed.emit(randi_range(-5, 5))
    EventBus.player_level_changed.emit(randi_range(-5, 5))
    EventBus.player_exp_changed.emit(randi_range(-5, 5))
    EventBus.player_limit_changed.emit(randi_range(-5, 5))
    EventBus.player_strength_changed.emit(randi_range(-5, 5))
    EventBus.player_wisdom_changed.emit(randi_range(-5, 5))
    EventBus.player_defense_changed.emit(randi_range(-5, 5))
    EventBus.player_gold_changed.emit(randi_range(-5, 5))

func _on_minus_hp_pressed() -> void:
    EventBus.player_hp_changed.emit(-3)

### Items
## Items Container

func _on_items_container_item_selected(index: int) -> void:
    item_stat_container.visible = true
    var item: Item = items_container.get_item_metadata(index)
    item_stat_container.show_item(item, index)

func _populate_items_container() -> void:
    var items = PlayerManager.inventory.items
    # Clear all items then add all items to container.
    items_container.clear()

    # Filter out non-consumable items (weapon, armor, ...).
    var consumable_count = 0
    for item in items:
        consumable_count += (item.item_type == Globals.ItemType.CONSUMABLE) as int

    # Add a "No items" item...
    if consumable_count == 0:
        items_container.add_item("No items!")
        items_container.set_item_disabled(0, true)
        items_container.set_item_tooltip_enabled(0, false)
        return

    for item in items:
        # Only show consumable items.
        if item.item_type != Globals.ItemType.CONSUMABLE:
            continue
        var item_str = item.name + ": " + str(items[item])
        items_container.add_item(item_str)
        items_container.set_item_metadata(-1, item)
        items_container.set_item_tooltip_enabled(-1, false)

## Items Stat Container

func _use_item(item: Item, idx: int) -> void:
    # this is ugly but whatever... why can't we have a list that binds to the data in godot..????
    var item_count = PlayerManager.inventory.items[item]
    items_container.set_item_text(idx, item.name + ": " + str(item_count-1))
    if item_count <= 1:
        item_stat_container.visible = false
        items_container.remove_item(idx)
    PlayerManager.use_item(item)

### Equips
## Equipment Container

func _on_weapon_button_pressed() -> void:
    equip_stats_container.visible = false
    equips_container.visible = false
    if PlayerManager.equips.weapon:
        equip_stats_container.visible = true
        equip_stats_container.populate(PlayerManager.equips.weapon)
    else:
        equips_container.show_equips(Globals.ItemType.WEAPON)


func _on_armor_button_pressed() -> void:
    equip_stats_container.visible = false
    equips_container.visible = false
    if PlayerManager.equips.armor:
        equip_stats_container.visible = true
        equip_stats_container.populate(PlayerManager.equips.armor)
    else:
        equips_container.show_equips(Globals.ItemType.ARMOR)


func _on_accessory_button_pressed() -> void:
    equip_stats_container.visible = false
    equips_container.visible = false
    if PlayerManager.equips.accessory:
        equip_stats_container.visible = true
        equip_stats_container.populate(PlayerManager.equips.accessory)
    else:
        equips_container.show_equips(Globals.ItemType.ACCESSORY)


func _on_change_button_pressed() -> void:
    equips_container.show_equips(equip_stats_container.item_ref.item_type)
    # hide self
    equip_stats_container.visible = false

### Magic
## Magic Equipped Container

func _on_magic_equipped_button_pressed(magic_equipped: PlayerAttack, idx: int) -> void:
    #_populate_attack_stat_container(magic_equipped)
    attacks_container.visible = false
    if magic_equipped:
        attack_stat_container.visible = true
        attack_stat_container.populate_info(magic_equipped, idx)
    else:
        _populate_attacks_container(Globals.PlayerAttackType.MAGIC)


func _populate_attacks_container(attack_type: Globals.PlayerAttackType) -> void:
    attacks_container.clear()
    for attack in PlayerManager.inventory.attacks:
        if attack.type != attack_type:
            continue
        # for magic type, do not add attacks that are already equipped
        if attack.type == Globals.PlayerAttackType.MAGIC:
            var is_already_equipped := false
            for i in PlayerManager.equips.magic.size():
                is_already_equipped = is_already_equipped || (PlayerManager.equips.magic[i] and PlayerManager.equips.magic[i].name == attack.name)
            if is_already_equipped:
                continue
        attacks_container.add_item(attack.name)
        attacks_container.set_item_metadata(-1, attack)
        attacks_container.set_item_tooltip_enabled(-1, false)
    attacks_container.visible = true

func _on_attacks_container_item_selected(index: int) -> void:
    var attack: PlayerAttack = attacks_container.get_item_metadata(index)
    if attack.type == Globals.PlayerAttackType.MAGIC:
        EventBus.player_magic_changed.emit(attack, magic_equipped_container.currently_selected)
    elif attack.type == Globals.PlayerAttackType.LIMIT:
        EventBus.player_limit_changed.emit(attack)
    else:
        print_debug("OPPS, WHAT?! this should never happen!")
    attacks_container.visible = false
