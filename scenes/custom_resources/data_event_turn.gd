extends RefCounted

class_name DataEventTurn

enum EventType {
    TURN_FINISHED,
    DIED,
}

var event_type: EventType
var unit: Unit = null
