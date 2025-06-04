extends "res://src/spells/Spell.gd"

var velocity = Vector2()
var gravity = 40
var speed = 200
var in_final_animation = false

func setup(angle, pos: Vector2):
	velocity = Vector2.from_angle(angle)*speed
	position = pos

func _ready():
	play("moving")

func _physics_process(delta):
	
	position += velocity * delta
	
	if not in_final_animation:
		velocity.y += gravity * delta
		if collided():
			play("spark")
			deal_damage()
			in_final_animation = true
			velocity = Vector2()
	else:
		if not is_playing():
			dead = true
			
func collided():
	var space_state = get_world_2d().direct_space_state
	var point_query = PhysicsPointQueryParameters2D.new()
	point_query.position = position
	var point_result = space_state.intersect_point(point_query)
	for collided in point_result:
		if collided["collider"].get("OBJ_TYPE") != "player":
			return true
	return false
