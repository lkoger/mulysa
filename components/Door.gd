extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StaticBody2D_area_entered(area):
	$AnimatedSprite.play("default",false)



func _on_StaticBody2D_area_exited(area):
	$AnimatedSprite.play("default",true)


func _on_Door_body_entered(body):
	$AnimatedSprite.play("default",false)



func _on_Door_body_exited(body):
	$AnimatedSprite.play("default",true)
