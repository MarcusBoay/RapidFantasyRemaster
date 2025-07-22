extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TEST STUFF
func _on_add_hp_pressed() -> void:
	EventBus.player_hp_changed.emit(randi_range(-5, 5))
	EventBus.player_mp_changed.emit(randi_range(-5, 5))
	EventBus.player_level_changed.emit(randi_range(-5, 5))
	EventBus.player_exp_changed.emit(randi_range(-5, 5))
	EventBus.player_limit_changed.emit(randi_range(-5, 5))
	EventBus.player_strength_changed.emit(randi_range(-5, 5))
	EventBus.player_wisdom_changed.emit(randi_range(-5, 5))
	EventBus.player_defense_changed.emit(randi_range(-5, 5))
	EventBus.player_gold_changed.emit(randi_range(-5, 5))

func _on_minus_hp_pressed() -> void:
	EventBus.player_hp_changed.emit(-3)
