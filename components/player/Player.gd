extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
var speed := 200.0
var acceleration := 0.2
var state = "idle-forward"
var flipped = false

# Items
var num_adrenaline = 0
var num_psychedelics = 0
var item_lifetime = 5.0

func _ready():
	pass

func _process(_delta):
	velocity = Vector2.ZERO
	var new_state = 'idle-forward'
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1.0
		new_state = 'move-up'
	elif Input.is_action_pressed("down"):
		velocity.y += 1.0
		new_state = 'move-down'
	if Input.is_action_pressed("left"):
		velocity.x -= 1.0
		new_state = 'move-side'
		flipped = true
	elif Input.is_action_pressed("right"):
		velocity.x += 1.0
		new_state = 'move-side'
		flipped = false
	
	if Input.is_action_just_pressed("print_info"):
		print_info()
	
	_change_state(new_state)
	$AnimatedSprite.flip_h = flipped
	
	velocity = velocity.normalized() * speed

# TODO(koger): Movement is snappy. Is this desirable? Do we want acceleration,
# sliding, and other effects that make it feel more slugish?
func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func _change_state(new_state):
	if new_state != state:
		state = new_state
		#$AnimatedSprite.play(state)

func handle_psychedelic(item):
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

func print_info():
	print(num_adrenaline)
	print(num_psychedelics)

