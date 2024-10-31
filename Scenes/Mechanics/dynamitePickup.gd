extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Hi")
	Game.dynamite_remaining += 4
	Game.use_dynamite(0)
	queue_free()
