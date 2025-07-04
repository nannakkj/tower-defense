extends Control

@onready var waves_text = $Label
@onready var money_text = $Label2
@onready var main = get_tree().root.get_node("Main")

func _process(delta):
	var wave_atual = main.WaveAtual
	var wave_max = main.QuantidadeWave
	var dinheiro = main.dinheiro
	waves_text.text = str(wave_atual) + "/" + str(wave_max)
	money_text.text = "$" + str(dinheiro)
