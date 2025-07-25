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

func equip(equipment: Item, item_type: Globals.ItemType) -> void:
    match item_type:
        Globals.ItemType.WEAPON:
            weapon_button.text = equipment.name if equip else "-"
        Globals.ItemType.ARMOR:
            armor_button.text = equipment.name if equip else "-"
        Globals.ItemType.ACCESSORY:
            accessory_button.text = equipment.name if equip else "-"
