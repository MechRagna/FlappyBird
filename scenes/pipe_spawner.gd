extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored

var pipe_pair_scene: PackedScene = preload("res://scenes/pipe_pair.tscn")

@export var pipe_speed: int = -150

@onready var spawn_timer: Timer = $SpawnTimer

func _ready():
	spawn_timer.timeout.connect(spawn_pipe)

func start_spawning_pipes() -> void:
	spawn_timer.start()

func spawn_pipe() -> void:
	var pipe = pipe_pair_scene.instantiate() as PipePair
	add_child(pipe)
	
	var viewport_rect: Rect2 = get_viewport().get_camera_2d().get_viewport_rect()
	pipe.global_position.x = viewport_rect.end.x
	
	var half_height: float = viewport_rect.size.y / 2
	var from: float = viewport_rect.size.y * 0.15 - half_height
	var to: float = viewport_rect.size.y * 0.65 - half_height
	pipe.position.y = randf_range(from, to)
	
	pipe.bird_entered.connect(on_bird_entered)
	pipe.point_scored.connect(on_point_scored)
	pipe.set_speed(pipe_speed)

func on_bird_entered() -> void:
	bird_crashed.emit()
	stop()

func stop() -> void:
	spawn_timer.stop()
	for pipe in get_children().filter(func (child): return child is PipePair):
		(pipe as PipePair).speed = 0

func on_point_scored() -> void:
	point_scored.emit()
