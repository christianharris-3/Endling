extends CharacterBody2D
const Utils = preload("res://src/Utils.gd")
const StatManager = preload("res://src/StatManager.gd")
var stats = StatManager.new({"move_speed":8, "jump":0.5, "drag": 0.9, "fall_speed": 15})

var key_info = {
	"left":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"right":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"up":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"down":{"pressed":false, "last_pressed":1, "double_pressed":false},
}

const double_press_time = 0.2
var on_floor = false

func _process(delta):
	get_input()
	run_physics(delta)
	
	

func get_input():
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
			
			
	
func run_physics(delta):
	var move_vector = Vector2(
		int(key_info["right"]["pressed"])-int(key_info["left"]["pressed"]),
		0
	)
	velocity += move_vector * stats.move_acceleration * delta
	if key_info["up"]["pressed"] and on_floor:
		velocity.y = -stats.jump_acceleration
		
	velocity.y += stats.fall_acceleration * delta
	velocity *= stats.drag**delta
	print(velocity)
	
	var x_collided = move_and_collide(Vector2(velocity.x,0))
	if x_collided != null:
		velocity.x = 0
	
	var y_collided = move_and_collide(Vector2(0,velocity.y))
	if y_collided != null:
		velocity.y = 0
		if y_collided.get_position().y > position.y:
			on_floor = true
	else:
		on_floor = false
