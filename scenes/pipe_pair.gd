extends Node2D

class_name PipePair

signal bird_entered
signal point_scored

var speed: int = -100

func set_speed(new_speed: int) -> void:
	speed = new_speed

func _process(delta):
	position.x += speed * delta

func _on_body_entered(body: Bird):
	bird_entered.emit()

func _on_point_scored(body: Bird):
	point_scored.emit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
