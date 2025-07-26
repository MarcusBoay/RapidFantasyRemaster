class_name LootTable
extends Resource

@export var no_drop_weight: int
@export var items: Dictionary[Item, int] # value is weight

# Returns item id for a roll, otherwise, returns -1 (no item)
func get_item_id() -> int:
    var roll = randi_range(0, get_total_weight())
    var cur_weight = no_drop_weight

    for item in items:
        if roll >= cur_weight and roll < cur_weight + item.second:
            return item.first
        cur_weight += item.second

    return -1

func get_total_weight() -> int:
    var all_items_weight: int = 0
    for item in items:
        all_items_weight += items[item]
    return all_items_weight + no_drop_weight
