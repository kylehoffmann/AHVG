#define B_slime_INIT_SCR
// Inheret generic function
event_inherited();

// Movement Variables
movement_direction = "still";
facing = "right";
move_duration = 0;
movement_duration = 15;
stillness_duration = 10;
right_percent = 5;
left_percent = right_percent *2;
move_speed = 8;
x_move = 0;

// Hopping
hop_duration = movement_duration/3;
hop_MAX = -16;
hop_counter = hop_duration;
hop_increase = -4;
gravity_increase = 8;
slime_gravity_MAX = 32;
slime_gravity = slime_gravity_MAX;

// Slime animation
current_frame = 0;
frame_count = 0;
total_frames = 3;


#define B_slime_STEP_SCR
// Inheret generic function
event_inherited();

if !global.B_kill_all
{
    
    if (move_duration <= 0)
    {
        next_move = random(100)
        if next_move < right_percent
        {
            x_move = move_speed;
            move_duration = movement_duration;
            movement_direction = "right";
            facing = "right";
            slime_gravity = 0;
            hop_counter = 0;
        }
        else if next_move < left_percent
        {
            x_move = -move_speed;
            move_duration = movement_duration;
            movement_direction = "left";
            facing = "left";
            slime_gravity = 0;
            hop_counter = 0;
        }
        else
        {
            x_move = 0;
            move_duration = stillness_duration;
            movement_direction = "still";
        }
    }
    else
    {
        move_duration--;
    }
    
    if (hop_counter < hop_duration)
    {
        hop_counter++
        if slime_gravity > hop_MAX
        {
            slime_gravity += hop_increase;
            if slime_gravity < hop_MAX
            {
                slime_gravity = hop_MAX;
            }
        }
    }
    else
    {
        if slime_gravity < slime_gravity_MAX
        {
            slime_gravity += gravity_increase;
            if slime_gravity > slime_gravity_MAX
            {
                slime_gravity = slime_gravity_MAX;
            }
        }
    }
    
    y_move = slime_gravity;
    
    if x_move != 0 and
        place_meeting(x + x_move, y, B_collision_OBJ)
    {
        x_move = 0;
    }
    if y_move != 0 and
        place_meeting(x, y + y_move, B_collision_OBJ)
    {
        y_move = 0;
    }
    
    x += x_move; 
    y += y_move; 
    
    if (x < -64 or x > room_width + 64 or y > view_hport[0]+ 64)
    {
        B_generic_kill_self_SCR();
        global.B_monster_count--;
    }
    
    if (movement_direction != "still")
    {
        frame_count++;
        if frame_count >= movement_duration {frame_count -= movement_duration;}
        
        image_index = floor(frame_count/5);
    }
    else
    {
        image_index = 0;
    }
    
    
}


#define B_slime_DRAW_SCR

if (facing == "right")
{
    draw_self();
}
else
{
    draw_sprite_ext( sprite_index, image_index, x, y, -1, 1, 0, c_white, 1 );
}
    