extends Resource

class_name Inventory

#enums
enum Type {PANTS, ARMY_PANTS, JACKET, BACKPACK, HANDGUN_HOLSTER, GUN_HOLSTER}

export(String) var label

#Properties
export(Type) var type 

#Only allowed if item type in this array
export(Array, Item.Type) var item_type_allowed = [] 

#Only allowed if item size in this array
export(Array, Item.Size) var item_size_allowed = [] 

#Actual stack of items in the inventory
export(Array) var item_stack = []

#How much space unit can it contain 
export(int) var max_volume = 0

#Functions

#Add an item or a stack to the inventory
func add(item : Item, doNotStack = false, multiplier = 1) -> bool:
	#Size of the item allowed
	if !item.type in item_type_allowed:
		return false
	
	#Type of the item allowed
	if !item.size in item_size_allowed:
		return false
	
	#Volume Check
	var volume_to_add : int = item.volume * item.quantity
	var volume_left : int = max_volume - get_volume()
	
	var quantity_to_add = item.quantity
	
	if !volume_to_add <= volume_left:
			return false
	
	var new_item = Item.new()
	new_item = item.duplicate()
	new_item.quantity = new_item.quantity * multiplier
	
	#Stackable Check
	if new_item.stackable && !doNotStack && item_stack.size() > 0:
		for child in item_stack:
			child = child as Item
			if child.check_Stackable(new_item):
					child.quantity += new_item.quantity
					return true
	
	if doNotStack:
		var times = new_item.quantity
		new_item.quantity = 1
		
		for i in times:
			item_stack.append(new_item)
	else:
		item_stack.append(new_item)
	
	return true

#Remove an item or a stack from the inventory
func remove(item_index : int):
	item_stack.remove(item_index)

#Remove all the items from the inventory
func remove_all():
	item_stack.clear()

#Merge 2 stacks of the same type to make only 1
func merge(merged_index : int, result_index : int) -> bool:
	#####################
	#todo: GUN RELOAD   #
	#####################
	#Stackable Check
	var merged = item_stack[merged_index] as Item
	var result = item_stack[result_index] as Item
	
	if !result.check_Stackable(merged):
		return false
	
	#Add the quantities
	result.quantity += merged.quantity
	
	#Clean up the item_stack
	remove(merged_index)
	
	return true

func merge_all():
	var unique_list = []
	
	for item in item_stack:
		var found : bool = false
		var name = item.label
		
		if unique_list.size() == 0:
			unique_list.append(name)
		
		for unique in unique_list:
			if !found && unique == name:
				found = true
		
		if !found:
			unique_list.append(name)
	
	for stack in unique_list:
		var new_stack = Item.new()
		
		for item in item_stack:
			if !item.label == stack:
				continue
			
			if !is_instance_valid(new_stack):
				new_stack = item.duplicate()
			
			new_stack.quantity += item.quantity

#Divid 1 stack to make 2 stacks
func divid(divid_index : int, quantity : int) -> bool:
	var divided = item_stack[divid_index] as Item
	
	if !quantity < divided.quantity:
		return false
	
	#Stackable Check
	if !divided.stackable:
		return false
	
	#Modify the quantities of the divided
	divided.quantity -= quantity
	
	#Add a new Item
	var new_item =  Item.new()
	new_item.copy_Item(divided) 
	new_item.quantity = quantity
	add(new_item, true)
	
	return true

#Print all infos
func print_all():
	for child in item_stack:
		child = child as Item
		
		var type : String 
		match(child.type):
			Item.Type.DEFAULT:
				type = "Default"
			Item.Type.KEY:
				type = "Key"
			Item.Type.GUN:
				type = "Gun"
			Item.Type.AMMO:
				type = "Ammo"
		
		var size : String 
		match(child.size):
			Item.Size.TINY:
				type = "Tiny"
			Item.Size.SMALL:
				type = "Small"
			Item.Size.MEDIUM:
				type = "Medium"
			Item.Size.BIG:
				type = "Big"
			Item.Size.LARGE:
				type = "Large"
		
		var volumeTotal : int = child.quantity * child.volume
		
		prints(child.quantity, child.label, child.description, type, size, "Volume Each", child.volume, "Total", volumeTotal, "Stackable", child.stackable)

#Return the current used volume of the inventory
func get_volume() -> int:
	var volume = 0
	
	for item in item_stack:
		item = item as Item
		volume += item.quantity * item.volume
	
	return volume
