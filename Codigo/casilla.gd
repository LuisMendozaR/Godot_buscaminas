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
	
func mover(dir):
	var m = matriz.size_matriz
	var c = matriz.size_cell
	match dir:
		3: #right
			if pos.x+1 >= m.x:
				position.x = 0 
				pos.x = 0
			else: 
				position.x += c.x
				pos.x += 1
		4: #left
			if pos.x-1 < 0:
				position.x = c.x * (m.x-1)
				pos.x =  m.x-1
			else: 
				position.x -= c.x 
				pos.x -= 1
		2: #down
			if pos.y+1 >= m.y:
				position.y = 0 
				pos.y = 0
			else: 
				position.y += c.y
				pos.y += 1
		1: #up
			if pos.y-1 < 0:
				position.y = c.y * (m.y-1)
				pos.y =  m.y-1
			else: 
				position.y -= c.y 
				pos.y -= 1
