extends Control

onready var psychs :Label = get_node("Psychadelics")
onready var adrenaline :Label = get_node("Adrenaline")
onready var time :Label = get_node("Time")

var active = false

func _ready():
	visible = false
	modulate = Color(1,1,1,0)

func _process(delta):
	visible = active

func activate():
	set_vals()
	active = true
	Utils.fade_in(self, 3)

func deactivate():
	active = false
	modulate = Color(1,1,1,0)

func set_vals():
	time.text = str(Globals.time_alive_score) + " seconds"
	adrenaline.text = str(Globals.adrenaline_taken) + " syringes"
	psychs.text = str(Globals.psychedelics_taken) + " bottles"
