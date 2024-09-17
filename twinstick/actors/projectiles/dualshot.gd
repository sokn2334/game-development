extends Area2D

var velocity: Vector2 = Vector2(0,0)
var count:int = 10
#var text: RichTextLabel 

func fire(forward: Vector2, speed: float):
	velocity = forward * speed
	look_at(position + forward)
	count -= count
	#text.set_text(str(count)) 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	position += velocity * delta
	pass


func _on_time_to_live_timeout() -> void:
	queue_free()
	pass # Replace with function body.
