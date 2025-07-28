extends VBoxContainer


@onready var hp_label: Label = $HPLabel
@onready var hp_bar: TextureProgressBar = $HPBar
@onready var mp_label: Label = $MPLabel
@onready var mp_bar: TextureProgressBar = $MPBar
@onready var limit_label: Label = $LimitLabel
@onready var limit_bar: TextureProgressBar = $LimitBar


func _ready() -> void:
    update_hp(PlayerManager.stats.hp)
    update_mp(PlayerManager.stats.mp)
    update_limit(PlayerManager.limit)
    connect_signals()
    _animate_start()

func _animate_start() -> void:
    var original_position = global_position
    var left_position = Vector2(original_position.x - size.x, original_position.y)
    var original_modulate = modulate
    modulate.a = 0

    var subtween = get_tree().create_tween().set_parallel(true)
    subtween.tween_property(self, "position", original_position, 0.5).set_trans(Tween.TRANS_CUBIC)
    subtween.tween_property(self, "modulate", original_modulate, 0.5).set_trans(Tween.TRANS_CUBIC)

    var tween = get_tree().create_tween()
    tween.tween_property(self, "position", left_position, 0.0)
    tween.tween_subtween(subtween)


func connect_signals() -> void:
    PlayerSignals.player_hp_new.connect(update_hp)
    PlayerSignals.player_mp_new.connect(update_mp)
    PlayerSignals.player_limit_new.connect(update_limit)


func update_hp(hp: int) -> void:
    hp_bar.value = hp
    hp_label.text = "HP: " + str(hp) + " / " + str(PlayerManager.stats.hp_max)


func update_mp(mp: int) -> void:
    mp_bar.value = mp
    mp_label.text = "MP: " + str(mp) + " / " + str(PlayerManager.stats.mp_max)


func update_limit(limit: int) -> void:
    limit_bar.value = limit
