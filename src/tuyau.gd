@tool
extends Node2D

@onready var tuyau_haut: TileMapLayer = %tuyau_haut
@onready var tuyau_bas: TileMapLayer = %tuyau_bas

@export var vitesse = 192
@export var distance_entre_tuyaux: int = 80:
	set(value):
		if tuyau_bas:
			distance_entre_tuyaux = value
			tuyau_haut.position.y = -distance_entre_tuyaux/2
			tuyau_bas.position.y = distance_entre_tuyaux/2

var max_offset = 96

func _ready():
	var offset = randf_range(-max_offset, max_offset)
	position.y += offset

func _process(delta):
	if !Engine.is_editor_hint():
		position.x -= vitesse * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().change_scene_to_file("res://src/niveau1.tscn")
