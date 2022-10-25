class_name ContenedorInfoEnergia
extends ContenedorInfo


onready var medidor_energia: ProgressBar = $ProgressBar


func actualizar_medidor(energia_maxima: float, energia_actual: float) -> void:
# warning-ignore:narrowing_conversion
	var energia_porcentaje: int = (energia_actual * 100) / energia_maxima
	medidor_energia.value = energia_porcentaje 
	
