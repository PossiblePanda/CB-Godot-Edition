class_name DnaItemComponent
extends BaseItemComponent

@export var dna: Array[String]

func has_dna(dna_string: String) -> bool:
	return dna.has(dna_string)

func get_component_name() -> String:
	return "DnaComponent"
