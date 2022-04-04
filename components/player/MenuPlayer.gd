extends KinematicBody2D

var velocity := Vector2.ZERO
var speed := 45.0
var state = "idle"
var flipped = false

func _process(_delta):
	velocity = Vector2.ZERO
	var new_state = 'idle'
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1.0
		new_state = 'up'
	elif Input.is_action_pressed("down"):
		velocity.y += 1.0
		new_state = 'down'
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
		if new_state == 'up':
			new_state = 'up-side'
		elif new_state == 'down':
			new_state = 'down-side'
		else:
			new_state = 'side'
		flipped = true
	elif Input.is_action_pressed("right"):
		velocity.x += 1.0
		if new_state == 'up':
			new_state = 'up-side'
		elif new_state == 'down':
			new_state = 'down-side'
		else:
			new_state = 'side'
		flipped = false
		
	if not 'idle' in new_state:
		Globals._single_play()
	else:
		Globals._stop_single_play()
	
	_change_state(new_state)
	$AnimatedSprite.flip_h = flipped
	
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func _change_state(new_state):
	if new_state == "idle":
		$AnimatedSprite.playing = false
		return
	if new_state != state:
		state = new_state
		$AnimatedSprite.play(state)
