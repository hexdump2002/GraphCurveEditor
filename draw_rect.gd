extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var rect:Rect2 = get_rect();
	rect.position-=get_position();
	draw_rect(rect,Color.red);
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
