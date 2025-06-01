extends Object

const Utils = preload("res://src/Utils.gd")

var jump_height = 3
var move_speed = 3
var has_dash = false
var has_double_jump = false
var drag = 0.95
var drag_per_tick = 0.95
var floor_friction = 0.8
var air_control = 0.5
var fall_speed = 3
var jump = 2
var dash_vel = 2
var dash_time = 2

var move_acceleration = 1
var fall_acceleration = 1
var jump_acceleration = 1
var dash_acceleration = 1

func _init(stats):
	if "move_speed" in stats:
		move_speed = stats["move_speed"]
	if "jump_height" in stats:
		jump_height = stats["jump_height"]
	if "jump" in stats:
		jump = stats["jump"]
	if "has_dash" in stats:
		has_dash = stats["has_dash"]
	if "dash_vel" in stats:
		dash_vel = Utils.val_to_world_val(stats["dash_vel"])
	if "dash_time" in stats:
		dash_time = stats["dash_time"]
	if "has_double_jump" in stats:
		has_double_jump = stats["has_double_jump"]
	if "fall_speed" in stats:
		fall_speed = stats["fall_speed"]
		
	if "drag" in stats:
		drag = stats["drag"]
	if "floor_friction" in stats:
		floor_friction = stats["floor_friction"]
	if "air_control" in stats:
		air_control = stats["air_control"]
	
	calculate_values()

func calculate_values():
	move_acceleration = (1.0-(drag*floor_friction))/(drag*floor_friction) * Utils.val_to_world_val(move_speed)
	fall_acceleration = (1.0-drag)/drag * Utils.val_to_world_val(fall_speed)
	
	jump_acceleration = Utils.val_to_world_val(jump)
	dash_acceleration = Utils.val_to_world_val(dash_vel)
	
	# code to calculate jump acceleration from an input: jump height, gravity, drag
	#jump_acceleration = _solve_equation(Utils.val_to_world_val(jump_height), drag_per_tick, fall_acceleration)
	

func _solve_equation(h, d, g):
	
	var v0 = 1
	for i in range(20):
		print(str(i)+" -> v0:"+str(v0)+" h:"+str(h)+" d:"+str(d)+" g:"+str(g))
		var n = jump_info_to_steps(v0, d, g)
		v0 = (h+(g*d)/(1-d)*(n-(d*(1-d**n)/(1-d))))/(d*(1-d**n)/(1-d))
	return v0
		

func jump_info_to_steps(v0:float, d:float, g:float) -> int:
	var v = v0
	var n = 0
	while v>0:
		n+=1
		v = (v-g)*d
	return n
	
	
	
