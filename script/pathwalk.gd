extends PathFollow2D

var spd: float = 50.0

func _process(delta):
	progress += spd *delta
	if progress_ratio >= 1:
		await get_tree().create_timer(.5).timeout
		queue_free()
