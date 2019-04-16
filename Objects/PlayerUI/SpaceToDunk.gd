extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_loc = Vector2()

	new_loc.x = self.rect_position.x - self.get_global_transform_with_canvas().get_origin().x
	new_loc.y = self.rect_position.y - self.get_global_transform_with_canvas().get_origin().y
	self.rect_position = new_loc
