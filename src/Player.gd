extends "res://src/GameObject.gd"
const Utils = preload("res://src/Utils.gd")
var spark_scene = load("res://scenes/Spells/Spark.tscn")

var key_info = {}
var mouse_pos = Vector2()

const OBJ_TYPE = "player"
const double_press_time = 0.2

#### movement variables
## move controls
var dash_speed = 200
var dash_time = 0.15

## dash vars
var dashing = false
var last_direction = Vector2()
var dash_direction = Vector2()
var dash_start = 0
var can_dash = false
var dash_cooldown = 0.5

func _init():
	super(8, 160, 7, false)
	var keys = ["left", "right", "down", "up", "dash", "click"]
	for k in keys:
		key_info[k] = {"pressed":false, "just_pressed":false, "last_pressed":1, "double_pressed":false}

func process(delta):
	get_input()

func physics_process(delta):
	character_control(delta)

func get_input():
	for key in key_info:
		key_info[key]["just_pressed"] = false
		
		if Input.is_action_just_pressed(key):
			key_info[key]["just_pressed"] = true
			if not key_info[key]["pressed"]:
				key_info[key]["pressed"] = true
				if Utils.time_difference(key_info[key]["last_pressed"]) < double_press_time:
					key_info[key]["double_pressed"] = true
		elif Input.is_action_just_released(key):
			if key_info[key]["pressed"]:
				key_info[key]["pressed"] = false
				key_info[key]["double_pressed"] = false
				key_info[key]["last_pressed"] = Utils.get_time()
	mouse_pos = get_global_mouse_position()
			
	
func character_control(delta):
	var keys = [int(key_info["right"]["pressed"]), int(key_info["left"]["pressed"]), int(key_info["down"]["pressed"]), int(key_info["up"]["pressed"])]
	for i in keys:
		if i != 0:
			last_direction = Vector2(keys[0]-keys[1], keys[2]-keys[3])
			break
	
	if keys[0]-keys[1]>0:
		$Kyro.scale = Vector2(1,1)
	elif keys[0]-keys[1]<0:
		$Kyro.scale = Vector2(-1,1)
	
	## jumping and dashing
	if is_on_floor():
		if not dashing:
			can_dash = true
		if key_info["up"]["pressed"]:
			start_jump()
	velocity.x += (int(key_info["right"]["pressed"])-int(key_info["left"]["pressed"])) * move_acceleration

	if can_dash and Utils.time_difference(dash_start) > dash_cooldown:
		if key_info["dash"]["just_pressed"]:
			start_dash()
	if dashing:
		velocity = dash_direction*dash_speed
		if Utils.time_difference(dash_start) > dash_time:
			end_dash()

func attack():
	## attacking
	if key_info["click"]["just_pressed"]:
		var new_spell = spark_scene.instantiate()
		new_spell.setup((mouse_pos-position).angle(), position)
		return [new_spell]
		
	return []
		
func start_jump():
	velocity.y = -jump_acceleration

func start_dash():
	dash_direction = last_direction.normalized()
	dash_start = Utils.get_time()
	can_dash = false
	dashing = true
	$Dashparticles.restart()

func end_dash():
	dashing = false
