class_name Tail extends SnakeParts

@export var textures:Array[Texture]

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	pass
	#var snake_parts:Array[SnakePart] = []
	#for n in 10:
		#snake_parts.push_back(sprite_2d.texture)
	sprite_2d.texture = textures.pick_random()
