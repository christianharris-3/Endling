extends Object

const pixels_per_tile = 16

static func get_time() -> float:
	return Time.get_unix_time_from_system()

static func time_difference(unix_time: float) -> float:
	return get_time()-unix_time
	
static func val_to_world_val(val: float) -> float:
	return val*pixels_per_tile

static func pos_to_world_pos(pos: Vector2) -> Vector2:
	return pos*pixels_per_tile
	
