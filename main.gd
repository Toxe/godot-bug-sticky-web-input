extends Control

# pressed input, for workaround
var action_strength_move_left := 0
var action_strength_move_right := 0
var action_strength_move_up := 0
var action_strength_move_down := 0


# manual input handling for workaround
func _unhandled_input(event: InputEvent) -> void:
    if not event is InputEventKey or event.is_echo():
        return

    var action := "-"

    if event.is_action("ui_left"):
        action = "ui_left"
        if event.is_pressed():
            action_strength_move_left = 1
        elif event.is_released():
            action_strength_move_left = 0

    if event.is_action("ui_right"):
        action = "ui_right"
        if event.is_pressed():
            action_strength_move_right = 1
        elif event.is_released():
            action_strength_move_right = 0

    if event.is_action("ui_up"):
        action = "ui_up"
        if event.is_pressed():
            action_strength_move_up = 1
        elif event.is_released():
            action_strength_move_up = 0

    if event.is_action("ui_down"):
        action = "ui_down"
        if event.is_pressed():
            action_strength_move_down = 1
        elif event.is_released():
            action_strength_move_down = 0

    log_event(event, action)


func _physics_process(_delta: float) -> void:
    # bugged
    var bug_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

    update_labels(%BugDirection, %BugInput, bug_direction,
                  Input.is_action_pressed("ui_left"), Input.is_action_pressed("ui_right"),
                  Input.is_action_pressed("ui_up"), Input.is_action_pressed("ui_down"))

    # workaround
    var workaround_direction = Vector2(action_strength_move_right - action_strength_move_left,
                                       action_strength_move_down - action_strength_move_up).normalized()

    update_labels(%WorkaroundDirection, %WorkaroundInput, workaround_direction,
                  action_strength_move_left > 0, action_strength_move_right > 0,
                  action_strength_move_up > 0, action_strength_move_down > 0)


func update_labels(direction_label: Label, input_label: Label, direction: Vector2, left_pressed: bool, right_pressed: bool, up_pressed: bool, down_pressed: bool) -> void:
    direction_label.text = "direction: %s" % direction
    input_label.text = "input: %s %s | %s %s" % [
        "left" if left_pressed else "---",
        "right" if right_pressed else "---",
        "up" if up_pressed else "---",
        "down" if down_pressed else "---"
    ]


func log_event(event: InputEventKey, action: String) -> void:
    var text := "[%d | %d] %s | \"%s\" %s" % [
        Engine.get_physics_frames(),
        Engine.get_process_frames(),
        action,
        event.as_text_key_label(),
        "pressed" if event.pressed else "released"
    ]

    %ItemList.add_item(text)
    %ItemList.select(%ItemList.item_count - 1)
    %ItemList.ensure_current_is_visible()
    print(text)
