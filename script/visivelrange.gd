extends Area2D

var ativo := true

func _draw():
	if ativo:
		var shape = $CollisionShape2D.shape
		if shape is CircleShape2D:
			draw_circle(Vector2.ZERO, shape.radius, Color(.238, .030, .250, 0.3))

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if shape_idx == 1:
			ativo = !ativo
			queue_redraw()
