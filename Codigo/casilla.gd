extends Node2D

@onready var matriz = get_node("..")
var pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			matriz.left_click(pos)
		if event.is_action_pressed("right_click"):
			matriz.right_click(pos)



func set_celda(imagen):
	$celda.texture = imagen

func set_evento(imagen):
	$evento.texture = imagen

func sprite_position(pos):
	$celda.position = pos/2
	$evento.position = pos/2
	
	$Control.size = pos
	$Label.size = pos
	
func set_label(l):
	$Label.text=str(l)
	
