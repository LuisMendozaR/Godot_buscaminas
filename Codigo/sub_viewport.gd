extends SubViewport

var bomba = preload("res://Herramientas/Imagenes/bomb.png") 
var flag = preload("res://Herramientas/Imagenes/flag.png")
var cover = preload("res://Herramientas/Imagenes/cover.png")
var uncover = preload("res://Herramientas/Imagenes/uncover.png")
var casilla = preload("res://Escenas/casilla.tscn")



var size_matriz = Vector2i(31,16)
var num_bombas = 99
var size_cell = Vector2i(32,32)

var click_inicial = true
var fin_del_juego = false

var count_flags = 0
var tiempo = 0

var matriz = []



func _ready() -> void:
	size=size_matriz * size_cell
	count_flags = num_bombas
	$"../../../CanvasLayer2/HBoxContainer/minas".text = "minas: " + str(count_flags)
	init_matriz()




func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_up"):
		mover_celdas(1)
	if Input.is_action_just_pressed("ui_down"):
		mover_celdas(2)
	if Input.is_action_just_pressed("ui_right"):
		mover_celdas(3)
	if Input.is_action_just_pressed("ui_left"):
		mover_celdas(4)




func init_matriz():
	for i in range(size_matriz.x):
		matriz.append([])
		for j in range(size_matriz.y):
			matriz[i].append([])
			
			var instancia = casilla.instantiate()
			instancia.position = size_cell * Vector2i(i,j)
			instancia.pos = Vector2i(i,j)
			instancia.sprite_position(size_cell)
			instancia.set_celda(cover)
			add_child(instancia)
			
			var datos = {
				"posicion":  Vector2i(i,j),
				"is_flag": false,
				"is_bomb": false,
				"is_cover": true,
				"count":  0,
				"casilla": instancia
			}
			
			matriz[i][j] = datos




func set_bombs(pos):
	var i=0

	while i<num_bombas:
		var x = randi_range(0,size_matriz.x-1)
		var y = randi_range(0,size_matriz.y-1)
		
		var m = Vector2i(x,y)
		if m.x>= pos.x-1 and m.x<= pos.x+1 and m.y >= pos.y-1 and m.y <= pos.y+1:
			pass
		else:
			if matriz[x][y].is_bomb == false:
				matriz[x][y].is_bomb = true
				count_bombs(x,y)
				i += 1
				

func count_bombs(x,y):
	for i in range(-1,2):
		for j in range(-1,2):
			if Vector2i(i+x,j+y) == size_matriz:
				matriz[0][0].count += 1 
				continue
				
			if i+x == size_matriz.x:
				matriz[0][j+y].count += 1
				continue
			
			if j+y == size_matriz.y:
				matriz[i+x][0].count += 1
				continue
				
			if Vector2i(0,0) != Vector2i(i,j):
				matriz[i+x][j+y].count += 1
			


func left_click(pos,tipo=0):
	#if fin_del_juego == false:
	if click_inicial == true:
		set_bombs(pos)
		$"../../../Timer".start()
		click_inicial = false
		
	var m = matriz[pos.x][pos.y]
	
	if m.is_flag == false:
		if m.is_cover == true:
			m.casilla.set_celda(uncover)
			m.is_cover = false
			if m.is_bomb == false:
				m.casilla.set_label(m.count)
				if m.count == 0:
					revelar(pos)
			else:
				m.casilla.set_label("")
				m.casilla.set_evento(bomba)
				fin_del_juego = true
					
		else:
			if tipo == 0:
				if m.is_bomb == false:
					var count = 0
					for i in range(-1,2):
						for j in range(-1,2):
							if Vector2i(i+pos.x,j+pos.y) == size_matriz:
								if matriz[0][0].is_flag == true:
									count += 1
								continue
							if pos.x+i == size_matriz.x:
								if matriz[0][pos.y+j].is_flag == true:
									count += 1
								continue
							if pos.y+j == size_matriz.y:
								if matriz[pos.x+i][0].is_flag == true:
									count += 1
								continue
							if matriz[pos.x+i][pos.y+j].is_flag == true:
								count += 1
					if count == m.count:
						revelar(pos) 



func right_click(pos):
	#if fin_del_juego == false:
	var m = matriz[pos.x][pos.y]
	
	if m.is_cover == true:
		if m.is_flag == true:
			m.casilla.set_evento(null)
			m.is_flag = false
			count_flags += 1
			$"../../../CanvasLayer2/HBoxContainer/minas".text = "minas: "+str(count_flags)
		else:
			m.casilla.set_evento(flag)
			m.is_flag = true
			count_flags -= 1
			$"../../../CanvasLayer2/HBoxContainer/minas".text = "minas: "+str(count_flags)


#Talvez cambio a continue
func revelar(pos):
	for i in range(-1,2):
		for j in range(-1,2):
			if pos + Vector2i(i,j) == size_matriz:
				left_click(Vector2i(0,0),1)
				continue
			if pos.x+i == size_matriz.x:
				left_click(Vector2i(0,pos.y+j),1)
				continue
			if pos.y+j == size_matriz.y:
				left_click(Vector2i(pos.x+i,0),1)
				continue
			if Vector2i(0,0) != Vector2i(i,j):
				left_click(pos+Vector2i(i,j),1)




func mover_celdas(direccion):
	match direccion:
		4: #left
			var m = matriz[0]
			matriz.pop_front()
			matriz.append(m)
			
			
		3: #right
			var m = matriz[matriz.size()-1]
			matriz.pop_back()
			matriz.push_front(m)
		
		1: #up
			for i in range(size_matriz.x):
				var m = matriz[i][0]
				matriz[i].pop_at(0)
				matriz[i].append(m)
		2: #down
			for i in range(size_matriz.x):
				var m = matriz[i][size_matriz.y-1]
				matriz[i].pop_at(size_matriz.y-1)
				matriz[i].insert(0,m)
	
	get_tree().call_group("casillas","mover",direccion)

	
		


func _on_timer_timeout() -> void:
	tiempo += 1
	$"../../../CanvasLayer2/HBoxContainer/tiempo".text = "tiempo: " + str(tiempo)
	pass # Replace with function body.
