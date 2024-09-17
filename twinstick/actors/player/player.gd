extends CharacterBody2D

@export var projectile_scene: Resource
@export var dualshot_scene: Resource
@export var bomb_scene: Resource

@export var bread_icon: Sprite2D
@export var creampuff_icon: Sprite2D
@export var macaron_icon: Sprite2D


@export var move_speed: float = 200.0

#Weapon inventory
# 1 = bread (projectile)
# 2 = creampuff (dualshot)
# 3 = macaron (bomb/aoe)
# 4 = pudding (slowshot)
var weapon_selection:int = 1  

func _input(event):
	if (event is InputEventMouseButton):
		#Only shoot on left click pressed down
		if (event.button_index == 1 and event.is_pressed()):
			match weapon_selection:
				1:	
					var new_projectile = projectile_scene.instantiate()
					get_parent().add_child(new_projectile)
			
					var projectile_forward = Vector2.from_angle(rotation)
					new_projectile.fire(projectile_forward, 600.0)
					new_projectile.position = $ProjectileRefPoint.global_position
				2: 
					var dual_rotation: float = 0.2
					for i in 2:
						var new_dualshot = dualshot_scene.instantiate()
						get_parent().add_child(new_dualshot)
						var dualshot_forward = Vector2.from_angle(rotation + dual_rotation)
						new_dualshot.fire(dualshot_forward, 600.0)
						new_dualshot.position = $ProjectileRefPoint.global_position
						dual_rotation = -0.2
				3: 
					var new_bomb = bomb_scene.instantiate()
					get_parent().add_child(new_bomb)
			
					new_bomb.fire()
					new_bomb.position = $ProjectileRefPoint.global_position
				4: print("four")
			
		

func _physics_process(delta: float):
	look_at(get_viewport().get_mouse_position())
	
	#Check to see if the player switches weapons 
	if (Input.is_action_just_pressed("weapon_one")):
		weapon_selection = 1
		macaron_icon.visible = false
		bread_icon.visible = true
		creampuff_icon.visible = false
	if (Input.is_action_just_pressed("weapon_two")):
		weapon_selection = 2
		macaron_icon.visible = false
		creampuff_icon.visible = true 
		bread_icon.visible = false
	if (Input.is_action_just_pressed("weapon_three")):
		weapon_selection = 3
		macaron_icon.visible = true
		creampuff_icon.visible = false 
		bread_icon.visible = false
	if (Input.is_action_just_pressed("weapon_four")):
		weapon_selection = 4		
	
	#Player movement
	velocity = Input.get_vector("move_left", \
		"move_right", "move_up", "move_down")\
	 	* move_speed
	move_and_slide()
