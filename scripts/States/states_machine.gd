extends Node

# reference to nodes
@onready var locked: Node = $Locked
@onready var idle: Node = $Idle
@onready var run: Node = $Run
@onready var jump: Node = $Jump
@onready var jump_peak: Node = $JumpPeak
@onready var fall: Node = $Fall
@onready var die: Die = $Die
