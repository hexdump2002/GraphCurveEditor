extends Control

var _handles:Array = [];
var _vertices: Array = [];
var _handleSize:int = 10;
var _mouseOverHandleIndex = -1;
var _draggingHandleIndex = -1;

enum MovementConstraint { Horizontal, Vertical, TwoD, None}

enum VertexHandleStyle {MouseOver, Dragging, None}

class VertexHandle:
	var _movementConstraint: int = MovementConstraint.TwoD

	var position: Vector2 = Vector2.ZERO setget setPosition, getPosition;
	func setPosition(value:Vector2): position = value;
	func getPosition() -> Vector2: return position;

	func _init(index:Vector2, movementConstraint: int):
		self.position = position;
		self._movementConstraint = movementConstraint;
		
	func moveTo(position:Vector2) -> Vector2:
		match(_movementConstraint):
			MovementConstraint.Horizontal:
				self.position.x = position.x;
			MovementConstraint.Vertical:
				self.position.y = position.y;
			MovementConstraint.Two2D:
				self.position = position;
		
		return position
	
	func draw(node:CanvasItem, handleSize:float, style:int):
		match(style):
			VertexHandleStyle.MouseOver,VertexHandleStyle.Dragging:
				node.draw_circle(position,handleSize,Color.red)
			_:
				node.draw_circle(position,handleSize,Color.aqua)	
	

class Handle:
	var position: Vector2 = Vector2.ZERO setget , getPosition;
	func getPosition() -> Vector2: return position;
	
	func draw(node:CanvasItem, handleSize:float, style:int): assert(false, "Function not implemented");
	func moveTo(position:Vector2) -> Vector2:  assert(false, "Function not implemented");
	
class VertexHandle extends Handle:
	var vertexId:int;
	
	
	
	
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var size: Vector2 = rect_size;
	
	_vertices = [ Vector2(0,size.y), Vector2(size.x/3.0,size.y/2), Vector2(size.x*2/3.0,size.y/2), Vector2(size.x,size.y)];
		
	_handles = [ VertexHandle.new(Vector2(size.x/3.0,size.y/2),MovementConstraint.Horizontal),
				 VertexHandle.new(Vector2(size.x*2/3.0,size.y/2),MovementConstraint.Vertical)];

func _process(delta):
	pass;

func _draw():
	
	var size: Vector2 = rect_size;
	
			
	for i in range(0,_vertices.size()-1):
		draw_line(_vertices[i], _vertices[i+1], Color.white,5.0,true);
	
	
	for i in range(0,_handles.size()):
		var style:int = VertexHandleStyle.None;
		if _mouseOverHandleIndex == i:
			style = VertexHandleStyle.MouseOver
		elif _draggingHandleIndex == i:
			style = VertexHandleStyle.Dragging
		
		_handles[i].draw(self,_handleSize,style);

func _handleDraggingStart(handleIndex: int):
	_draggingHandleIndex = handleIndex;
	
func _handleDraggingEnd(handleIndex: int):
	_draggingHandleIndex = -1;

func _handleDraggingMove(globalPos:Vector2):
	var relativePos:Vector2 = _global_to_control(globalPos);
	_handles[_draggingHandleIndex].moveTo(relativePos);
	_handles[1].position = (_handles[2].position - _handles[0].position)/2.0 + _handles[0].position;
	update();
	pass;		

func _input(event):
	if event is InputEventMouseButton:
		#print("Mouse click at: ", _global_to_control(event.position));
		if event.button_index == 1:
			var index = _getHandleIndexAtGlobalPos(event.position);
			if event.pressed:
				_handleDraggingStart(index);
			else:
				_handleDraggingEnd(index);
	elif event is InputEventMouseMotion:
		if _draggingHandleIndex != -1:
			_handleDraggingMove(event.position);
		else:
			var index = _getHandleIndexAtGlobalPos(event.position);
			if index != _mouseOverHandleIndex:
				_mouseOverHandleIndex = index;
				update();

func _global_to_control(globalCoords: Vector2) -> Vector2:
	var globalControlPos = get_global_rect().position;
	return Vector2(globalCoords.x - globalControlPos.x, globalCoords.y - globalControlPos.y)

func _isMouseOnHandle(handle:Vector2) -> bool:
	return true;
	
func _getHandleIndexAtGlobalPos(globalPos:Vector2) -> int:
	var relativePos:Vector2 = _global_to_control(globalPos);
	var foundIndex = -1;
	var i = 0;
	
	while i < _handles.size() && foundIndex==-1:
		var distance:float = (_handles[i].position-relativePos).length();
		if distance <= _handleSize:
			foundIndex = i;
		else:
			i+=1;
	return foundIndex;
	
	
		

	
