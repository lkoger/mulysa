extends Area2D
class_name Death

var velocity := Vector2.ZERO
var speed := 50.0
var acceleration := 0.2
var state = "idle-forward"
var flipped = false
var path := PoolVector2Array()
var player = null

export (NodePath) var nav_tree_path = null
onready var nav_node : Navigation2D = get_node(nav_tree_path)

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	Globals._play_death_sound()
	pass
	
func _get_distance_to_player_and_prepare_it():
	var distance_to_player = self.global_position.distance_to(player.global_position)
	var maths = -((float(4)/50)*distance_to_player)+40
	return clamp(maths, 0, 30)

func _process(delta):
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
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

func _move():
	for p in nav_node.path:
		pass

func _physics_process(_delta):
	#velocity = move_and_slide(velocity)
	pass

func _change_state(new_state):
	if new_state != state:
		state = new_state
		#$AnimatedSprite.play(state)
		
func _on_Death_body_entered(body):
	if body.has_method("die"):
		body.die()
		

