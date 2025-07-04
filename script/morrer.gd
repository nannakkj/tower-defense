extends CharacterBody2D
var vida: float = 20.0
@onready var caminho = $".."
@onready var main = get_tree().root.get_node("Main")
var ganho = 50

func tomar_dano(qtd: int) -> void:
	vida -= qtd
	if vida <= 0:
		main.dinheiro += ganho
		caminho.queue_free()
