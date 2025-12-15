extends Node

var initializing = true

# Set a property on an entity
func set_entity_property(obj: Object, property_name: StringName, value: Variant):
	obj.set(property_name, value)
	obj.set_meta(property_name, value)

func set_entity_property_deferred(obj: Object, property_name: StringName, value: Variant):
	obj.set_deferred(property_name, value)
	obj.call_deferred("set_meta", property_name, value)

func get_entity_property(obj: Object, property_name: StringName) -> Variant:
	var v = obj.get(property_name)
	if v != null:
		return v
	if property_name in obj.get_meta_list():
		return obj.get_meta(property_name)
	return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#for c in get_children():
		#var e = SimEntity.new(c)
		#entities.push_back(e)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

var sad_texture: Texture2D = load("res://textures/sad1.svg")

# Perform a deferred update using a recording object.
# fn must:
#  * Be pure
#  * Only use state it captured when it was created (not new global state)
#  * Be commutative and associated with all other updates on the property.
# If these conditions are met, the order of updates should not be observable, so the order of 
# rule execution should not be observable.
func deferred_update(record: Dictionary, obj: Object, property_name: StringName, fn):
	var key = [obj, property_name]
	var v = record.get(key)
	if v == null:
		v = get_entity_property(obj, property_name)
	v = fn.call(v)
	record[key] = v

func _physics_process(_delta: float) -> void:
	var recorded: Dictionary = {}
	for a in get_children():
		if initializing:
			deferred_update(recorded, a, StringName("friend"), func(_v): return "None")
		for b in get_children():
			if a == b:
				continue
			#if get_entity_property(b, StringName("moving")):
			var a_offset: Vector2 = get_entity_property(a, StringName("position"))
			var b_offset: Vector2 = get_entity_property(b, StringName("position"))
			if a_offset.distance_to(b_offset) < 20:
				deferred_update(recorded, a, StringName("friend"), func(_v): return b.name)
			if a_offset.distance_to(b_offset) < 100:
				var vel = (a_offset - b_offset) / 100
				deferred_update(recorded, a, StringName("position"), func (v): return v - vel)
			
		if get_entity_property(a, StringName("emotional")):
			for b in get_children():
				if a == b:
					continue
				var a_offset: Vector2 = get_entity_property(a, StringName("position"))
				var b_offset = get_entity_property(b, StringName("position"))
				if a_offset.distance_to(b_offset) < 10:
					deferred_update(recorded, a, StringName("texture"), func (_v): return sad_texture)
		
		if get_entity_property(a, StringName("moving")):
			var offset = get_entity_property(a, StringName("position"))
			if offset != null:
				deferred_update(recorded, a, StringName("position"), func (v): 
					v.x += 1
					return v
						)
 
	for k in recorded.keys():
		set_entity_property(k[0], k[1], recorded[k])
	
	initializing = false
