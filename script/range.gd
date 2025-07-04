extends Node2D

@export var project: PackedScene
var inimigos_range: Array = []
var shoot_inteval: float = 1.0

var shoot_timer := 0.0
var ativo = false

func _ready() -> void:
	$Range.body_entered.connect(_on_body_entered)
	$Range.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("inimigo"):
		inimigos_range.append(body)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("inimigo"):
		inimigos_range.erase(body)

func _process(delta: float) -> void:
	shoot_timer -= delta
	if inimigos_range.is_empty():
		shoot_timer = .3
		return

	var alvo = inimigo_proximo()
	if alvo == null or not is_instance_valid(alvo):
		shoot_timer = 1
		return

	var dir: Vector2 = (alvo.global_position - global_position).normalized()
	var ang: float = dir.angle()  
	rotation = lerp_angle(rotation, ang, 10 * delta)

	if shoot_timer <= 0 and is_instance_valid(alvo):
		shoot()
		shoot_timer = shoot_inteval

func inimigo_proximo() -> Node2D:
	inimigos_range = inimigos_range.filter(is_instance_valid)
	if inimigos_range.is_empty():
		return null
	return inimigos_range[0]

func shoot():
	if project == null:
		return
	
	var proj = project.instantiate()
	get_parent().add_child(proj)
	
	proj.global_position = global_position
	
	var dir = Vector2.RIGHT.rotated(rotation)
	proj.rotation = dir.angle()
	proj.direction = dir
