class_name MusicaJuego
extends Node


export var tiempo_transicion: float = 2.0
export(float, -30.0, -10.0, 5.0) var volumen_apagado = -40.0

var musica_actual_apagar: float = 0.0

onready var musica_ambiental: AudioStreamPlayer = $MusicaAmbiental setget, get_mus_amb
onready var musica_combate: AudioStreamPlayer = $MusicaCombate
onready var lista_musica: Dictionary = {"menu_principal": $MusicaMenuPrincipal} setget, get_lista_musica
onready var sonido_botones: AudioStreamPlayer = $SonidoBotonesMenu
onready var tween_prender: Tween = $TweenPrenderMusica
onready var tween_apagar: Tween = $TweenApagarMusica


# warning-ignore:unused_argument
func _on_TweenApagarMusica_tween_completed(object: Object, key: NodePath) -> void:
	object.stop()
	object.volume_db = musica_actual_apagar


func get_lista_musica() -> Dictionary:
	return lista_musica


func get_mus_amb() -> AudioStreamPlayer:
	return musica_ambiental


func set_musica(stream_ambiental: AudioStream, stream_combate: AudioStream) -> void:
	musica_ambiental.stream = stream_ambiental
	musica_combate.stream = stream_combate


func detener_musica() -> void:
	for node in get_children():
		if node is AudioStreamPlayer:
			node.stop()


func ejecutar_musica(musica: AudioStreamPlayer) -> void:
	detener_musica()
	musica.play()


func ejecutar_sfx_botones() -> void:
	sonido_botones.play()


func transicion_entre_musicas() -> void:
	if musica_ambiental.is_playing():
		fade_in(musica_combate)
		fade_out(musica_ambiental)
	
	else:
		fade_in(musica_ambiental)
		fade_out(musica_combate)


func fade_in(musica: AudioStreamPlayer) -> void:
	var volumen_original = musica.volume_db
	musica.volume_db = volumen_apagado
	musica.play()
# warning-ignore:return_value_discarded
	tween_prender.interpolate_property(
		musica, 
		"volume_db", 
		volumen_apagado,
		volumen_original,
		tiempo_transicion, 
		Tween.TRANS_EXPO, 
		Tween.EASE_IN
	)
	
# warning-ignore:return_value_discarded
	tween_prender.start()


func fade_out(musica: AudioStreamPlayer)-> void:
	musica_actual_apagar = musica.volume_db
# warning-ignore:return_value_discarded
	tween_apagar.interpolate_property(
		musica, 
		"volume_db", 
		musica.volume_db,
		volumen_apagado,
		tiempo_transicion, 
		Tween.TRANS_EXPO, 
		Tween.EASE_OUT
	)
	
# warning-ignore:return_value_discarded
	tween_apagar.start()
