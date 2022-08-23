extends ColorRect
class_name GraphSegment

signal segmentChanged

var _handle:GraphSegmentHandle = null
var _isMouseOver:bool = false;

var _isDragging = false;

var segmentId = -1 setget ,segmentId;
func segmentId(): return segmentId;

func _init(segmentId:int, position:Vector2, handle:GraphSegmentHandle = null):
	self.segmentId = segmentId;
	
	self._handle = handle; 
	var handleSize = GraphUITheme.SEGMENT_HANDLE_NORMAL_SIZE;
	self.color = Color.black;
	var hsv = Vector2(handleSize, handleSize);
	self.set_size(hsv);
	self.set_position(position); #This is relative to control's parent
	
	if self._handle != null:
		connect("mouse_entered", self, "_on_mouse_entered")
		connect("mouse_exited", self, "_on_mouse_exited")
		connect("gui_input", self, "_on_gui_input")	

func _draw():
	if _handle!=null:
		var size:float = GraphUITheme.MOUSE_OVER_SEGMENT_HANDLE_SIZE if _isMouseOver==true else GraphUITheme.SEGMENT_HANDLE_NORMAL_SIZE
		var color:Color = GraphUITheme.MOUSE_OVER_SEGMENT_HANDLE_COLOR if _isMouseOver==true else GraphUITheme.SEGMENT_HANDLE_NORMAL_COLOR
		_handle.draw(self, rect_size/2.0, size/2.0, color)
	else:
		self.draw_circle(rect_size/2.0,GraphUITheme.SEGMENT_HANDLE_NORMAL_SIZE/2.0,GraphUITheme.SEGMENT_HANDLE_NORMAL_COLOR); #This is relative the the control bounds.

		
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
	var oldGlobalPos:Vector2 = rect_global_position;
	var newFixedPosInControl:Vector2 = _handle.moveTo(positionInControl)
	rect_position+=newFixedPosInControl;
	
	var deltaPos:Vector2 = rect_global_position-oldGlobalPos;
	emit_signal("segmentChanged", self.segmentId(), deltaPos);
	
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

