extends Area2D
var spd := 800
var direction: Vector2 = Vector2.RIGHT

func _process(delta: float) -> void:
	position += direction*spd*delta
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _ready():
	connect("body_entered", self._on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("inimigo"):
		if body.has_method("tomar_dano"):
			body.tomar_dano(10)
		queue_free()
