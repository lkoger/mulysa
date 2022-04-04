extends Area2D

var adrenaline_scene = preload("res://components/items/adrenaline/Adrenaline.tscn")
var psychedelic_scene = preload("res://components/items/psychedelic/Psychedelic.tscn")
export var just_adrenaline = false

var full = false

func _ready():
	start_timer()

func _process(_delta):
	pass

func start_timer():
	$Timer.wait_time = (randf() * 10.0) + 5.0
	$Timer.start()

func _on_Timer_timeout():
	# 1 in 3 change of spawning an item
	var i = randi() % 3
	if i == 0:
		i = randi() % 3
		# 2 in 3 chance of having adrenaline
		if just_adrenaline or i == 0 or i == 1:
			$items.add_child(adrenaline_scene.instance())
		elif i == 2:
			$items.add_child(psychedelic_scene.instance())
	else:
		start_timer()
		return
	full = true
	$Position2D/Notification.visible = true
	check_for_bodies_on_activation()

func check_for_bodies_on_activation():
	var bodies = get_overlapping_bodies()
	if len(bodies) > 0:
		_on_Cabinet_body_entered(bodies[0])

func _on_Cabinet_body_entered(body):
	if full:
		full = false
		$items.get_children()[0].interact(body)
		$Position2D/Notification.visible = false
		if $items.get_children()[0].item_type == "Adrenaline":
			_display_item_aquired($Position2D/Adrenaline)
		else:
			_display_item_aquired($Position2D/Pill)
		Globals._play('clink')
		start_timer()
		

func _display_item_aquired(item):
	$Position2D/ItemTween1.interpolate_property(item, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.75)
	$Position2D/ItemTween1.start()


func _on_ItemTween_tween_completed(object, _key):
	$Position2D/ItemTween2.interpolate_property(object, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.5)
	$Position2D/ItemTween2.start()
