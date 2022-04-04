extends KinematicBody2D
class_name Player

var velocity := Vector2.ZERO
var speed := 45.0
var acceleration := 0.2
var state = "idle-forward"
var flipped = false
var dead = false

onready var camera : Camera2D = get_node("Camera2D")

var death = null

# Items
var has_adrenaline = false
var adrenaline_timer: int = 600
onready var adrenaline_progress: AnimatedSprite = get_node("UI/UIArea/AdrenalineAnimatedSprite")

var has_psychedelics = false
var psychedelics_timer: int = 1200
onready var psychedelics_progress: AnimatedSprite = get_node("UI/UIArea/PillAnimatedSprite")
var pill_max_effect = 20 * 60

var item_lifetime = 10 * 60 # 60 fps time 10 should mean approximately 10 seconds.


signal died
signal take_psychedelic
signal psychadelic_wears_off
signal take_adrenaline

func _ready():
	adrenaline_progress.animation = "injecting"
	psychedelics_progress.animation = "consuming"

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
		Globals._single_play()
	else:
		Globals._stop_single_play()
	
	_change_state(new_state)
	$AnimatedSprite.flip_h = flipped
	
	velocity = velocity.normalized() * speed
	if has_adrenaline:
		$AnimatedSprite.speed_scale = 1.3
		velocity = velocity * 2.0

func _physics_process(_delta):
	update_adrenaline_progress()
	update_psychedelics_progress()
	update_camera()
	update_vignette()
	velocity = move_and_slide(velocity)

func play_and_schedule_heartbeat():
	if dead:
		return
	
	Globals._play("heartbeat")
	
	var heart_rate = 1.2
	if not death:
		var deaths = get_tree().get_nodes_in_group("death")
		if len(deaths) > 0:
			death = deaths[0]
	
	if death:
		var distance_to_death = global_position.distance_to(death.global_position)
		distance_to_death = min(300, distance_to_death)
		heart_rate = 1.2 - (1.0 - (distance_to_death / 300.0)) * 1.19
	$HeartTimer.wait_time = heart_rate
	$HeartTimer.start()
	

func update_vignette():
	var vignette_scale = 0
	if not death:
		var deaths = get_tree().get_nodes_in_group("death")
		if len(deaths) > 0:
			death = deaths[0]
	
	if death:
		var distance_to_death = global_position.distance_to(death.global_position)
		distance_to_death = min(300, distance_to_death)
		vignette_scale = 1.0 - (distance_to_death / 300.0)
	
	$UI.update_vignette(vignette_scale)

func update_camera():
	var current_zoom = camera.zoom
	var target_zoom = 0.2 + ((min(psychedelics_timer,1200)/1200.0) * 0.4)
	var new_zoom = lerp(current_zoom, Vector2(target_zoom, target_zoom), 0.1)
	camera.zoom = new_zoom

func update_psychedelics_progress():
	psychedelics_timer = max(0, psychedelics_timer-1)
	psychedelics_progress.frame = (9 - min(9, psychedelics_timer/120))
	
	if psychedelics_timer == 0:
		has_psychedelics = false
		emit_signal("psychadelic_wears_off")
	elif not has_psychedelics:
		has_psychedelics = true
		emit_signal("take_psychedelic")

func update_adrenaline_progress():
	adrenaline_timer = max(0, adrenaline_timer-1)
	adrenaline_progress.frame = (9 - min(9, adrenaline_timer/60))
	
	if adrenaline_timer == 0:
		has_adrenaline = false
	elif not has_adrenaline:
		has_adrenaline = true
		emit_signal("take_adrenaline")

func _change_state(new_state):
	if new_state == "idle":
		$AnimatedSprite.playing = false
		return
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
	Globals._play('old-man-scream')
	Globals._stop_single_play()
	emit_signal("died")
	_change_state('dead')
	dead = true

func print_info():
	print(adrenaline_timer)
	print(psychedelics_timer)

func _on_HeartTimer_timeout():
	print("here")
	Globals._play("heartbeat")
