extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_emitting(false)
	pass # Replace with function body.

func emit_it_r()-> void:
	set_emitting(true)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
