extends Node2D

@export var InimigoScene: PackedScene
@export var Path: Path2D

@export var IntervaloWaves: float = 5
@export var IntervaloInimigos: float = 1.5

var dinheiro:= 20000000

var QuantidadeEny: int = 3
var QuantidadeWave: int = 3

var WaveAtual := 0
var InimigosSpaw := 0

func IniciarWave():
	if WaveAtual >= QuantidadeWave:
		print("Cabo Fi")
		return
	print("Iniciando wave ", WaveAtual + 1)
	InimigosSpaw = 0
	WaveAtual += 1
	await SpawnarInimigosWave()
	await trocar_wave()
	IniciarWave()

func SpawnarInimigosWave():
	var InimigosSpawnar = QuantidadeEny + (WaveAtual - 1) * 2 
	for i in range(InimigosSpawnar):
		await get_tree().create_timer(IntervaloInimigos).timeout
		SpawnEny()

func SpawnEny():
	var inimigo = InimigoScene.instantiate()
	if inimigo is PathFollow2D:
		Path.add_child(inimigo)
	else:
		push_error("enemy nao e follow2d")

func trocar_wave():
	var time_conta = IntervaloWaves + (WaveAtual * 5)
	if time_conta > 30:
		time_conta = 30
	var timer = get_tree().create_timer(time_conta)
	while true:
		await get_tree().process_frame
		if not tem_vivo() or (timer.time_left <= 0):
			break
	await get_tree().create_timer(3).timeout
	
func tem_vivo():
	var inimigos = get_tree().get_nodes_in_group("inimigo")
	return inimigos.size() > 0
