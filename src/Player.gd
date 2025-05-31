extends CharacterBody2D
const Utils = preload("res://src/Utils.gd")

var key_info = {
	"left":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"right":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"up":{"pressed":false, "last_pressed":1, "double_pressed":false},
	"down":{"pressed":false, "last_pressed":1, "double_pressed":false},
}
const double_press_time = 0.2

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
	velocity += move_vector * 0.2
	velocity.y += 0.2
	if key_info["up"]["pressed"]:
		key_info["up"]["pressed"] = false
		velocity.y-=6
	
	velocity *= 0.97
	
	
	move_and_collide(Vector2(velocity.x,0))
	move_and_collide(Vector2(0,velocity.y))
