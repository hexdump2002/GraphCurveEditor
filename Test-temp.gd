extends Control

var _vertices: Array = [];
var _handles: Array= [];

var _handleSize:int = 10;
var _mouseOverHandleIndex = -1;
var _draggingHandleIndex = -1;
var _draggingType:int = -1;

enum VertexHandleStyle {MouseOver, Dragging, None}
enum HandleType {Vertex, Segment}

class utils:
	static func _global_to_control(globalCoords: Vector2) -> Vector2:
		var globalControlPos = get_global_rect().position;
		return Vector2(globalCoords.x - globalControlPos.x, globalCoords.y - globalControlPos.y);


class HandleTheme:
	var onMouseOverSize:float;
	var onMouseOverColor:Color;
	var onMousePressedSize: float;
	var onMousePressedColor:Color;

class Handle:
	var theme: HandleTheme;
	
	var position: Vector2 = Vector2.ZERO setget setPosition, getPosition;
	func setPosition(value:Vector2): position = value;
	func getPosition() -> Vector2: return position;
	
	func _init(theme:HandleTheme, position:Vector2):
		self.theme = theme;
		self.position = position;
	
	func isMouseOver(globalPos:Vector2):
		var relativePos:Vector2 = _global_to_control(globalPos);
		var distance:float = (position-relativePos).length();
		
		return true if distance <= _handleSize else false;
		

	func draw(node:CanvasItem): assert(false, "Not implemented...");


class VertexHandle extends Handle:
	var _vertexId:int = -1;
	
	func _init(vertexId:int, theme:HandleTheme, position:Vector2):
		super(theme, position);
		_vertexId = vertexId;
		
	
	func draw(node:CanvasItem, handleSize:float, style:int):
		if !_hasHandle: return;
		
		match(style):
			VertexHandleStyle.MouseOver,VertexHandleStyle.Dragging:
				node.draw_circle(position,handleSize,Color.red)
			_:
				node.draw_circle(position,handleSize,Color.aqua)	
				
class SegmentHandle extends Handle:
	func _init(): pass



		
class Vertex:
	enum MovementConstraint { Horizontal, Vertical, TwoD, None}
	
	var _movementConstraint: int = MovementConstraint.None;
	var _hasHandle: bool = false;
	
	var position: Vector2 = Vector2.ZERO setget setPosition, getPosition;
	func setPosition(value:Vector2): position = value;
	func getPosition() -> Vector2: return position;

	func _init(position:Vector2):
		self.position = position;
		
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
		if !_hasHandle: return;
		
		match(style):
			VertexHandleStyle.MouseOver,VertexHandleStyle.Dragging:
				node.draw_circle(position,handleSize,Color.red)
			_:
				node.draw_circle(position,handleSize,Color.aqua)	
	


# Called when the node enters the scene tree for the first time.
func _ready():
	var size: Vector2 = rect_size;
	
	var theme = HandleTheme.new();
	theme.onMouseOverColor = Color.aqua
	theme.onMouseOverSize = 5;
	theme.onMousePressedColor = Color.red;
	theme.onMousePressedSize = 5;
	
	
	_vertices = [ Vector2(0,size.y), Vector2(size.x/3.0,size.y/2), Vector2(size.x*2/3.0,size.y/2), Vector2(size.x,size.y)];
		
	_handles = [ VertexHandle.new(1,theme, Vector2(size.x/3.0,size.y/2)),
				 VertexHandle.new(2,theme,Vector2(size.x*2/3.0,size.y/2))];
	
func _process(delta):
	pass;

func _draw():
	
	var size: Vector2 = rect_size;
	
	
	for i in range(0,_vertices.size()-1):
		draw_line(_vertices[i].position, _vertices[i+1].position, Color.white,5.0,true);
		
		var style:int = VertexHandleStyle.None;
		if _mouseOverHandleIndex == i:
			style = VertexHandleStyle.MouseOver
		elif _draggingHandleIndex == i:
			style = VertexHandleStyle.Dragging
			
		_vertices[i].draw(self, _handleSize, style);
	
	#draw now segment handles
	"""
	for i in range(0,_segmentHandles.size()):
		var segmentIndex:int = _segmentHandles[i];
		var midPoint =  (_vertices[segmentIndex+1].position - _vertices[segmentIndex].position)/2.0 + _vertices[segmentIndex].position;
		draw_circle(midPoint, _handleSize, Color.chartreuse);
	"""

func _handleDraggingStart(handleIndex: int):
	_draggingHandleIndex = handleIndex;
	
func _handleDraggingEnd(handleIndex: int):
	_draggingHandleIndex = -1;

func _handleDraggingMove(globalPos:Vector2):
	var relativePos:Vector2 = _global_to_control(globalPos);
	_vertices[_draggingHandleIndex].moveTo(relativePos);
	#_handles[1].position = (_handles[2].position - _handles[0].position)/2.0 + _handles[0].position;
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
	
func _getHandleIndexAtGlobalPos(globalPos:Vector2) -> int:
	var foundIndex = -1;
	var i = 0;
	
	while i < _handles.size() && foundIndex==-1:
		if(_handles[i].isMouseOver(globalPos)):
			foundIndex = i;
		else:
			i+=1;
			
	return foundIndex;
	
	
		

	
