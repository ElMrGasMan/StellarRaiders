class_name ContenedorInfo
extends NinePatchRect


export var puede_auto_ocultar: bool = false setget set_auto_ocultar

var esta_visible: bool = true setget set_esta_visible

onready var animaciones: AnimationPlayer = $AnimationPlayer
onready var auto_ocultar_timer: Timer = $TimerDesaparecer 
onready var texto_dinamico: Label = $Label


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Invisible_Visible" and puede_auto_ocultar:
		auto_ocultar_timer.start()


func _on_TimerDesaparecer_timeout() -> void:
	visible_invisible()


func set_auto_ocultar(valor: bool) -> void:
	puede_auto_ocultar = valor


func set_esta_visible(valor: bool) -> void:
	esta_visible = valor


func invisible() -> void:
	if not esta_visible:
		animaciones.play("Invisible")


func visiblee() -> void: 
	if esta_visible:
		animaciones.play("Visible")


func invisible_visible() -> void:
	if not esta_visible:
		return 
	animaciones.play("Invisible_Visible")


func visible_invisible() -> void:
	if esta_visible:
		animaciones.play("Visible_Invisible")


func modificar_texto(texto: String) -> void:
	texto_dinamico.text = texto
