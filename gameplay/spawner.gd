class_name Spawner extends Node2D
#signals
signal tail_added(tail:Tail)

#export vars
@export var bounds:Bounds

#instatiating packed scenes
var food_scene:PackedScene = preload("res://gameplay/food.tscn") #preloads food into memory so instantiation is faster
var tail_scene:PackedScene = preload("res://gameplay/tail.tscn")

func spawn_food():
	# 1 where to spawn food
	var spawn_point:Vector2 = Vector2.ZERO
	spawn_point.x = randf_range(bounds.x_min + Global.CELL_SIZE, bounds.x_max - Global.CELL_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.CELL_SIZE, bounds.y_max - Global.CELL_SIZE)
	# spawn point is divided by grid cell and round down to nearest integer. this so that apple appears centered in tile
	spawn_point.x = floorf(spawn_point.x / Global.CELL_SIZE) * Global.CELL_SIZE
	spawn_point.y = floorf(spawn_point.y / Global.CELL_SIZE) * Global.CELL_SIZE
	# 2 what we are spawning (instantiating)
	var food = food_scene.instantiate()
	food.position = spawn_point
	# 3 where we are putting it (parenting)
	get_parent().add_child(food) #parent of spawner is gameplay, so we are adding child food to gameplay. this method works for simple projects

func spawn_tail(pos:Vector2):
	var tail:Tail = tail_scene.instantiate(10) as Tail
	tail.position = pos
	get_parent().add_child(tail)
	tail_added.emit(tail)
