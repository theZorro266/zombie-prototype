extends TileMap

onready var camera = get_node("../Camera2D")
var terrainInfoPanel = PopupPanel.new()
var terrainInfoLabel = Label.new()

#Walking speed is calculated by
#(normalSpeed * ((tiredness / 100) + (illness / 100) + 1) * ((density / 10) + 1 
#Event is calculated by
var tile_type = [
	{ "density": 3, "zombie": 6, "raider": 7, "survivor": 2, "name": "road" },
	{ "density": 9, "zombie": 1, "raider": 3, "survivor": 0, "name": "water" },
	{ "density": 5, "zombie": 8, "raider": 5, "survivor": 3, "name": "building" },
	{ "density": 1, "zombie": 3, "raider": 4, "survivor": 2, "name": "grass" },
	{ "density": 7, "zombie": 2, "raider": 7, "survivor": 4, "name": "mountain" },
	{ "density": 4, "zombie": 6, "raider": 10, "survivor": 1, "name": "military" },
	{ "density": 6, "zombie": 4, "raider": 8, "survivor": 4, "name": "forest" } 
]

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				print(world_to_map(event.position + camera.position - get_viewport().size / 2))
			if event.doubleclick:
				var map_position = world_to_map(event.position + camera.position - get_viewport().size / 2)
				if get_cellv(map_position) != INVALID_CELL:
					get_node("../Player").position = map_to_world(map_position)
		if event.button_index == BUTTON_RIGHT:
			if event.pressed == false:
				terrainInfoPanel.hide()
				var map_position = world_to_map(event.position + camera.position - get_viewport().size / 2)
				if get_cellv(map_position) != INVALID_CELL:
					camera.add_child(terrainInfoPanel)
					terrainInfoPanel.add_child(terrainInfoLabel)
					terrainInfoLabel.text = get_info(tile_set.tile_get_name(get_cellv(map_position)))
					terrainInfoPanel.popup(Rect2(map_to_world(map_position) + cell_size, Vector2(100, 50)))
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			camera.position -= event.relative

func _ready():
	clear()	
	var tile = Vector2(4, 7)
	
	set_cellv(tile, 0)
	for x in range(1000):
		if x == 0:
			if tile.y as int % 2 == 0:
				set_cellv(tile + Vector2(0, -1), 0)
			else:
				set_cellv(tile + Vector2(1, -1), 0)
		elif  x == 1:
			if tile.y as int % 2 == 0:
				set_cellv(tile + Vector2(0, 1), 1)
			else:
				set_cellv(tile + Vector2(1, 1), 1)
		elif x == 2:
			set_cellv(tile + Vector2(0, 2), 2)
		elif x == 3:
			if tile.y as int % 2 == 0:
				set_cellv(tile + Vector2(-1, 1), 3)
			else:
				set_cellv(tile + Vector2(0, 1), 3)
		elif x == 4:
			if tile.y as int % 2 == 0:
				set_cellv(tile + Vector2(-1, -1), 0)
			else:
				set_cellv(tile + Vector2(0, -1), 0)
		elif x == 5:
			set_cellv(tile + Vector2(0, -2), 0)
	
	clear()
	tile = Vector2(7, 7)
	set_cellv(tile, 0)
	for a in range(1000):
		for b in range(a):
			if tile.y as int % 2 == 0:
				set_cellv(tile + Vector2(0, -1), 1)
				tile += Vector2(0, -1)
			else:
				set_cellv(tile + Vector2(1, -1), 1)
				tile += Vector2(1, -1)
		for b in range(a - 1):
			if tile.y as int % 2 == 0:
				set_cellv(tile + Vector2(0, 1), 2)
				tile += Vector2(0, 1)
			else:
				set_cellv(tile + Vector2(1, 1), 2)
				tile += Vector2(1, 1)
		for b in range(a):
				set_cellv(tile + Vector2(0, 2), 3)
				tile += Vector2(0, 2)
		for b in range(a):
			if tile.y as int % 2 == 0:
				set_cellv(tile + Vector2(-1, 1), 4)
				tile += Vector2(-1, 1)
			else:
				set_cellv(tile + Vector2(0, 1), 4)
				tile += Vector2(0, 1)
		for b in range(a):
			if tile.y as int % 2 == 0:
				set_cellv(tile + Vector2(-1, -1), 5)
				tile += Vector2(-1, -1)
			else:
				set_cellv(tile + Vector2(0, -1), 5)
				tile += Vector2(0, -1)
		for b in range(a):
			set_cellv(tile + Vector2(0, -2), 6)
			tile += Vector2(0, -2)

func get_info(type_id):
	var info_string = """{name}
	
	Density: {density}
	Zombie: {zombie}
	Raider: {raider}
	Survivor: {survivor}"""
	return info_string.format(tile_type[int(type_id)])

func get_density(type_id):
	return tile_type[int(type_id)].density
	
