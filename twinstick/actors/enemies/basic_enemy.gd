extends CharacterStateMachine
class_name Enemy

@export var hp:int = 3

func hit(damage_number: int):
	hp -= damage_number
	if(hp <= 0):
		#_on_change_state("statename") #Play an animation on death
		queue_free()
		
