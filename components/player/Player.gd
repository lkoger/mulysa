extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
var speed := 45.0
var acceleration := 0.2
var state = "idle-forward"
var flipped = false

# Items
var has_adrenaline = true
var adrenaline_timer = 600
onready var adrenaline_progress: TextureProgress = get_node("UI/UIArea/AdrenalineProgressBar")
var has_psychedelics = true
var psychedelics_timer = 600
var item_lifetime = 10 * 60 # 60 fps time 10 should mean approximately 10 seconds.


signal died
signal take_psychedelic
signal psychadelic_wears_off
signal take_adrenaline

func _ready():
	pass

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
		
	if Input.is_action_just_pressed("print_info"):
		print_info()
		
	if not 'idle' in new_state:
		Globals._single_play('wheelchair')
	else:
		Globals._stop_single_play('wheelchair')
	
	_change_state(new_state)
	$AnimatedSprite.flip_h = flipped
	
	velocity = velocity.normalized() * speed
	if has_adrenaline:
		$AnimatedSprite.speed_scale = 1.3
		velocity = velocity * 2.0

func update_psychedelics_progress():
	psychedelics_timer = max(0, psychedelics_timer-1)
	#psychedelics_progress.value = min((psychedelics_timer/6), 100)
	if psychedelics_timer == 0:
		has_psychedelics = false
		emit_signal("psychadelic_wears_off")

func update_adrenaline_progress():
	adrenaline_timer = max(0, adrenaline_timer-1)
	adrenaline_progress.value = min((adrenaline_timer/6), 100)
	if adrenaline_timer == 0:
		has_adrenaline = false
	
# TODO(koger): Movement is snappy. Is this desirable? Do we want acceleration,
# sliding, and other effects that make it feel more slugish?
func _physics_process(_delta):
	update_adrenaline_progress()
	velocity = move_and_slide(velocity)

func _change_state(new_state):
	if new_state != state:
		state = new_state
		$AnimatedSprite.play(state)

func handle_psychedelic(item):
	Globals._play('usePsychedelic')
	psychedelics_timer += item_lifetime
	has_psychedelics = true
	emit_signal("take_psychedelic")

func handle_adrenaline(item):
	Globals._play('useAdrenaline')
	adrenaline_timer += item_lifetime
	has_adrenaline = true
	emit_signal("take_adrenaline")


func die():
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	set_process(false)
	Globals._stop_single_play('wheelchair')
	emit_signal("died")
	_change_state('dead')
	

func print_info():
	print(adrenaline_timer)
	print(psychedelics_timer)


