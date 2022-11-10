class_name BarraSalud
extends ProgressBar


export var siempre_visible: bool = false

onready var tween: Tween = $Tween


func _ready() -> void:
	modulate = Color(1, 1, 1, siempre_visible)


func _on_Tween_tween_all_completed() -> void:
	if modulate.a == 1.0:
		controlar_hitpoints_barra(value, false)


func controlar_hitpoints_barra(hitpoints: float, puede_mostrar: bool) -> void:
	value = hitpoints
	if not tween.is_active() and modulate.a != int(puede_mostrar):
# warning-ignore:return_value_discarded
		tween.interpolate_property(
			self,
			"modulate",
			Color(1, 1, 1, not puede_mostrar),
			Color(1, 1, 1, puede_mostrar),
			2.0, 
			Tween.TRANS_LINEAR, 
			Tween.EASE_OUT
		)
		
# warning-ignore:return_value_discarded
		tween.start()


func controlar_hitpoints_barra_notween(hitpoints: float) -> void:
	value = hitpoints


func settear_valores(hitpoints: float) -> void:
	max_value = hitpoints
	value = hitpoints
