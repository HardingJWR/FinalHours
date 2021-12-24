extends Node

enum Direction {Forward, Backward, Left, Right}

func _is_front(looking_at : Transform, target : Transform, buffer = 0.2) -> bool:
	return _check_direction(looking_at, target, Direction.Forward, buffer)

func _is_left(looking_at : Transform, target : Transform, buffer = 0.2) -> bool:
	return _check_direction(looking_at, target, Direction.Left, buffer)

func _is_behind(looking_at : Transform, target : Transform, buffer = 0.2) -> bool:
	return _check_direction(looking_at, target, Direction.Backward, buffer)

func _is_right(looking_at : Transform, target : Transform, buffer = 0.2) -> bool:
	return _check_direction(looking_at, target, Direction.Right, buffer)

#Maybe replace all 3 booleans for a Vector3
func _is_aligned(t1 : Transform, t2 : Transform, x : bool, y : bool, z : bool, buffer : float) -> bool:
	var result = false
	
	if x && abs(t1.origin.x - t2.origin.x) <= buffer:
		result = true
	
	if y && abs(t1.origin.y - t2.origin.y) <= buffer:
		result = true
	
	if z && abs(t1.origin.z - t2.origin.z) <= buffer:
		result = true
	
	return result

func _check_direction(looking_at : Transform, target : Transform, direction : int, buffer : float) -> bool:
	var directions = [null, null]
	
	match direction:
		Direction.Forward:
			directions[0] = looking_at.basis.z
			directions[1] = -looking_at.basis.x
		Direction.Backward:
			directions[0] = -looking_at.basis.z
			directions[1] = looking_at.basis.x
		Direction.Left:
			directions[0] = looking_at.basis.x
			directions[1] = looking_at.basis.z
		Direction.Right:
			directions[0] = -looking_at.basis.x
			directions[1] = -looking_at.basis.z
	
	var vdelta = (looking_at.origin - target.origin).normalized()
	var cproduct =  vdelta.cross(directions[0]).y
	var is_correct : bool = false if vdelta.cross(directions[1]).y < 0 else true
	
	if cproduct >= -buffer && cproduct <= buffer && is_correct:
		return true
	else:
		return false
