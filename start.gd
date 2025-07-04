extends Button
@onready var main = $".."

func _pressed():
	main.IniciarWave()
	queue_free()
