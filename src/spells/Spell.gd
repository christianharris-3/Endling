extends AnimatedSprite2D

var damage = 5
var aoe_radius = 5
var knockback = 4
var dead = false

func _init():
	pass
	
func deal_damage():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.radius = aoe_radius
	query.transform = Transform2D(0, position)
	var result = space_state.intersect_shape(query)
	for collided in result:
		if collided["collider"].get("OBJ_TYPE") == "enemy":
			collided["collider"].take_damage(damage, knockback, position)
	
