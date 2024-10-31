extends CharacterBody2D


const SPEED = 50.0
const DECELERATION = 100
const MAX_MAUNUAL_SPEED = 200
const JUMP_VELOCITY = -300.0

const KB_VULNERABILITY = 300
const KB_VULNERABILITY_AIRBORNE = 1.5

var dead = false

func _ready():
	update_sprite_dynamite()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = 0
	if not dead:
		# Handle jump.
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if Input.is_action_just_pressed("drop_dynamite"):
			drop_dynamite()

		# Get the input direction and handle the movement/deceleration.
		direction = Input.get_axis("left", "right")
	if is_on_floor():
		# grounded motion
		if direction:
			$Legs.play()
			velocity.x = velocity.x + direction * SPEED
			if velocity.x > MAX_MAUNUAL_SPEED:
				velocity.x = MAX_MAUNUAL_SPEED
			if velocity.x < -MAX_MAUNUAL_SPEED:
				velocity.x = -MAX_MAUNUAL_SPEED
		else:
			$Legs.pause()
			velocity.x = move_toward(velocity.x, 0, DECELERATION)
	else:
		# air control
		$Legs.play()
		if direction == 1 and velocity.x < MAX_MAUNUAL_SPEED:
			velocity.x = velocity.x + direction * SPEED*0.5
		elif direction == -1 and velocity.x > -MAX_MAUNUAL_SPEED:
			velocity.x = velocity.x + direction * SPEED*0.5
		else:
			$Legs.pause()
			velocity.x = move_toward(velocity.x, 0, DECELERATION*0.3)
	
	if direction > 0:
		$Body.flip_h = false
		$Legs.flip_h = false
	if direction < 0: 
		$Body.flip_h = true
		$Legs.flip_h = true
	
	move_and_slide()


func drop_dynamite() -> void:
	if Game.dynamite_remaining > 0:
		var dynamite = load("Scenes/Mechanics/dynamite.tscn").instantiate()
		Game.current_level_node.add_child(dynamite)
		dynamite.position.x = position.x
		dynamite.position.y = position.y
		
		Game.use_dynamite(-1)
		update_sprite_dynamite()

func recieved_knockback(kb: Vector2) -> void:
	var kb_vuln = KB_VULNERABILITY
	if not is_on_floor():
		kb_vuln *= KB_VULNERABILITY_AIRBORNE
	velocity += kb*kb_vuln

func die():
	if not dead:
		dead = true
		Game.call_deferred("dying")
		

func next_level():
	Game.call_deferred("next_level")

func update_sprite_dynamite():
	if Game.dynamite_remaining > 4:
		$Body.frame = 4
	$Body.frame = Game.dynamite_remaining
	
