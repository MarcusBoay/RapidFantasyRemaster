class_name PlayerOverworld
extends Area2D

enum MOVEMENT_PHASE {
    IDLE = 0,
    ONE = 1,
    TWO = 2,
}


var is_moving: bool = false
var is_top_colliding = false
var is_bottom_colliding = false
var is_left_colliding = false
var is_right_colliding = false
var movement_phase: MOVEMENT_PHASE = MOVEMENT_PHASE.IDLE
var facing: Globals.FACING_DIRECTION = Globals.FACING_DIRECTION.DOWN
var next_pos: Vector2
var up_texture = preload("res://assets/player/player_up.png")
var down_texture = preload("res://assets/player/player_down.png")
var left_texture = preload("res://assets/player/player_left.png")
var right_texture = preload("res://assets/player/player_right.png")

var menu_opening: bool = false

# probably better to put this into some independent node...
var enemy_spawn_chance_weight: int = 10 # higher weight == lower chance of enemy spawns

var dir_map: Dictionary[Globals.FACING_DIRECTION, DirectionStuff] = {}

@onready var sprite = $Sprite2D
@onready var up_raycast: RayCast2D = $UpRayCast2D
@onready var down_raycast: RayCast2D = $DownRayCast2D
@onready var left_raycast: RayCast2D = $LeftRayCast2D
@onready var right_raycast: RayCast2D = $RightRayCast2D
@onready var npc_tilemaplayer: TileMapLayer

### Lifecycle
func _ready() -> void:
    dir_map[Globals.FACING_DIRECTION.UP] = DirectionStuff.new("up", up_raycast, up_texture, Globals.FACING_DIRECTION.UP)
    dir_map[Globals.FACING_DIRECTION.DOWN] = DirectionStuff.new("down", down_raycast, down_texture, Globals.FACING_DIRECTION.DOWN)
    dir_map[Globals.FACING_DIRECTION.LEFT] = DirectionStuff.new("left", left_raycast, left_texture, Globals.FACING_DIRECTION.LEFT)
    dir_map[Globals.FACING_DIRECTION.RIGHT] = DirectionStuff.new("right", right_raycast, right_texture, Globals.FACING_DIRECTION.RIGHT)

func _physics_process(delta: float) -> void:
    # process movement and facing direction
    if movement_phase == MOVEMENT_PHASE.IDLE:
        if Input.is_action_just_pressed("menu"):
            menu_opening = true
            PlayerManager.save_player_overworld(self)
            # switch scene to menu
            SceneLoader.load_scene("res://assets/menu/menu.tscn")

        # do not process movement if menu is currently opening
        if menu_opening:
            return

        # face some direction
        for dir in dir_map:
            if Input.is_action_pressed(dir_map[dir].name):
                facing = dir
                sprite.texture = dir_map[dir].texture

        next_pos = self.position
        # attempt to move in some direction
        for dir in dir_map:
            if not is_colliding_with_boundary(dir_map[dir].raycast) and Input.is_action_pressed(dir_map[dir].name):
                movement_phase = MOVEMENT_PHASE.ONE
                break

        # get next position because we are now moving
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

        # this will execute once after player has finishes moving
        if movement_phase == MOVEMENT_PHASE.IDLE:
            try_spawning_enemy()


### Misc

func set_facing_texture() -> void:
    sprite.texture = dir_map[facing].texture

# kinda yucky to have this in the player script...
# probably better to have some enemy spawner node to do this...
func try_spawning_enemy() -> void:
    print("attempting to spawn mob...")
    var enemies = Globals.current_area.enemies
    # only attempt to spawn in areas that have enemies
    if enemies.size() > 0:
        # spawn an enemy at random equal chance
        var should_enemy_spawn = (randi_range(0, enemy_spawn_chance_weight) == 0)
        if should_enemy_spawn:
            var enemy_id = randi_range(0, enemies.size()-1)
            var enemy = enemies[enemy_id]
            print(enemy.enemy_stats.name + " is spawning!!!")

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
        if not other or other.name != "NPCs": # yucky, but TOO BAD.
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

# class to group all the related direction variables...
class DirectionStuff:
    var name: String
    var raycast: RayCast2D
    var texture: Resource
    var direction: Globals.FACING_DIRECTION:
        get: return direction
        set(dir):
            direction = dir
            if dir == Globals.FACING_DIRECTION.UP:
                next_position += Vector2(0, -16)
            elif dir == Globals.FACING_DIRECTION.DOWN:
                next_position += Vector2(0, 16)
            elif dir == Globals.FACING_DIRECTION.LEFT:
                next_position += Vector2(-16, 0)
            elif dir == Globals.FACING_DIRECTION.RIGHT:
                next_position += Vector2(16, 0)
    var next_position: Vector2

    func _init(p_name: String, p_raycast: RayCast2D, p_texture: Resource, p_direction: Globals.FACING_DIRECTION) -> void:
        self.name = p_name
        self.raycast = p_raycast
        self.texture = p_texture
        self.direction = p_direction
