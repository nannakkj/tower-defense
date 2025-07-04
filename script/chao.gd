extends Area2D

@onready var collision_shapes = [$CollisionShape2D, $CollisionShape2D2, $CollisionShape2D3, $CollisionShape2D4]
@onready var hotbar = $"../Hotbar"
@onready var main = $".."
var desenha = false

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var pos = get_global_mouse_position()
		if is_position_valid(pos) and have_money():
			var tower_scene = hotbar.pegar_torre()
			if tower_scene:
				cut_money()
				place_tower(pos, tower_scene)
				hotbar.clear_selection()
		else:
			hotbar.clear_selection()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		hotbar.clear_selection()

func is_position_valid(pos: Vector2) -> bool:
	if collision_shapes.size() == 0:
		print("sem shapes")
		return false
	var local_pos = to_local(pos)
	for collision_shape in collision_shapes:
		var shape = collision_shape.shape
		if shape == null:
			continue

		var shape_local_pos = local_pos - collision_shape.position

		if shape is RectangleShape2D:
			if rect_contains_point(shape, shape_local_pos):
				if not have_tower(pos):
					return true
		else:
			print("Shape não suportado")
	
	return false

func rect_contains_point(shape: RectangleShape2D, point: Vector2) -> bool:
	var extents = shape.extents
	return (
		point.x >= -extents.x and point.x <= extents.x and
		point.y >= -extents.y and point.y <= extents.y
	)

func place_tower(pos: Vector2, tower_scene: PackedScene):
	var tower = tower_scene.instantiate()
	tower.position = pos
	tower.ativo = true
	tower.add_to_group("torre")
	get_tree().root.get_node("Main").add_child(tower)
	
func have_money() -> bool:
	var custo = hotbar.pegar_money()
	var money = main.dinheiro
	return money >= custo

func cut_money():
	var custo = hotbar.pegar_money()
	var money = main.dinheiro
	main.dinheiro -= custo

func _process(delta):
	queue_redraw()

func _draw():
	if desenha:
		draw_rect(Rect2(-position, get_viewport().get_visible_rect().size), Color(1, 0, 0, 0.4))
		for collision_shape in collision_shapes:
			var shape = collision_shape.shape
			if shape is RectangleShape2D:
				var extents = shape.extents
				var offset = collision_shape.position
				draw_rect(Rect2(-extents + offset, extents * 2), Color(0, 1, 0, 0.5))
		var torres = get_tree().get_nodes_in_group("torre")
		for torre in torres:
			var collision_shape = get_node_or_null("CollisionShape2D")
			if collision_shape == null:
				continue
			var shape = collision_shape.shape
			var raio = 0.0
			
			if shape is RectangleShape2D:
				raio = shape.extents.length()
			elif shape is CircleShape2D:
				raio = shape.radius
			else:
				continue
			
			var local_pos = to_local(torre.global_position)
			draw_circle(local_pos, raio / 2.8, Color(1, 0, 0, 0.4))
			
func have_tower(pos):
	var torres = get_tree().get_nodes_in_group("torre")
	for torre in torres:
		var collision_shape = get_node_or_null("CollisionShape2D")
		if collision_shape == null:
			continue
		var shape = collision_shape.shape
		var raio = 0.0
		
		if shape is RectangleShape2D:
			raio = shape.extents.length()
		elif shape is CircleShape2D:
			raio = shape.radius
		else:
			continue
		
		if torre.global_position.distance_to(pos) < raio / 2.8: 
			return true
	return false
