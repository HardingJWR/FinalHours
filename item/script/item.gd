extends Resource

class_name Item

#Enums
enum Type {DEFAULT, AMMO, KEY, GUN}
enum Size {TINY, SMALL, MEDIUM, BIG, LARGE}

#Properties
export(String) var label
export(String) var description
export(Texture) var icon
export(Type) var type
export(Size) var size
export(int) var volume
export(bool) var equippable
export(bool) var usable
export(bool) var combinable
export(bool) var stackable
export(int) var quantity

func set_Item(iLabel, iDescription, iType, iSize, iVolume, iStackable, iQuantity):
	label = iLabel
	description = iDescription
	type = iType
	size = iSize 
	volume = iVolume
	stackable = iStackable
	quantity = iQuantity

func check_Stackable(var item : Item) -> bool:
	if !stackable:
		return false
	
	if !item.stackable:
		return false
	
	if !label == item.label:
		return false
	
	if !type == item.type:
		return false
	
	return true

#If assigning duplicates keep working we don't need this
func copy_Item(var item : Item):
	label = item.label
	description = item.description
	type = item.type
	size = item.size
	volume = item.volume
	stackable = item.stackable
	quantity = item.quantity
