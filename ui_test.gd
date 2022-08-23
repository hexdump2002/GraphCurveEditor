extends Control

class_name MyFuckingCurve

class utils:
	static func globalToControl(node:Node, globalCoords: Vector2) -> Vector2:
		var globalControlPos = node.get_global_rect().position;
		return Vector2(globalCoords.x - globalControlPos.x, globalCoords.y - globalControlPos.y);
		
class HandleTheme:
	var onMouseOverSize:float;
	var onMouseOverColor:Color;
	var onMousePressedSize: float;
	var onMousePressedColor:Color;

class Handle extends Control:
	var _handleTheme: HandleTheme;
	
	func _init(theme:HandleTheme, position:Vector2):
		self._handleTheme = theme;
		set_anchors_preset(CORNER_TOP_LEFT);
		set_position(position)

	func isMouseOver(globalPos:Vector2):
		var relativePos:Vector2 = utils.globalToControl(self,globalPos);
		var distance:float = (rect_position-relativePos).length();
		
		return true if distance <= _handleTheme.onMouserOverSize else false;

class VertexHandle extends Handle:
	var _vertexId:int = -1;

	func _init(vertexId:int, theme:HandleTheme, position:Vector2).(theme,position):
		_vertexId = vertexId;
		
		
		set_size(Vector2(100.0,100.0));
		
		connect("mouse_entered",self,"_on_mouse_entered");
		
		"""
		var my_style = StyleBoxFlat.new();
		my_style.set_bg_color(Color(0,1,1,1))
		set("custom_styles/normal", my_style)
		"""
		
		
		
	func _draw():
		"""
		if !_hasHandle: return;
		
		match(style):
			VertexHandleStyle.MouseOver,VertexHandleStyle.Dragging:
				node.draw_circle(position,handleSize,Color.red)
			_:
				node.draw_circle(position,handleSize,Color.aqua)	
		"""
		draw_rect(Rect2(Vector2.ZERO,self.rect_size),Color.red);
		draw_circle(self.rect_size/2, _handleTheme.onMouseOverSize, _handleTheme.onMouseOverColor)
		
		pass
	
	func _on_mouse_entered() -> void:
		print("Mouse entered Small");


# Called when the node enters the scene tree for the first time.
func _ready():
	var theme = HandleTheme.new();
	theme.onMouseOverColor = Color.aqua
	theme.onMouseOverSize = 5;
	theme.onMousePressedColor = Color.red;
	theme.onMousePressedSize = 5;
	
func _on_mouse_handle_entered() -> void:
		print("Mouse entered Big");
		
func _addVertexHandle(vertexId:int, vertexHandle:VertexHandle):
	vertexHandle.connect("mouse_entered",self,"_on_mouse_handle_entered")
	add_child(vertexHandle);


#func _draw():
#	draw_rect(Rect2(rect_position,rect_size),Color.white)

