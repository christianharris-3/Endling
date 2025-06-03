extends CharacterBody2D

var in_shell = true

func process(player):
	if position.distance_to(player.position) < 500:
		get_out_of_shell()
		self.position.x-=1
		$Sprite.play("walk")
	else:
		get_in_shell()


func get_out_of_shell():
	if in_shell:
		in_shell = false
		$Sprite.play("get_up")

func get_in_shell():
	if not in_shell:
		in_shell = true
		$Sprite.play_backwards("get_up")
