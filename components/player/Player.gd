extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
var speed := 45.0
var acceleration := 0.2
var state = "idle-forward"
var flipped = false

# Items
var num_adrenaline = 0
var max_adrenaline = 3
var num_psychedelics = 0
var max_psychedelics = 3
var item_lifetime = 10.0


signal died

func _ready():
	pass

func _process(_delta):
#	if num_adrenaline > max_adrenaline or num_psychedelics > max_psychedelics:
#		die()
#		return
	
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
		new_state = 'side'
		flipped = true
	elif Input.is_action_pressed("right"):
		velocity.x += 1.0
		new_state = 'side'
		flipped = false
	
	if Input.is_action_just_pressed("print_info"):
		print_info()
		
	if not 'idle' in new_state:
		Globals._single_play('wheelchair')
	else:
		Globals._stop_single_play('wheelchair')
	
	_change_state(new_state)
	$AnimatedSprite.flip_h = flipped
	
	velocity = velocity.normalized() * speed
	velocity = velocity * (1.0 + (min(num_adrenaline, 3) / 1.5))
	$AnimatedSprite.speed_scale = (1.0 + (min(num_adrenaline, 3) / 1.5))
	

# TODO(koger): Movement is snappy. Is this desirable? Do we want acceleration,
# sliding, and other effects that make it feel more slugish?
func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func _change_state(new_state):
	if new_state != state:
		state = new_state
		$AnimatedSprite.play(state)

func handle_psychedelic(item):
	#Globals._play('usePsychedelic')
	num_psychedelics += 1
	var timer: Timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(item_lifetime)
	timer.connect("timeout", self, "decrement_psychadelic")
	timer.connect("timeout", timer, "queue_free")
	add_child(timer)
	timer.start()

func decrement_psychadelic():
	num_psychedelics -= 1

func handle_adrenaline(item):
	#Globals._play('useAdrenaline')
	num_adrenaline += 1
	var timer: Timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(item_lifetime)
	timer.connect("timeout", self, "decrement_adrenaline")
	timer.connect("timeout", timer, "queue_free")
	add_child(timer)
	timer.start()

func decrement_adrenaline():
	num_adrenaline -= 1

func die():
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	set_process(false)
	emit_signal("died")
	

func print_info():
	print(num_adrenaline)
	print(num_psychedelics)


