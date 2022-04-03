extends Area2D

var adrenaline_scene = preload("res://components/items/adrenaline/Adrenaline.tscn")
var psychedelic_scene = preload("res://components/items/psychedelic/Psychedelic.tscn")

var full = false

func _ready():
	$Timer.wait_time = (randf() * 10.0) + 5.0
	$Timer.start()

func _process(_delta):
	pass

func _on_Timer_timeout():
	if $items.get_child_count() < 1:
		var i = randi() % 3
		if i == 0 or i == 1:
			$items.add_child(adrenaline_scene.instance())
#			$Position2D/Adrenaline.visible = true
		else:
			$items.add_child(psychedelic_scene.instance())
#			$Position2D/Pill.visible = true
		full = true
		set_deferred("monitoring", true)
		$Position2D/Notification.visible = true
		check_for_bodies_on_activation()

func check_for_bodies_on_activation():
	var bodies = get_overlapping_bodies()
	if len(bodies) > 0:
		_on_Cabinet_body_entered(bodies[0])

func _on_Cabinet_body_entered(body):
	if full:
		full = false
		set_deferred("monitoring", false)
		$items.get_children()[0].interact(body)
		$Position2D/Notification.visible = false
		if $items.get_children()[0].item_type == "Adrenaline":
			_display_item_aquired($Position2D/Adrenaline)
		else:
			_display_item_aquired($Position2D/Pill)
		Globals._play('clink')

func _display_item_aquired(item):
	$Position2D/ItemTween1.interpolate_property(item, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.75)
	$Position2D/ItemTween1.start()


func _on_ItemTween_tween_completed(object, key):
	$Position2D/ItemTween2.interpolate_property(object, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.5)
	$Position2D/ItemTween2.start()
