extends Node2D

#camviar tamaño de subviewport para centrar segun el numero de casillas


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tamaño=$CanvasLayer/SubViewportContainer/SubViewport.size_matriz
	var pixeles = $CanvasLayer/SubViewportContainer/SubViewport.size_cell
	$CanvasLayer/SubViewportContainer/SubViewport.size = tamaño * pixeles
	$CanvasLayer/SubViewportContainer.size = tamaño * pixeles

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
