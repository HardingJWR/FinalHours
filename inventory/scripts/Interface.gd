extends Control

#Signals
signal equip #Player
signal use #Player
signal drop #Player
signal examine #Examiner (3D View or Text View)

#Interface
var is_combining : bool = false
var is_transfering : bool = false
var is_dividing : bool = false
var current_index = 0 
var interacted_item : Item = null
var action_selection : bool = false
enum {EQUIP, USE, COMBINE, DIVIDE, TRANSFER, DROP, EXAMINE}

var actions = ["EQUIP", "USE", "COMBINE", "DIVIDE", "TRANSFER", "DROP", "EXAMINE"]
#[["EQUIP"], ["USE", CONSUME], ["COMBINE", "RELOAD"], ["DIVDE"], ["TRANSFER"], ["DROP"], ["EXAMINE", "READ"]]

#Items
#NEED A GLOBAL LIST OF EVERYTHING
export(Resource) var SmallKey
export(Resource) var BigKey
export(Resource) var Banana
export(Resource) var HandGun

#Inventory
var Inventories = []
export(Resource) var Pants
export(Resource) var HandGunHolster
export(Resource) var Backpack

func _ready():
	#Listing inventories
	Inventories.append(Pants)
	Inventories.append(Backpack)
	Inventories.append(HandGunHolster)
	
	#Filling inventories
	Pants.add(SmallKey, false, 3)
	Pants.add(SmallKey, false, 3)
	Pants.add(BigKey, false, 3)
	Backpack.add(HandGun)
	Backpack.add(SmallKey, false, 3)
	Backpack.add(BigKey, false, 3)
	HandGunHolster.add(HandGun)
	
	#Display first inventory on the interface
	display_inventory(current_index)

func _process(delta):
	if !action_selection:
		change_inventory()

func display_inventory(index : int):
	$ItemList.clear()
	
	$Title.text = Inventories[index].label
	for item in Inventories[index].item_stack:
		item = item as Item
		$ItemList.add_item(str(item.quantity) + " " + item.label, item.icon, true)
	
	$ItemList.grab_focus()

func change_inventory():
	if Input.is_action_just_pressed("ui_left"):
		if current_index == 0:
			current_index = Inventories.size() - 1
		else:
			current_index -= 1
	elif Input.is_action_just_pressed("ui_right"):
		if current_index == Inventories.size() - 1:
			current_index = 0
		else:
			current_index += 1
	else:
		return
	
	display_inventory(current_index)

func action_menu():
	$ItemList.clear()
	$Title.text = interacted_item.label
	for action in actions:
		var display : bool = true
		prints(action)
		match(action):
			"EQUIP":
				display = interacted_item.equippable
			"USE":
				display = interacted_item.usable
			"COMBINE":
				display = (interacted_item.stackable || interacted_item.combinable)
			"DIVIDE":
				display = (interacted_item.stackable && interacted_item.quantity > 1)
		
		if display:
			$ItemList.add_item(action, null, true)
	
	$ItemList.grab_focus()

func _on_ItemList_item_activated(index):
	if !action_selection:
		action_selection = true
		interacted_item = Inventories[current_index].item_stack[index]
		action_menu()
	else:
		match(index):
			EQUIP:
				emit_signal("equip")
			USE:
				emit_signal("use")
			COMBINE:
				#STATEofCOMBINING = TRUE
				#indexArray.append(index)
				#2 index required
				pass
			DIVIDE:
				#STATEofDIVIDING = TRUE
				#GOTTA SELECT HOW MUCH TO SUBSTRACT
				pass
			TRANSFER:
				#STATEofTRANSFER = TRUE
				#index of item and its inventory index 
				#maybe the destination inventory index
				pass
			DROP: 
				emit_signal("drop")
			EXAMINE:
				emit_signal("examine")
		
		action_selection = false
		display_inventory(current_index)
