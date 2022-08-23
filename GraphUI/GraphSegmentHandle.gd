class_name GraphSegmentHandle
	
enum MovementConstraint { Horizontal, Vertical, TwoD, None}

var _movementConstraint: int = MovementConstraint.TwoD

func _init(movementConstraint: int):
	self._movementConstraint = movementConstraint;
	
func moveTo(position:Vector2) -> Vector2:
	var finalPos:Vector2 = Vector2.ZERO;
	
	match(_movementConstraint):
		MovementConstraint.Horizontal:
			finalPos.x = position.x;
		MovementConstraint.Vertical:
			finalPos.y = position.y;
		MovementConstraint.TwoD:
			finalPos = position;
	
	return finalPos;
	
	
func draw(canvas:Node, position: Vector2, handleSize:float, handleColor:Color):
	canvas.draw_circle(position,handleSize, handleColor);
