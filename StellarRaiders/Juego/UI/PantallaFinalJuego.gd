extends Node


onready var musica: Node = $MusicaStellarRaiders


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	musica.ejecutar_musica(musica.get_lista_musica().menu_principal)


func _on_ButtonSalir_pressed() -> void:
	musica.ejecutar_sfx_botones()
	get_tree().quit()
