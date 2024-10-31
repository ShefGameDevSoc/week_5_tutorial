extends Area2D

func _on_body_entered(body):
	die()

func die():
	Game.score += 1
	print(Game.score)
	queue_free()
