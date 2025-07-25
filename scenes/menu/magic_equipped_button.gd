class_name MagicEquippedButton
extends Button

@export_range(0, 3) var index: int

var magic_ref: PlayerAttack


func _pressed() -> void:
    MenuSignals.magic_equipped_button_pressed.emit(magic_ref, index)
