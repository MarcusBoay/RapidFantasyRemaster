class_name AttackStatContainer
extends VBoxContainer

@onready var name_label: Label = $NameLabel
@onready var element_label: Label = $ElementLabel
@onready var mp_label: Label = $MpLabel
@onready var tier_label: Label = $TierLabel
@onready var unequip_button: Button = $UnequipButton
@onready var change_button: Button = $ChangeButton

var attack_ref: PlayerAttack
var index: int # only used if it is magic

func populate_info(attack: PlayerAttack, idx: int = 0) -> void:
    attack_ref = attack
    index = idx

    name_label.text = attack.name
    element_label.text = "Element: " + Globals.get_element_as_str(attack.element)

    # Limits are always free of mp cost.
    if attack.type == Globals.PlayerAttackType.MAGIC:
        mp_label.visible = true
        mp_label.text = "MP cost: " + str(attack.mp_use)
    else:
        mp_label.visible = false

    tier_label.text = "Tier: " + str(attack.tier)

    # Player can never unequip their limit.
    if attack.type == Globals.PlayerAttackType.LIMIT:
        unequip_button.visible = false
    else:
        unequip_button.visible = true


func _on_unequip_button_pressed() -> void:
    # this assumes that the source is always from the magic panel
    attack_ref = null
    EventBus.player_magic_changed.emit(null, index)
    MenuSignals.attack_stat_container_unequip_button_pressed.emit()


func _on_change_button_pressed() -> void:
    if attack_ref.type == Globals.PlayerAttackType.MAGIC:
        # menu signal to show attacks container with magic
        MenuSignals.magic_change_button_pressed.emit(index)
    else:
        print_debug("equip some limit!!!")
