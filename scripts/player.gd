extends Area2D

@onready var sprite = $Sprite2D
@onready var up_raycast: RayCast2D = $UpRayCast2D
@onready var down_raycast: RayCast2D = $DownRayCast2D
@onready var left_raycast: RayCast2D = $LeftRayCast2D
@onready var right_raycast: RayCast2D = $RightRayCast2D
@onready var npc_tilemaplayer = %NPCs # TODO: idk if this should be a unique name...

var is_moving: bool = false
var is_top_colliding = false
var is_bottom_colliding = false
var is_left_colliding = false
var is_right_colliding = false
var movement_phase: MOVEMENT_PHASE = MOVEMENT_PHASE.IDLE
var facing: FACING_DIRECTION = FACING_DIRECTION.DOWN
var next_pos: Vector2
var up_texture = preload("res://assets/images_32x32/player_up.png")
var down_texture = preload("res://assets/images_32x32/player_down.png")
var left_texture = preload("res://assets/images_32x32/player_left.png")
var right_texture = preload("res://assets/images_32x32/player_right.png")

var dir_map: Dictionary[FACING_DIRECTION, DirectionStuff] = {}

class DirectionStuff:
	var name: String
	var raycast: RayCast2D
	var texture: Resource
	var direction: FACING_DIRECTION:
		get: return direction
		set(dir):
			direction = dir
			if dir == FACING_DIRECTION.UP:
				next_position += Vector2(0, -16)
			elif dir == FACING_DIRECTION.DOWN:
				next_position += Vector2(0, 16)
			elif dir == FACING_DIRECTION.LEFT:
				next_position += Vector2(-16, 0)
			elif dir == FACING_DIRECTION.RIGHT:
				next_position += Vector2(16, 0)
	var next_position: Vector2

	func _init(p_name: String, p_raycast: RayCast2D, p_texture: Resource, p_direction: FACING_DIRECTION) -> void:
		self.name = p_name
		self.raycast = p_raycast
		self.texture = p_texture
		self.direction = p_direction

enum FACING_DIRECTION {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}
enum MOVEMENT_PHASE {
	IDLE = 0,
	ONE = 1,
	TWO = 2,
}

func _ready() -> void:
	dir_map[FACING_DIRECTION.UP] = DirectionStuff.new("up", up_raycast, up_texture, FACING_DIRECTION.UP)
	dir_map[FACING_DIRECTION.DOWN] = DirectionStuff.new("down", down_raycast, down_texture, FACING_DIRECTION.DOWN)
	dir_map[FACING_DIRECTION.LEFT] = DirectionStuff.new("left", left_raycast, left_texture, FACING_DIRECTION.LEFT)
	dir_map[FACING_DIRECTION.RIGHT] = DirectionStuff.new("right", right_raycast, right_texture, FACING_DIRECTION.RIGHT)

func _physics_process(delta: float) -> void:
	# process movement and facing direction
	if movement_phase == MOVEMENT_PHASE.IDLE:
		for dir in dir_map:
			if Input.is_action_pressed(dir_map[dir].name):
				facing = dir
				sprite.texture = dir_map[dir].texture

		next_pos = self.position
		for dir in dir_map:
			if not is_colliding_with_boundary(dir_map[dir].raycast) and Input.is_action_pressed(dir_map[dir].name):
				movement_phase = MOVEMENT_PHASE.ONE
				break

		if movement_phase != MOVEMENT_PHASE.IDLE:
			get_next_pos()

	# check if player is interacting
	if movement_phase == MOVEMENT_PHASE.IDLE and Input.is_action_just_pressed("interact"):
		for dir in dir_map:
			if facing == dir_map[dir].direction:
				if has_custom_data_layer(dir_map[dir].raycast, "Dialog"):
					print_debug("TODO: pop open dialog menu")
					# TODO: pop open dialog menu
					pass
				elif has_custom_data_layer(dir_map[dir].raycast, "MobID") and \
					 get_custom_data_layer(dir_map[dir].raycast, "MobID") != -1:
					print_debug("TODO: pop open battle menu")
					# TODO: pop open battle menu
					pass

	if movement_phase != MOVEMENT_PHASE.IDLE:
		self.position = self.position.lerp(next_pos, delta+0.3)
		if self.position.distance_to(next_pos) <= 1:
			self.position = next_pos
			movement_phase = (movement_phase + 1) % MOVEMENT_PHASE.size() as MOVEMENT_PHASE
			get_next_pos()

func get_next_pos() -> void:
	next_pos = self.position
	for dir in dir_map:
		if not is_colliding_with_boundary(dir_map[dir].raycast) and facing == dir_map[dir].direction:
			next_pos += dir_map[dir].next_position

func is_colliding_with_boundary(raycast: RayCast2D) -> bool:
	if raycast.is_colliding():
		var other = raycast.get_collider()
		if other and other.is_in_group("boundary"):
			return true

	return false

# a strange way of getting the Custom Data from TileData from TileMapLayer
func has_custom_data_layer(raycast: RayCast2D, layer_name: String) -> bool:
	if raycast.is_colliding():
		var other = raycast.get_collider() as TileMapLayer
		if not other and other.name != "NPCs": # yucky, but TOO BAD.
			return false
		var tile_data = get_tile_data(raycast)
		var custom_data = tile_data.get_custom_data(layer_name)
		if not custom_data:
			return false
		print_debug(layer_name + ": " + str(custom_data))
	return true

func get_custom_data_layer(raycast: RayCast2D, layer_name: String) -> Variant:
	var tile_data = get_tile_data(raycast)
	return tile_data.get_custom_data(layer_name)

func get_tile_data(raycast: RayCast2D) -> TileData:
	var coords = npc_tilemaplayer.get_coords_for_body_rid(raycast.get_collider_rid())
	return npc_tilemaplayer.get_cell_tile_data(coords)
