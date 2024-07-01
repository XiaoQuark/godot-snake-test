class_name SnakeBody extends Node

var HEAD_scene:PackedScene = preload("res://gameplay/head.tscn")
var TAIL_scene:PackedScene = preload("res://gameplay/tail.tscn")

var snake_body = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var head = HEAD_scene.instantiate()
	var tail = TAIL_scene.instantiate()
	snake_body.push_front(head)
	for n in 8:
		snake_body.push_back(tail)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
