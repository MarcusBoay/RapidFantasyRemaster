extends ItemList


func show_equips(item_type: Globals.ItemType) -> void:
    self.clear()
    for equip in PlayerManager.inventory.items:
        # Only show for the same item type.
        if equip.item_type == item_type:
            self.add_item(equip.name)
            self.set_item_metadata(-1, equip)
            self.set_item_tooltip_enabled(-1, false)

    self.visible = true


func _on_item_selected(index: int) -> void:
    var equip = self.get_item_metadata(index)
    EventBus.player_equip_changed.emit(equip, equip.item_type)
    self.visible = false
