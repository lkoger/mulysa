extends KinematicBody2D
class_name Death

var velocity := Vector2.ZERO
var speed := 150.0
var acceleration := 0.2
var state = "idle-forward"
var flipped = false
var path := PoolVector2Array()
var player = null


func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	pass

func _process(_delta):
	
	
	path = self.get_parent().get_simple_path(self.position, player.position)
	
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * _delta
	
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

	
	#velocity = velocity.normalized() * speed

# TODO(koger): Movement is snappy. Is this desirable? Do we want acceleration,
# sliding, and other effects that make it feel more slugish?
func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func _change_state(new_state):
	if new_state != state:
		state = new_state
		#$AnimatedSprite.play(state)
		
		

