extends CharacterBody2D

@export var speed: float = 600.0
@export var max_speed: float = 1000.0
@export var score_label: RichTextLabel
@export var start_text: RichTextLabel
@export var end_text: RichTextLabel
@export var win_text: RichTextLabel
@export var camera_ref: Camera2D
@export var particles: CPUParticles2D
@export var particles_right: CPUParticles2D
@export var paddle: CharacterBody2D
#Exporting the pngs for the hearts
@export var full_hearts: Sprite2D
@export var two_hearts: Sprite2D
@export var one_heart: Sprite2D

var forward = Vector2(1,1).normalized()
var paddle_width:float = 276.0
var current_score: int = 0
var is_running: bool = false
var game_over: bool = false
var lives: int = 3

func _physics_process(delta: float) -> void:
	if (not is_running):
		if (Input.is_action_just_pressed("click_window")):
			if (game_over):
				get_tree().reload_current_scene()
			game_over = false
			is_running = true
			start_text.visible = false
			visible = true
		return
	
	var collision: KinematicCollision2D = move_and_collide(forward * speed * delta)
	if(collision and not game_over):
		forward = forward.bounce(collision.get_normal())
		speed = clamp(speed + 20, 1, max_speed)
		
		if(collision.get_collider().is_in_group("Bricks")):
			collision.get_collider().queue_free()
			camera_ref.apply_shake()
			particles.emit_it()
			particles_right.emit_it_r()
			
			current_score += 10
			score_label.text = "SCORE: " + str(current_score)
			
			#If they have broken all of the bricks
			if (current_score == 240):
				game_over = true
				end_text.visible = true
				is_running = false
				visible = false
				paddle.visible = false
				win_text.visible = true
				end_text.visible = false
				return
				
			
		if(collision.get_collider().is_in_group("SlowMoPowerUp")):
			Engine.time_scale = 0.3
			$SlowMo.start(0.6)
			
		if(collision.get_collider().is_in_group("Enlarge")):
			paddle.scale.x = 2
			paddle_width = paddle_width * 2
			$Enlarge.start(3)
		
		#Paddle bounce should be based on ball position
		if (collision.get_collider().is_in_group("Paddle")):
			var paddle_x = collision.get_collider().position.x - paddle_width/2
			var pos_on_paddle = (position.x - paddle_x) / paddle_width
			#print("Hit the paddle!" + str(pos_on_paddle))
			var bounce_angle = lerp(-PI * 0.8, -PI * 0.2, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
			
		#Handle game over conditions and update hearts
		if (collision.get_collider().is_in_group("GameOver")):
			lives -= 1
			if lives == 2:
				full_hearts.visible = false
				two_hearts.visible = true
				return
			if lives == 1:
				two_hearts.visible = false
				one_heart.visible = true
				return
			else:
				one_heart.visible = false
				is_running = false
				start_text.visible = false
				visible = false
				end_text.visible = true
				game_over = true
				paddle.visible = false

func _on_slow_mo_timeout() -> void:
	Engine.time_scale = 1
	pass # Replace with function body.


func _on_enlarge_timeout() -> void:
	paddle.scale.x = 1
	paddle_width = paddle_width / 2
	pass # Replace with function body.
