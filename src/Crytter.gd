extends "res://src/GameObject.gd"
const Utils = preload("res://src/Utils.gd")

const OBJ_TYPE = "enemy"
var state = 'in_shell'
var target = null
var idle_walking_cooldown = 0
var idle_walking_timer = 0

func _init():
	super()

func manage_ai(targets):
	if ($Sprite.animation in ["get_up", "return_to_shell"] and $Sprite.is_playing()):
		move_keys['lr'] = 0
		return
	if state == 'in_shell':
		$Sprite.play("in_shell")
		for t in targets:
			if position.distance_to(t.position) < 200:
				state = 'idle'
				idle_walking_timer = Utils.get_time() + Utils.random_range(3,5)
				idle_walking_cooldown = idle_walking_timer + Utils.random_range(1,5)
				$Sprite.play("get_up")
				target = t
				break
	elif state == 'idle':
		if not $Sprite.is_playing():
			$Sprite.play("idle")
		elif $Sprite.animation == "walk":
			if abs(velocity.x) < 1:
				idle_walking_cooldown = 0
		if position.distance_to(target.position) < 100:
			state = 'attacking'
		elif position.distance_to(target.position) > 250:
			state = 'in_shell'
			target = null
			$Sprite.play("return_to_shell")
			return
		
		if Utils.time_difference(idle_walking_cooldown)>0:
			idle_walking_timer = Utils.get_time() + Utils.random_range(0.5,1.5)
			idle_walking_cooldown = idle_walking_timer + Utils.random_range(1,5)
			move_keys['lr'] = Utils.random_choice([-0.5, 0.5])
			$Sprite.play("walk")
			flip_sprite()
		
		if Utils.time_difference(idle_walking_timer)>0:
			move_keys['lr'] = 0
			$Sprite.play("idle")
		else:
			if is_on_floor():
				$Sprite.play("walk")
			else:
				$Sprite.play("jump")
			
	elif state == 'attacking':
		if position.distance_to(target.position) > 150:
			state = 'idle'
			move_keys['lr'] = 0
			move_keys['jump'] = false
		var rel_pos = position-target.position
		if rel_pos.x<-10:
			move_keys['lr'] = -1
		elif rel_pos.x>10:
			move_keys['lr'] = 1
		flip_sprite()
		
		move_keys['jump'] = false
		if is_on_floor():
			if abs(velocity.x)>10:
				$Sprite.play("walk")
			else:
				$Sprite.play("idle")
				move_keys['jump'] = true
		else:
			$Sprite.play("jump")

func flip_sprite():
	if move_keys['lr']<0:
		$Sprite.scale = Vector2(-1,1)
	elif move_keys['lr']>0:
		$Sprite.scale = Vector2(1,1)
