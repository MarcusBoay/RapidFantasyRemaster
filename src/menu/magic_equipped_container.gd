class_name MagicEquippedContainer
extends VBoxContainer

var currently_selected: int


func _ready() -> void:
    # create buttons dynamically
    for i in PlayerManager.equips.magic.size(): # we just need the number of magic equipped
        var button = MagicEquippedButton.new()
        button.index = i
        add_child(button)

    PlayerSignals.player_magic_new.connect(populate_button)
    MenuSignals.magic_equipped_button_pressed.connect(func(_atk: PlayerAttack, idx: int): currently_selected = idx; print_debug("selected index: " + str(currently_selected)))


func populate_buttons(magic_equipped: Array[PlayerAttack]) -> void:
    for i in range(magic_equipped.size()):
        populate_button(magic_equipped[i], i)


func populate_button(magic: PlayerAttack, idx: int) -> void:
    var button = get_child(idx) as MagicEquippedButton
    button.magic_ref = magic
    button.index = idx
    if magic:
        button.text = magic.name
    else:
        button.text = "-"
