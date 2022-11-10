class_name PantallaHistoria
extends Node


export(String, FILE, "*.tscn") var nivel_siguiente = ""
onready var musica: Node = $MusicaStellarRaiders


func _ready() -> void:
	musica.ejecutar_musica(musica.get_lista_musica().menu_principal)


func _on_Button_pressed() -> void:
	musica.ejecutar_sfx_botones()
# warning-ignore:return_value_discarded
	get_tree().change_scene(nivel_siguiente)
