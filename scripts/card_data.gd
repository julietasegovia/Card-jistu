extends Resource
class_name CardData

enum Type { ICE, WATER, FIRE }

@export var power: int = 1
@export var type: Type = Type.ICE
@export var texture: Texture2D
