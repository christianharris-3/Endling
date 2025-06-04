extends CharacterBody2D

var gravity = 7
var move_acceleration = 6
var jump_acceleration = 140
var move_keys = {'lr':0, 'jump':false}
var super_does_movement = false

var dead = false

func _init(move_speed=6, jump_speed=140, fall_speed=7, super_has_movement=true):
	move_acceleration = move_speed
	jump_acceleration = jump_speed
	gravity = fall_speed
	super_does_movement = super_has_movement

func _process(delta):
	process(delta)
	
func _physics_process(delta):
	physics_process(delta)
	do_physics(delta)

func process(delta): pass
func physics_process(delta): pass

func do_physics(delta):
	if super_does_movement:
		var move_dir = move_keys['lr']
		velocity.x -= move_dir * move_acceleration
		if is_on_floor():
			if move_keys['jump']:
				velocity.y = -jump_acceleration
		
	move_and_slide()
	
	velocity.y += gravity
	velocity.y *= 0.99
	velocity.x *= 0.9
