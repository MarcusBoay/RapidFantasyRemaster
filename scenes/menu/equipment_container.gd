extends VBoxContainer

@onready var weapon_button: Button = $WeaponButton
@onready var armor_button: Button = $ArmorButton
@onready var accessory_button: Button = $AccessoryButton

func _ready() -> void:
    EventBus.player_equip_new.connect(equip)

func populate_equipment_container() -> void:
    if PlayerManager.equips.weapon:
        weapon_button.text = PlayerManager.equips.weapon.name
    else:
        weapon_button.text = "-"

    if PlayerManager.equips.armor:
        armor_button.text = PlayerManager.equips.armor.name
    else:
        armor_button.text = "-"

    if PlayerManager.equips.accessory:
        accessory_button.text = PlayerManager.equips.accessory.name
    else:
        accessory_button.text = "-"

func equip(equip: Item, item_type: Globals.ItemType) -> void:
    if equip:
        match equip.item_type:
            Globals.ItemType.WEAPON:
                weapon_button.text = equip.name
            Globals.ItemType.ARMOR:
                armor_button.text = equip.name
            Globals.ItemType.ACCESSORY:
                accessory_button.text = equip.name
    else:
        unequip(item_type)

func unequip(item_type: Globals.ItemType) -> void:
    match item_type:
        Globals.ItemType.WEAPON:
            weapon_button.text = "-"
        Globals.ItemType.ARMOR:
            armor_button.text = "-"
        Globals.ItemType.ACCESSORY:
            accessory_button.text = "-"
