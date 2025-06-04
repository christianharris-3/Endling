extends Node2D
const Utils = preload("res://src/Utils.gd")

@export var spawn_limit: int = 2
@export var spawn_delay_min: float = 8
@export var spawn_delay_max: float = 16
@export var spawn_area: Vector2 = Vector2(200,200)
@export var air_spawns: bool = false
@export var enemy_path: String = "res://scenes/Crytter.tscn"
var enemy_scene = load(enemy_path)

var spawned_enemies = []
var spawn_delay = 0
		
func make_enemies(tilemap):
	var enemies = 0
	for e in spawned_enemies:
		if e and not e.dead:
			enemies+=1
	
	if enemies < spawn_limit:
		if Utils.time_difference(spawn_delay)>0:
			spawn_delay = Utils.get_time() + Utils.random_range(spawn_delay_min, spawn_delay_max)
			var new_enemy = enemy_scene.instantiate()
			new_enemy.position = get_valid_spawn_location()
			spawned_enemies.append(new_enemy)
			return [new_enemy]
	return []

func get_valid_spawn_location():
	
	var validation_info = [false, position]
	while not validation_info[0]:
		validation_info = location_valid(Vector2(
			Utils.random_randint(position.x, position.x+spawn_area.x),
			Utils.random_randint(position.y, position.y+spawn_area.y)
		))
	return validation_info[1]

func location_valid(pos):
	var space_state = get_world_2d().direct_space_state
	
	#var query_short = PhysicsRayQueryParameters2D.create(pos, pos+Vector2(0, 2))
	#var result_short = space_state.intersect_ray(query_short)
	var point_query = PhysicsPointQueryParameters2D.new()
	point_query.position = pos
	var point_result = space_state.intersect_point(point_query)
	
	var query = PhysicsRayQueryParameters2D.create(pos, pos+Vector2(0, 32))
	var result = space_state.intersect_ray(query)
	
	if result.size()>0 and point_result.size() == 0:
		if result["collider"].get("OBJ_TYPE") == null: # true if type is a tile
			return [true, result["position"]]
	return [false, pos]
