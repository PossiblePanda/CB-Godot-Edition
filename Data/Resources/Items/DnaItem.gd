class_name DnaItem
extends Item

@export var dna: Array[String]

func has_dna(dna_string: String) -> bool:
	return dna.has(dna_string)
