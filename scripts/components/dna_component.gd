extends Node

@export var default_dna : Array[String]

var dna : Array[String] = []

func _ready() -> void:
	for dna_string in default_dna:
		dna.push_back(dna_string)


func add_dna(dna_string: String)->void:
	dna.push_back(dna_string)


func has_dna(dna_string: String) -> bool:
	return dna.has(dna_string)
