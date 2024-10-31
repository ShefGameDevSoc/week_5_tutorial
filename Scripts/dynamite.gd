extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("detonate_all"):
		explode()
	
	move_and_slide()

func explode():
	$Dynamite_sprite.hide()
	var explosion = load("res://Scenes/Mechanics/explosion.tscn").instantiate()
	Game.current_level_node.add_child(explosion)
	explosion.position.x = position.x
	explosion.position.y = position.y
	queue_free()
	
