extends Node2D

var players = []
var enemies = []
var projectiles = []

func _ready():
	players.append($Player)

func _process(delta):
	for p in players:
		var new_projectiles = p.attack()
		for proj in new_projectiles:
			projectiles.append(proj)
			$".".add_child(proj)
	
	for e in enemies:
		e.manage_ai(players)
	
	var new_enemies = $Spawner.make_enemies($Map.get_child(0))
	for e in new_enemies:
		enemies.append(e)
		$".".add_child(e)
	
	players = clear_dead(players)
	enemies = clear_dead(enemies)
	projectiles = clear_dead(projectiles)

func clear_dead(array):
	var new_array = []
	for obj in array:
		if obj.dead:
			obj.queue_free()
		else:
			new_array.append(obj)
	return new_array
