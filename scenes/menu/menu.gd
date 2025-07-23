extends Control

@onready var items_container: ItemList = %ItemsContainer
@onready var magic_equipped_container: VBoxContainer = %MagicEquippedContainer
@onready var equipment_container: VBoxContainer = %EquipmentContainer
@onready var limit_container: VBoxContainer = %LimitContainer
@onready var attack_stat_container: VBoxContainer = %AttackStatContainer
@onready var item_stat_container: VBoxContainer = %ItemStatContainer
@onready var attacks_container: VBoxContainer = %AttacksContainer

### Lifecycle

func _ready() -> void:
    _connect_signals()


### Signals

func _connect_signals() -> void:
    MenuSignals.use_item.connect(_use_item)
    EventBus.player_items_empty.connect(_populate_items_container)

### Actions Container

func _hide_all_containers() -> void:
    items_container.visible = false
    magic_equipped_container.visible = false
    equipment_container.visible = false
    limit_container.visible = false
    attack_stat_container.visible = false
    item_stat_container.visible = false
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


func _on_magic_button_pressed() -> void:
    _hide_all_but_toggle(magic_equipped_container)


func _on_limit_button_pressed() -> void:
    _hide_all_but_toggle(limit_container)


func _on_settings_button_pressed() -> void:
    #_hide_all_but_toggle(items_container)
    print_debug("TODO: SHOW SETTINGS")


func _on_save_button_pressed() -> void:
    print_debug("TODO: SAVE FUNCTIONALITY")


func _on_exit_button_pressed() -> void:
    print_debug("TODO: EXIT MENU")


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

### Items Container

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
        items_container.set_item_metadata(items_container.item_count - 1, item)
        items_container.set_item_tooltip_enabled(items_container.item_count - 1, false)

## Items Stat Container

func _use_item(item: Item, idx: int) -> void:
    # this is ugly but whatever... why can't we have a list that binds to the data in godot..????
    var item_count = PlayerManager.inventory.items[item]
    items_container.set_item_text(idx, item.name + ": " + str(item_count-1))
    if item_count <= 1:
        item_stat_container.visible = false
        items_container.remove_item(idx)
    PlayerManager.use_item(item)
