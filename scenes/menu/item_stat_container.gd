extends VBoxContainer

@onready var name_label: Label = $NameLabel
@onready var description_label: RichTextLabel = $DescriptionLabel

var item_ref: Item
var idx_ref: int


func show_item(item: Item, idx: int) -> void:
    item_ref = item
    idx_ref = idx

    name_label.text = item.name
    # this is horrible... each item should have it's own description.
    description_label.text = "Heals "
    if item.stats.hp > 0:
        description_label.text += str(item.stats.hp) + " HP"
        if item.stats.mp > 0:
            description_label.text += " and "
        else:
            description_label.text += "."
    if item.stats.mp > 0:
        description_label.text += str(item.stats.mp) + " MP."


func _on_use_button_pressed() -> void:
    MenuSignals.use_item.emit(item_ref, idx_ref)
