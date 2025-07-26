extends VBoxContainer

@onready var name_label: Label = $NameLabel
@onready var hp_label: Label = $HpLabel
@onready var mp_label: Label = $MpLabel
@onready var strength_label: Label = $StrengthLabel
@onready var wisdom_label: Label = $WisdomLabel
@onready var defense_label: Label = $DefenseLabel

var item_ref: Item

func populate(item: Item) -> void:
    item_ref = item
    name_label.text = item.name
    hp_label.text = "Max HP: " + str(item.stats.hp_max)
    mp_label.text = "Max MP:" + str(item.stats.mp_max)
    strength_label.text = "Str: " + str(item.stats.strength)
    wisdom_label.text = "Wis: " + str(item.stats.wisdom)
    defense_label.text = "Def: " + str(item.stats.defense)


func _on_unequip_button_pressed() -> void:
    PlayerSignals.player_equip_changed.emit(null, item_ref.item_type)
    self.visible = false
