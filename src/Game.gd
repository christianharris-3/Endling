extends Node2D

var players = []
var enemies = []

func _ready():
	players.append($Player)

func _process(delta):
	for e in enemies:
		e.manage_ai(players)
	
	var new_enemies = $Spawner.make_enemies($Map.get_child(0))
	for e in new_enemies:
		enemies.append(e)
		$".".add_child(e)
