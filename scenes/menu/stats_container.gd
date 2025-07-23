extends VBoxContainer

@onready var hp_label = %HPLabel
@onready var mp_label = %MPLabel
@onready var level_label = %LevelLabel
@onready var exp_label = %ExpLabel
@onready var limit_label = %LimitLabel
@onready var strength_label = %StrengthLabel
@onready var wisdom_label = %WisdomLabel
@onready var defense_label = %DefenseLabel
@onready var gold_label = %GoldLabel

func _ready() -> void:
    set_initial_stats()
    connect_signals()

func set_initial_stats():
    set_hp_label(PlayerManager.stats.hp)
    set_mp_label(PlayerManager.stats.mp)
    set_level_label(PlayerManager.stats.level)
    set_exp_label(PlayerManager.stats.experience)
    set_limit_label(PlayerManager.limit)
    set_strength_label(PlayerManager.stats.strength)
    set_wisdom_label(PlayerManager.stats.wisdom)
    set_defense_label(PlayerManager.stats.defense)
    set_gold_label(PlayerManager.stats.gold)

func set_hp_label(x: int):
    hp_label.text = "HP: " + str(x) + " / " + str(PlayerManager.stats.hp_max)

func set_mp_label(x: int):
    mp_label.text = "MP: " + str(x) + " / " + str(PlayerManager.stats.mp_max)

func set_level_label(x: int):
    level_label.text = "Level: " + str(x)

func set_exp_label(x: int):
    exp_label.text = "Exp: " + str(x)

func set_limit_label(x: int):
    limit_label.text = "Limit: " + str(x)

func set_strength_label(x: int):
    strength_label.text = "Strength: " + str(x)

func set_wisdom_label(x: int):
    wisdom_label.text = "Wisdom: " + str(x)

func set_defense_label(x: int):
    defense_label.text = "Defense: " + str(x)

func set_gold_label(x: int):
    gold_label.text = "Gold: " + str(x)


# Signals
func connect_signals():
    EventBus.player_hp_new.connect(set_hp_label)
    EventBus.player_mp_new.connect(set_mp_label)
    EventBus.player_level_new.connect(set_level_label)
    EventBus.player_exp_new.connect(set_exp_label)
    EventBus.player_limit_new.connect(set_limit_label)
    EventBus.player_strength_new.connect(set_strength_label)
    EventBus.player_wisdom_new.connect(set_wisdom_label)
    EventBus.player_defense_new.connect(set_defense_label)
    EventBus.player_gold_new.connect(set_gold_label)
