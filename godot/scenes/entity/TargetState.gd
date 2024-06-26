extends State
class_name TargetState

@export var character: Entity

var target
var type
var station:Workstation
var has_state: bool = false

func enter(_msg := {}):
	if !_msg.has("state"):
		has_state = true

func update(_delta):
	if has_state:
		if character.targets.is_empty():
			match character.occupation:
				character.OCCUPATION.CUSTOMER:
					character.targets = character.customer.duplicate()
				character.OCCUPATION.REGISTER:
					character.targets = character.register.duplicate()
				character.OCCUPATION.CHEF:
					character.targets = character.chef.duplicate()
				character.OCCUPATION.DISHWASHER:
					character.targets = character.dishwasher.duplicate()
				character.OCCUPATION.FRYER:
					character.targets = character.fryer.duplicate()
	else:
		character.targets = [character.INTERACTION.LEAVE]
	
	if !character.targets.is_empty():
		match character.targets[0]:
			character.INTERACTION.ORDER:
				station = WorkstationManager.occupy_customer_workstation(WorkstationManager.WORKSTATION.REGISTER)
				type = character.INTERACTION.ORDER
				if station:
					target = station.get_customer_position()
				else:
					print("No register found")
			character.INTERACTION.WAIT:
				station = WorkstationManager.occupy_customer_workstation(WorkstationManager.WORKSTATION.TABLE)
				type = character.INTERACTION.WAIT
				if station:
					target = station.get_customer_position()
				else:
					print("No table found")
			character.INTERACTION.LEAVE:
				type = character.INTERACTION.LEAVE
				target = character.leave.global_position
			character.INTERACTION.COOK_POT:
				type = character.INTERACTION.COOK_POT
				station = WorkstationManager.occupy_workstation(WorkstationManager.WORKSTATION.POT)
				if station:
					target = station.get_worker_position()
			character.INTERACTION.FRYER:
				type = character.INTERACTION.FRYER
				station = WorkstationManager.occupy_workstation(WorkstationManager.WORKSTATION.FRYER)
				if station:
					target = station.get_worker_position()
			character.INTERACTION.DISHWASHER:
				type = character.INTERACTION.DISHWASHER
				station = WorkstationManager.occupy_workstation(WorkstationManager.WORKSTATION.SINK)
				if station:
					target = station.get_worker_position()
			character.INTERACTION.REGISTER:
				type = character.INTERACTION.REGISTER
				station = WorkstationManager.occupy_workstation(WorkstationManager.WORKSTATION.REGISTER)
				if station:
					target = station.get_worker_position()
			character.INTERACTION.TABLE:
				type = character.INTERACTION.TABLE
				station = WorkstationManager.occupy_workstation(WorkstationManager.WORKSTATION.TABLE)
				if station:
					target = station.get_worker_position()
		
	if target != null and type != null:
		print(str(self) + ": CLAIMED " + str(target))
		character.targets.remove_at(0)
		state_machine.transition_to("WalkState", 
		{ 
			"type": type, 
			"target": target, 
			"station": station 
		})

func exit():
	character.pathing = true
