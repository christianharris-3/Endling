extends Object

static func get_time() -> float:
	return Time.get_unix_time_from_system()

static func time_difference(unix_time: float) -> float:
	return get_time()-unix_time
