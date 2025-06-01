extends CharacterBody2D
const Utils = preload("res://src/Utils.gd")
const StatManager = preload("res://src/StatManager.gd")
var stats = StatManager.new({
	"move_speed":6, "jump":25, "drag":0.96, 
	"floor_friction":0.8, "air_control":0.2, 
	"fall_speed": 30, "dash_vel":1, "dash_time":0.05
})

var key_info = {
	"left":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"right":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"up":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"down":{"pressed":false, "last_pressed":1, "double_pressed":false},
}

const double_press_time = 0.2
var dashing = false
var dash_direction = Vector2()
var dash_start = 0
var can_dash = false

func _process(delta):
	get_input()

func _physics_process(delta):
	run_physics(delta)
	
	

func get_input():
	var dashing = false
	if Input.is_action_just_pressed("dash"):
		dashing = true	
	
	for key in key_info:
		if Input.is_action_just_pressed(key):
			if not key_info[key]["pressed"]:
				key_info[key]["pressed"] = true
				if Utils.time_difference(key_info[key]["last_pressed"]) < double_press_time:
					key_info[key]["double_pressed"] = true
		elif Input.is_action_just_released(key):
			if key_info[key]["pressed"]:
				key_info[key]["pressed"] = false
				key_info[key]["double_pressed"] = false
				key_info[key]["last_pressed"] = Utils.get_time()
		if key_info[key]["pressed"] and key in ["left","right"] and dashing:
			dashing = false
			key_info[key]["double_pressed"] = true
			
	
func run_physics(delta):
	var move_vector = Vector2(
		int(key_info["right"]["pressed"])-int(key_info["left"]["pressed"]),
		0
	)
	if is_on_floor():
		if not dashing:
			can_dash = true
		if key_info["up"]["pressed"]:
			velocity.y = -stats.jump_acceleration
	else:
		move_vector *= stats["air_control"]
	velocity += move_vector * stats.move_acceleration
	
	if can_dash:
		if key_info["left"]["double_pressed"]:
			dashing = true
		if key_info["right"]["double_pressed"]:
			dashing = true
	if dashing:
		if dash_start == 0:
			print('dash_started')
			dash_direction = move_vector.normalized()
			dash_start = Utils.get_time()
			can_dash = false
		velocity = dash_direction*stats.dash_acceleration
		if Utils.time_difference(dash_start) > stats.dash_time:
			print('dash ended')
			dash_start = 0
			dashing = false
		
	
	move_and_slide()
	
	velocity.y += stats.fall_acceleration
	velocity.y *= 0.99
	velocity.x *= 0.9
	
	

