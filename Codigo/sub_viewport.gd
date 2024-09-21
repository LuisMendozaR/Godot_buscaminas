extends SubViewport

var bomba = preload("res://Herramientas/Imagenes/bomb.png") 
var flag = preload("res://Herramientas/Imagenes/flag.png")
var cover = preload("res://Herramientas/Imagenes/cover.png")
var uncover = preload("res://Herramientas/Imagenes/uncover.png")
var casilla = preload("res://Escenas/casilla.tscn")


var size_matriz = Vector2i(30,15)
var num_bombas = 50
var size_cell = Vector2i(32,32)

var click_inicial = true

var matriz = []



func _ready() -> void:
	size=size_matriz * size_cell
	init_matriz()




func _process(delta: float) -> void:
	pass




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
		
		if matriz[x][y].posicion != pos:
			if matriz[x][y].is_bomb == false:
				matriz[x][y].is_bomb = true
				count_bombs(x,y)
				i += 1
				

func count_bombs(x,y):
	for i in range(-1,2):
		for j in range(-1,2):
			if Vector2i(i+x,j+y) == size_matriz:
				matriz[0][0].count += 1 
				break
			if i+x == size_matriz.x:
				matriz[0][j+y].count += 1
				break
			if j+y == size_matriz.y:
				matriz[i+x][0].count += 1
				break
			if Vector2i(0,0) != Vector2i(i,j):
				matriz[i+x][j+y].count += 1
			


func left_click(pos):
	if click_inicial == true:
		set_bombs(pos)
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
				

func right_click(pos):
	var m = matriz[pos.x][pos.y]
	
	if m.is_cover == true:
		if m.is_flag == true:
			m.casilla.set_evento(null)
			m.is_flag = false
		else:
			m.casilla.set_evento(flag)
			m.is_flag = true

func revelar(pos):
	for i in range(-1,2):
		for j in range(-1,2):
			if pos + Vector2i(i,j) == size_matriz:
				left_click(Vector2i(0,0))
				break
			if pos.x+i == size_matriz.x:
				left_click(Vector2i(0,pos.y+j))
				break
			if pos.y+j == size_matriz.y:
				left_click(Vector2i(pos.x+i,0))
				break
			if Vector2i(0,0) != Vector2i(i,j):
				left_click(pos+Vector2i(i,j))



#Falta comportamiento de casillas, revisar el codigo
func mover_celdas(direccion):
	match direccion:
		1:
			var m = matriz[0]
			matriz.pop_front()
			matriz.append(m)
			
		2:
			var m = matriz[matriz.size()-1]
			matriz.pop_back()
			matriz.push_front(m)
		
		3:
			for i in range(size_matriz.x):
				var m = matriz[i][0]
				matriz[i].pop(0)
				matriz[i].append(m)
		4:
			for i in range(size_matriz.x):
				var m = matriz[i][size_matriz.y-1]
				matriz[i].pop(size_matriz.y-1)
				matriz[i].insert(0,m)
				

	
		
