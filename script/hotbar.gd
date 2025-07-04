extends Control

@export var tower1_scene: PackedScene
@export var tower2_scene: PackedScene
var select_tower: PackedScene = null
@onready var chao = $"../Area2D"
@onready var main = $".."
@onready var money = main.dinheiro

var ghost_tower: Node2D = null


func _ready():
	$HBoxContainer/Button.pressed.connect(_on_button1_pressed)
	
func _on_button1_pressed():
	select_tower = tower1_scene
	chao.desenha = true
	if ghost_tower:
		ghost_tower.queue_free()
	ghost_tower = tower1_scene.instantiate()
	ghost_tower.ativo = false
	ghost_tower.z_index = 100
	get_tree().root.add_child(ghost_tower)
	
	money = 100
	
func pegar_torre():
	return select_tower

func pegar_money():
	return money

func clear_selection():
	select_tower = null
	chao.desenha = false
	if ghost_tower:
		ghost_tower.queue_free()
		ghost_tower = null
	
func _process(delta):
	if ghost_tower:
		ghost_tower.global_position = get_global_mouse_position()
