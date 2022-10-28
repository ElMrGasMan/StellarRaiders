class_name Minimapa
extends MarginContainer


export var zoom_minimapa: float = 4.5
export var tiempo_activado: float = 7.0

var escala_grilla: Vector2
var jugador: Jugador = null
var es_visible: bool = true setget set_esta_visible

onready var zona_renderizado: TextureRect = $NinePatchRect/ContenedorSprites/ZonaRenderizado
onready var sprite_jugador: Sprite = $NinePatchRect/ContenedorSprites/ZonaRenderizado/Sprite
onready var sprite_estacion_recarga: Sprite = $NinePatchRect/ContenedorSprites/ZonaRenderizado/SpriteEstacionRecarg
onready var sprite_estacion_enemiga: Sprite = $NinePatchRect/ContenedorSprites/ZonaRenderizado/SpriteEstacionEnem
onready var sprite_ambusher: Sprite = $NinePatchRect/ContenedorSprites/ZonaRenderizado/SpriteAmbusher
onready var sprite_puertal: Sprite = $NinePatchRect/ContenedorSprites/ZonaRenderizado/SpritePuertaL
onready var objetos_para_minimapa: Dictionary = {}
onready var tween: Tween = $TweenActivacion
onready var timer_activacion: Timer = $TimerActivacion


func _ready() -> void:
	set_process(false)
	sprite_jugador.position = zona_renderizado.rect_size * 0.5
	escala_grilla = zona_renderizado.rect_size / (get_viewport_rect().size * zoom_minimapa)
	conectar_signals()


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if not jugador:
		return
	
	sprite_jugador.rotation_degrees = jugador.rotation_degrees + 90
	mod_pos_sprites()


func _on_TimerActivacion_timeout() -> void:
	if es_visible:
		set_esta_visible(false)


func set_esta_visible(activar: bool) -> void:
	if activar:
		timer_activacion.start()
	
	es_visible = activar
	
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self,
		"modulate",
		Color(1, 1, 1, not activar),
		Color(1, 1, 1, activar),
		0.5,
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
# warning-ignore:return_value_discarded
	tween.start()


func conectar_signals() -> void:
# warning-ignore:return_value_discarded
	Events.connect("comenzar_nivel", self, "_on_comenzar_nivel")
# warning-ignore:return_value_discarded
	Events.connect("player_destroyed", self, "_on_player_destroyed")
# warning-ignore:return_value_discarded
	Events.connect("objeto_minimapa_creado", self, "obtener_objetos_minimapa")
# warning-ignore:return_value_discarded
	Events.connect("objeto_minimapa_destruido", self, "eliminar_icono")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("activar_minimapa"):
		set_esta_visible(not es_visible)


func _on_player_destroyed(nave: NaveBase, _pos, _exp) -> void:
	if nave is Jugador:
		jugador = null


func _on_comenzar_nivel() -> void:
	jugador = DataJuego.get_jugador_actual()
	obtener_objetos_minimapa()
	set_process(true)


func obtener_objetos_minimapa() -> void:
	var objetos_array : Array = get_tree().get_nodes_in_group("minimapa")
	
	for objeto in objetos_array:
		
		if not objetos_para_minimapa.has(objeto):
			var icono: Sprite
			
			if objeto is EstacionEnemiga:
				icono = sprite_estacion_enemiga.duplicate()
			
			elif objeto is EstacionEspacial:
				icono = sprite_estacion_recarga.duplicate()
			
			elif objeto is EnemigoAmbusher:
				icono = sprite_ambusher.duplicate()
			
			elif objeto is PuertaL:
				icono = sprite_puertal.duplicate()
			
			objetos_para_minimapa[objeto] = icono
			objetos_para_minimapa[objeto].visible = true
			zona_renderizado.add_child(objetos_para_minimapa[objeto])


func mod_pos_sprites() -> void:
	for objeto in objetos_para_minimapa:
		var objeto_icono: Sprite = objetos_para_minimapa[objeto]
		var offset_pos: Vector2 = objeto.position - jugador.position
		var icono_pos: Vector2 = offset_pos * escala_grilla + (zona_renderizado.rect_size * 0.5)
		icono_pos.x = clamp(icono_pos.x, 0, zona_renderizado.rect_size.x)
		icono_pos.y = clamp(icono_pos.y, 0, zona_renderizado.rect_size.y)
		objeto_icono.position = icono_pos


func eliminar_icono(obj: Node2D) -> void:
	if obj in objetos_para_minimapa:
		objetos_para_minimapa[obj].queue_free()
# warning-ignore:return_value_discarded
		objetos_para_minimapa.erase(obj)
