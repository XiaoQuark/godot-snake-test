class_name Gameplay extends Node2D #inherits from Node2D

signal tail_despawned

const gameover_scene:PackedScene = preload("res://menus/game_over.tscn")
const pausemenu_scene:PackedScene = preload("res://menus/pause_menu.tscn")
var tail_scene:PackedScene = preload("res://gameplay/tail.tscn")

#drag node and release while pressing ctrl. make sure type is set as Head as this will help with autocomplete
@onready var head: Head = %Head as Head 
@onready var tail: Tail = %Tail as Tail
@onready var bounds: Bounds = %Bounds as Bounds
@onready var spawner: Spawner = %Spawner as Spawner
@onready var hud: HUD = %HUD
#@onready var snake_parts: SnakeParts = %SnakeParts as SnakeParts
@onready var snakebody = %snakebody


#set interval between snake movement
var time_between_moves:float = 1000.0
var time_since_last_move:float = 0
var speed:float = 2000.0
# sets moving direction at start of game. most game start moving left to right, I changed it to up becasue it's for mobile phone
var move_dir:Vector2 = Vector2.UP #(Vector2(0,-1)
#var head = snake_parts[0]
var snake_parts:Array[SnakeParts] = []
var moves_counter:int = 0
var pause_menu:PauseMenu
var gameover_menu:GameOver
var score:int:
	get: #getters and setters, research
		return score
	set(value):
		score = value
		hud.update_score(value)

func _ready() -> void:
	#for i in 10:
		#var tail:Tail = tail_scene.instantiate() as Tail
		#tail.position = Vector2.ZERO
		#add_child(tail)
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_tail.connect(_on_tail_collided)
	spawner.tail_added.connect(_on_tail_added)
	time_since_last_move = time_between_moves
	spawner.spawn_food()
	snake_parts.push_front(head) # tutorial was using push_back, but I think this is more correct? research
	initialize_snake()
	print(snake_parts)
	#spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size()-1].last_position)
	#print(snake_parts)
	#for n in 10:
		#snake_parts.push_back(tail)
	#loop through snake parts array starting at index 1
	
func initialize_snake():
		spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size()-1].last_position)


# sets user input. ui_up (or maybe it's the uppercase direction?) refers to keyboard keys and joypad buttons. Add ASWD in Project Settings
func _process(_delta) -> void: #not sure I know what this void is

	if Input.is_action_pressed("ui_up"): 
		move_dir = Vector2.UP #(0,-1)
	if Input.is_action_pressed("ui_down"):
		move_dir = Vector2.DOWN #(0,1)
	if Input.is_action_pressed("ui_left"):
		move_dir = Vector2.LEFT #(-1,0)
	if Input.is_action_pressed("ui_right"):
		move_dir = Vector2.RIGHT #(1,0)

	if Input.is_action_just_pressed("ui_cancel"):
		
		pause_game()

#snake is made of area2d nodes, and area2d are physics, we use a physics process loop
func _physics_process(delta: float) -> void:
	#this sets an interval between movements, so it's not continuous
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		time_since_last_move = 0

func update_snake():
	#snake moves on it's own
	#change snake direction:
	var new_position:Vector2 = head.position + move_dir * Global.CELL_SIZE #size of grid cell, set in global script
	new_position = bounds.wrap_vector(new_position)
	head.move_to(new_position) 
	for i in range(1, snake_parts.size(), 1):
		snake_parts[i].move_to(snake_parts[i-1].last_position) # this ensures that the tail follows the head
	moves_counter += 1
	if(moves_counter % 5 == 0):
		despawn_tail()
	print(snake_parts)
	
func _on_food_eaten():
	despawn_tail()
	# 1 spawn more food
	spawner.call_deferred("spawn_food") #call_deferred delays execution of code until first idle time in loop. some sort of async I guess
	#2 add tail
	#spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size()-1].last_position) #adds tail at end of snake_parts array
	#3 increase speed
	speed += 300.0
	#4 update score
	score += 1

func despawn_tail():
	snake_parts.pop_back()
	tail_despawned.emit()

func _on_tail_added(tail:Tail):
		snake_parts.push_back(tail)

func _on_tail_collided():
	if not gameover_menu:
		gameover_menu = gameover_scene.instantiate() as GameOver
		add_child(gameover_menu)
		gameover_menu.set_score(score)

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()

func pause_game():
	if not pause_menu && not gameover_menu:
		pause_menu = pausemenu_scene.instantiate() as PauseMenu
		add_child(pause_menu)
