extends ColorRect
	
class_name GraphVertex 

signal vertexChanged

var _handle:GraphVertexHandle = null
var _isMouseOver:bool = false;

var _isDragging = false;

func _init(position:Vector2, handle:GraphVertexHandle = null):
	self._handle = handle; 
	self.color = Color.black;
	var handleSize = GraphUITheme.VERTEX_HANDLE_NORMAL_SIZE;
	var hsv = Vector2(handleSize, handleSize);
	self.set_size(hsv);
	self.set_position(position-hsv/2.0); #This is relative to control's parent
	if self._handle != null:
		connect("mouse_entered", self, "_on_mouse_entered")
		connect("mouse_exited", self, "_on_mouse_exited")
		connect("gui_input", self, "_on_gui_input")	

func _draw():
	if _handle!=null:
		var size:float = GraphUITheme.MOUSE_OVER_VERTEX_HANDLE_SIZE if _isMouseOver==true else GraphUITheme.VERTEX_HANDLE_NORMAL_SIZE
		var color:Color = GraphUITheme.MOUSE_OVER_VERTEX_HANDLE_COLOR if _isMouseOver==true else GraphUITheme.VERTEX_HANDLE_NORMAL_COLOR
		_handle.draw(self, get_size(), size, color)
	else:
		var size:float = GraphUITheme.MOUSE_OVER_VERTEX_HANDLE_SIZE if _isMouseOver==true else GraphUITheme.VERTEX_HANDLE_NORMAL_SIZE
		self.draw_circle(get_size()/2.0, GraphUITheme.VERTEX_NORMAL_SIZE,GraphUITheme.VERTEX_NORMAL_COLOR); #This is relative the the control bounds.

		
func _on_mouse_entered():
	_isMouseOver = true;
	update();

func _on_mouse_exited():
	_isMouseOver = false;
	update();

func _handleDragStart():
	_isDragging = true;

func _handleDragEnd():
	_isDragging = false;

func _handleDraggingMove(positionInControl:Vector2):
	rect_position += _handle.moveTo(positionInControl)		
	
	emit_signal("vertexChanged", self);
	
func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				_handleDragStart()
			else:
				_handleDragEnd()
	elif event is InputEventMouseMotion:
		if _isDragging:
			_handleDraggingMove(event.position);

