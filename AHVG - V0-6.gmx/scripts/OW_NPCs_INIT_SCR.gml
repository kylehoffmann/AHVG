#define OW_NPCs_INIT_SCR
// Inheret generic function
event_inherited();

image_speed = 0;

speaking_collision = instance_create(x, y, OW_NPC_collision_OBJ);

speaking_collision.parent = self;

hero_in_range = false;

current_dialogue = "";

dialogue_tree[0, 0] = true;
dialogue_tree[0, 1] = true;
dialogue_tree[0, 2] = "Hello";

counter_to_change_event = -1;

index_to_write = 0;
value_to_write = 0;

wait_until_speech_reset = false;

#define OW_NPCs_STEP_SCR
// Protects against collision looking for this object if this object no longer exists
if global.OW_kill_all
{
    speaking_collision.parent = 0;
}

// Inheret generic function
event_inherited();

if counter_to_change_event > -1
{
    counter_to_change_event--;
}

if counter_to_change_event == 0
{
    global.NPC_DATA[index_to_write] = value_to_write;
}

current_dialogue = "";

if hero_in_range
{
    i = array_height_2d(dialogue_tree) - 1
    while (i > -1)
    {
        if dialogue_tree[i, 0] == "true"
        {
            current_dialogue = dialogue_tree[i, 2];            
            if (counter_to_change_event < 0 and
                not (dialogue_tree[i, 3] == "true"
                or dialogue_tree[i, 3] =="false"))
            {
                index_to_write = dialogue_tree[i, 3];
                value_to_write = dialogue_tree[i, 4];
                if dialogue_tree[i, 5] == 0
                {
                    counter_to_change_event = -1;
                    wait_until_speech_reset = true;
                }
                else
                {
                    counter_to_change_event = abs(dialogue_tree[i, 5]) * string_length(current_dialogue);
                    wait_until_speech_reset = false;
                }
            }
            break;        
        }
        else if global.NPC_DATA[dialogue_tree[i, 0]] == dialogue_tree[i, 1]
        {
            current_dialogue = dialogue_tree[i, 2];
            if (counter_to_change_event < 0 and
                not (dialogue_tree[i, 3] == "true"
                or dialogue_tree[i, 3] =="false"))
            {
                index_to_write = dialogue_tree[i, 3];
                value_to_write = dialogue_tree[i, 4];
                if dialogue_tree[i, 5] == 0
                {
                    counter_to_change_event = -1;
                    wait_until_speech_reset = true;
                }
                else
                {
                    counter_to_change_event = abs(dialogue_tree[i, 5]) * string_length(current_dialogue);
                    wait_until_speech_reset = false;
                }
            }
            break;
        }
        i--;
    }
    
    //current_dialogue = "Test Success!";
}
else
{
    if (counter_to_change_event > 1 or
        wait_until_speech_reset)
    {
        counter_to_change_event = 1;
        wait_until_speech_reset = false;
    }
}

speaking_collision.current_dialogue = current_dialogue;

#define OW_NPCs_DRAW_SCR
// Inheret generic function
event_inherited();

//draw_text_transformed(x,y,string(counter_to_change_event),3,3,0);