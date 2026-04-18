extends Tower

var tween: Tween

func _ready() -> void:
	usePacketList = false
	onPacketEnter.connect(func(p:Packet): p.increasePayload())
	onPacketEnter.connect(func(p:Packet): print("enter"))
	var collsioonshape: CollisionShape2D = collisionArea.get_child(0)
	var shape: CircleShape2D = collsioonshape.shape
	tween = create_tween().set_loops()
	tween.tween_property(shape, "radius", 600.0, 1)
	tween.tween_interval(0.5)
	tween.tween_property(shape, "radius", 0.0, 0)
	tween.tween_interval(1)


func _physics_process(delta):
	var overlapping := collisionArea.get_overlapping_bodies()
	if overlapping.size() > 0:
		(overlapping[0] as Packet).increasePayload()
