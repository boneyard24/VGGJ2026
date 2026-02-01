class_name sprite_box_container
extends HBoxContainer

var cr : ColorRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		child.queue_free()
	#MakeSprites(5)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func sprite_setup(sprites: Array[Texture2D]):
	for sprite in sprites:
		print("SPRITE LOOP")
		#instantiate sprite into hbox

func MakeNewSprites(combo:Array[String]):
	for i in combo:
		AddNewSprite(i)
		
func AddNewSprite(input:String):
	# 1. Create a new ColorRect instance
	var my_color_rect := ColorRect.new()
	my_color_rect.custom_minimum_size = Vector2(40, 40)
	my_color_rect.size_flags_horizontal = Control.SIZE_EXPAND
	my_color_rect.size_flags_vertical = Control.SIZE_EXPAND
	
	if (input == "up"):
		my_color_rect.color = Color(1, 0, 0, 1)
	elif (input == "down"):
		my_color_rect.color = Color(0.331, 0.487, 1.0, 1.0)
	elif (input == "left"):
		my_color_rect.color = Color(0.529, 0.571, 0.0, 1.0)
	elif (input == "right"):
		my_color_rect.color = Color(0.807, 0.002, 0.989, 1.0)
	
	add_child(my_color_rect)
	
func sbc_test():
	print("SPRITE CONNECTED")
	# 1. Create a new ColorRect instance
	var my_color_rect := ColorRect.new()
	
	# 2. Set its properties
	# Note: ColorRect inherits from Control, so it uses 'position' and 'size'
	#my_color_rect.position = Vector2(100, 100) # Set top-left position
	#my_color_rect.size = Vector2(100, 100)   # Set width and height
	my_color_rect.custom_minimum_size = Vector2(40, 40)
	my_color_rect.color = Color(1, 0, 0, 1)   # Set color to red (R, G, B, A, values 0-1)
	
	# 3. Add the new node to the scene tree
	add_child(my_color_rect)
