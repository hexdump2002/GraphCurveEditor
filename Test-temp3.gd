extends Control
		
var _vertices: Array = [];
var _segmentHandles: Array= [];


func _ready():
	var size: Vector2 = rect_size;
	
	_vertices = [ 
		GraphVertex.new(Vector2(0,0)), 
		GraphVertex.new(Vector2(size.x/3.0,size.y/2.0),GraphVertexHandle.new(GraphVertexHandle.MovementConstraint.TwoD)), 
		GraphVertex.new(Vector2(size.x*2/3.0,size.y/2),GraphVertexHandle.new(GraphVertexHandle.MovementConstraint.Horizontal)),
		GraphVertex.new(Vector2(size.x,size.y))
	];
	
	_segmentHandles = [
	]
		
	for v in _vertices:
		add_child(v);
		v.connect("vertexChanged",self,"_vertex_changed");
	
	_addSegmentHandle(1);
	
func _draw():
	if(_vertices.size()<=1): return;
	
	for i in range(0,_vertices.size()-1,1):
		draw_line(_vertices[i].rect_position+_vertices[i].rect_size/2, 
			_vertices[i+1].rect_position+_vertices[i].rect_size/2,Color.white) #start line from handle vertex center

func _getSegmentMidpoint(segmentId:int):
	var v0 = _vertices[segmentId].rect_position;
	var v1 = _vertices[segmentId+1].rect_position;
	var midPoint = (v1-v0)/2.0 + v0;
	return midPoint;
	
func _addSegmentHandle(segmentId:int):
	var segment = GraphSegment.new(segmentId,_getSegmentMidpoint(segmentId) , GraphSegmentHandle.new(GraphVertexHandle.MovementConstraint.Vertical))
	segment.connect("segmentChanged",self,"_segmentChanged");
	_segmentHandles.append(segment);
	add_child(segment);

func _updateSegmentHandlesForVertex(vertexId:int):
	# Check if there are segment handlers connecting with this vert
	var segmentIdsToFind:Array = [];
	if vertexId==0:
		if _vertices.size()>0: segmentIdsToFind.append(0);
	elif vertexId==_vertices.size()-1:
		segmentIdsToFind.append(_vertices.size()-1);
	else:
		segmentIdsToFind.append(vertexId-1);
		segmentIdsToFind.append(vertexId);
	
	for sh in _segmentHandles:
		if sh.segmentId in segmentIdsToFind:
			sh.set_position(_getSegmentMidpoint(sh.segmentId));
		
func _vertex_changed(v):
	
	var index:int = _vertices.find(v);
	
	assert(index!=-1, "Vertex not found");
	
	if index > 0:
		if v.rect_position.x < _vertices[index-1].rect_position.x:  v.rect_position.x = _vertices[index-1].rect_position.x
	
	if index < _vertices.size() -1:
		if v.rect_position.x > _vertices[index+1].rect_position.x: 	v.rect_position.x = _vertices[index+1].rect_position.x
		
	_updateSegmentHandlesForVertex(index);
	
	update();

func _segmentChanged(segmentId:int, deltaPos:Vector2):
	_vertices[segmentId].rect_position+=deltaPos;
	_vertices[segmentId+1].rect_position+=deltaPos;
	update();
