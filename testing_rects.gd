extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var x:int = 512;
var y:int = 600;

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_viewport().size)
	connect("mouse_entered",self,"_on_mouse_entered");

func _on_mouse_entered() -> void:
		print("Mouse entered Big");

func _draw():
	#draw_rect(Rect2(rect_position,rect_size),Color.red)
	draw_rect(Rect2(Vector2.ZERO,rect_size*2/2),Color.red)

func _input(event):
	if event is InputEventKey:
		if !event.pressed:
			if event.scancode == KEY_A:
				x+=50;
			else:
				y+=50;
			
			update();
		
			
		print("x: %d y: %d" % [x,y]);
