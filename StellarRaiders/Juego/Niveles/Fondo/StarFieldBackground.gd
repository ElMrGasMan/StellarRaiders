tool
extends ParallaxBackground


export var color_nivel: Color = Color.black

onready var color_fondo: ColorRect = $ColorRect


func _ready() -> void:
	color_fondo.color = color_nivel


func _process(_delta: float) -> void:
	if Engine.editor_hint: 
		color_fondo.color = color_nivel
