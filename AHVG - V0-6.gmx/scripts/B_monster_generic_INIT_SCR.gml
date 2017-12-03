#define B_monster_generic_INIT_SCR
// Inheret generic function
event_inherited();

// Setting up generic monster stats
hp = 1;
damage = 1;

// Animation details
animation_loop_start = 0;
animation_loop_frames = 1;
image_speed = 0;

// Tell game that there is  on more monster on the screen
global.B_monster_count++;

// collsion_details
collision_type = "circle";
center_x_offset = 0;
center_y_offset = 0;
radius = 48;



#define B_monster_generic_STEP_SCR
// Inheret generic function
event_inherited();

if !global.B_kill_all
{
    if global.game_state == "battle"
    {
        if (collision_type == "circle" and 
            collision_circle( x + center_x_offset, y + center_y_offset, radius, B_hero_sword_OBJ, true, true ) )
        {
            hp -= 1;
        }
        
        if (hp <= 0 )
        {
            B_generic_kill_self_SCR();
            global.B_monster_count--;
        }
    }
    
}