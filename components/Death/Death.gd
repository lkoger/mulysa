extends Area2D
class_name Death

var speed := 50.0
var state = "right"
var path := PoolVector2Array()
var player = null
var active = true

export (NodePath) var nav_tree_path = null
var nav_node = null

func _ready():
	if nav_node == null:
		nav_node = get_node(nav_tree_path)
	player = get_tree().get_nodes_in_group("player")[0]
	Globals._play_death_sound()
	modulate = Color(1,1,1,0)
	$Timer.wait_time = 30
	$Timer.start()
	
func _get_distance_to_player_and_prepare_it():
	var distance_to_player = self.global_position.distance_to(player.global_position)
	var maths = -((float(4)/50)*distance_to_player)+40
#	return clamp(maths, Globals.death_sound_min_volume, Globals.death_sound_max_volume)
	return clamp(maths, 0, 30)

func _process(delta):
	if active:
		path = nav_node.get_simple_path(self.position, player.position)
		# Calculate the movement distance for this frame
		var distance_to_walk = speed * delta
		
		# Change the volume of the scythe scraping based on distance to the player
		Globals._change_death_sound_volume(_get_distance_to_player_and_prepare_it())
		
		# Move the player along the path until he has run out of movement or the path ends.
		while distance_to_walk > 0 and path.size() > 0:
			var distance_to_next_point = position.distance_to(path[0])
			if distance_to_walk <= distance_to_next_point:
				# The player does not have enough movement left to get to the next point.
				var direction = position.direction_to(path[0])
				chage_state_based_on_direction(direction)
				position += direction * distance_to_walk
			else:
				# The player get to the next point
				position = path[0]
				path.remove(0)
			# Update the distance to walk
			distance_to_walk -= distance_to_next_point

func _physics_process(_delta):
	pass

func chage_state_based_on_direction(direction: Vector2):
	var angle = rad2deg(direction.angle())
	var new_state = "right"
	if abs(angle) <= 45:
		new_state = "right"
	elif abs(angle) >= 135:
		new_state = "left"
	elif angle > 0:
		new_state = "down"
	else:
		new_state = "up"
	
	_change_state(new_state)

func _change_state(new_state):
	if new_state != state:
		state = new_state
		$AnimatedSprite.play(state)

func _change_visibility():
	if $Tween.is_active():
		$Tween.remove_all()
	if player.has_psychedelics:
		$Tween.interpolate_property(self, "modulate", modulate, Color(1,1,1,0.03), 1.5)
		$Tween.start()
	else:
		$Tween.interpolate_property(self, "modulate", modulate, Color(1,1,1,0), 1.5)
		$Tween.start()

func _on_Death_body_entered(body):
	if body.has_method("die"):
		Globals._stop_death_sound()
		body.die()

func _on_Player_died():
	active = false
	print("here")
	_change_state("idle")
	# Make visible on player death
	if $Tween.is_active():
		$Tween.remove_all()
	#modulate = Color(1,1,1,1)
	$Tween.interpolate_property(self, "modulate", modulate, Color(1,1,1,1), 1.0)
	$Tween.start()


func _on_Player_take_psychedelic():
	if active:
		_change_visibility()


func _on_Player_psychadelic_wears_off():
	if active:
		_change_visibility()
		
func _on_Timer_timeout():
	if speed < 100:
		speed += 5
		$Timer.wait_time = 30
		$Timer.start()
