tool
extends ParallaxBackground


onready var color_fondo: ColorRect = $ColorRect

export var color_nivel: Color = Color.black


func _ready() -> void:
	color_fondo.color = color_nivel


func _process(delta: float) -> void:
	if Engine.editor_hint: 
		color_fondo.color = color_nivel
