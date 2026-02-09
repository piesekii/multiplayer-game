extends StaticBody3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_player: AudioStreamPlayer3D = %AudioStreamPlayer3D

func _ready() -> void:
	Global.jukebox = self

func on_interaction() -> void:
	Global.play_jukebox()

func play_jukebox() -> void:
	animation_player.play("disco_tocando")
	audio_player.play()
