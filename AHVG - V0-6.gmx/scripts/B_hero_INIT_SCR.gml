#define B_hero_INIT_SCR
// Inheret generic function
event_inherited();

image_speed = 0;

battle_end = false;

player_move_x = 0;
player_move_y = 0;


hero_facing = "right";

i_frames = 0;

walk_cycle = 0;
walk_cycle_MAX = 15;
walk_cycle_current = 0;
walk_cycles = 2;
walk_right = walk_cycles;
walk_right_sword = walk_cycles* 2;
walk_left = walk_cycles * 3;
walk_left_sword = walk_cycles * 4;
walk_cycle_current_limit = walk_right;


#define B_hero_STEP_SCR
// Inheret generic function
event_inherited();

if !global.B_kill_all
{
    if global.game_state == "battle"
    {
        //Clean up varibles by making global values local values
        if (!global.battle_jumped) 
        {
            player_move_x = global.B_player_move_x;
            inertia = player_move_x;
        }
        else
        {
            player_move_x = inertia + 1/2 * global.B_player_move_x;
        }
        player_move_y = global.battle_gravity;
        
        // Correct Hero facing
        hero_facing = global.B_hero_facing;
        
        /*if ( player_move_x != 0 or player_move_y != 0)
        {
        
            !place_meeting(x + player_move_x, y, OW_collision_tile_OBJ) and
                !place_meeting(x + player_move_x, y, OW_collision_tile_OBJ) and
                
            {
                x += player_move_x;
            }
        }*/
        
        // This is the sprite speed
        //  -   Where this currently is will animate the sprite even if 
        //          something stops it from moving. Moving it below the cases that
        //          stop x/y move will also stop animation.
        if (player_move_x == 0)
        {
            image_speed = 0;
            walk_cycle = 0;
        }
        else
        {
            //image_speed = 0.125;
            walk_cycle++;
        }
        
        //Special cases to check if the player is already as close to the wall as possible.
        //
        //  -   Will need to be fixed as once the program allows the user to walk within a pixel 
        //          of the walls
        //
        // horizontal
        move_sign = sign(player_move_x);
        if player_move_x != 0 and
            place_meeting(x + player_move_x, y, B_collision_OBJ)
        {
            player_move_x = 0;
        }
        // vertical
        move_sign = sign(player_move_y);
        if player_move_y != 0 and
            place_meeting(x , y + player_move_y, B_collision_OBJ)
        {
            adjusted_move_y = ceil(player_move_y/2);
            remaining_player_y = player_move_y - adjusted_move_y;
            player_move_y = 0;
            //while (remaining_player_y > 0)
            {
                adjusted_move_y = ceil(remaining_player_y/2);
                remaining_player_y -= adjusted_move_y;
                if (!place_meeting(x , y + adjusted_move_y, B_collision_OBJ))
                {
                    player_move_y += adjusted_move_y;
                }
            }
            // End jump if player can fall no further
            if (player_move_y == 0)
            {
                global.battle_jumped = false;
            }
        }
        
        
        //Player Move x !=0 y =0
        if ( player_move_x != 0 and player_move_y == 0 and 
            !place_meeting(x + player_move_x, y, B_collision_OBJ))
        {
            x += player_move_x;
        }
        
        //Player Move x =0 y !=0
        if ( player_move_x == 0 and player_move_y != 0 and 
            !place_meeting(x, y + player_move_y, B_collision_OBJ))
        {
            y += player_move_y;
        }
        
        //Player Move x !=0 y !=0
        if ( player_move_x != 0 and player_move_y != 0 and 
            !place_meeting(x + player_move_x, y + player_move_y, B_collision_OBJ) )
        {
            x += player_move_x;
            y += player_move_y;
        }
        
        
    }
    else
    {
        image_speed = 0;
    }
    
}

if (y > room_height and !battle_end)
{
    battle_end_SCR();
    battle_end = true;
}

// Process i frames
if (i_frames > 0)
{
    i_frames--;
}

monster = collision_rectangle( bbox_left, bbox_top, bbox_right, bbox_bottom, B_monster_generic_OBJ, true, true )
if (monster and i_frames <= 0)
{
    global.player_health -= monster.damage;
    global.player_hit = true;
    if (monster.x < x)
    {
        hero_facing = "left"
        inertia = global.battle_controller.player_move_speed;
    }
    else
    {
        hero_facing = "right"
        inertia = -global.battle_controller.player_move_speed;
    }
    i_frames = 15;
    global.jumping_not_hit = false;
}

if (global.B_hero_crouch == true)
{
    sprite_index = B_hero_crouch_SPR;
    walk_cycle = 0;
}
else if (global.battle_jumped and (global.jumping_not_hit or no_deticated_damage_spr))
{
    sprite_index = B_hero_jump_SPR;
    walk_cycle = 0;
}
else
{
    sprite_index = B_hero_walk_SPR;
    if (hero_facing = "right" and
        !instance_exists(B_hero_sword_OBJ))
    {
        if (walk_cycle_current >= walk_right)
        {
            walk_cycle=0;
            walk_cycle_current=walk_right-walk_cycles;
        }
        walk_cycle_current_limit = walk_right;
        
    }
    else if (hero_facing = "left" and
        !instance_exists(B_hero_sword_OBJ))
    {
        if (walk_cycle_current >= walk_left or 
            walk_cycle_current < walk_left-walk_cycles)
        {
            walk_cycle=0;
            walk_cycle_current=walk_left-walk_cycles;
        }
        walk_cycle_current_limit = walk_left;
        
    }
    else if (hero_facing = "right" and
        instance_exists(B_hero_sword_OBJ))
    {
        if (walk_cycle_current >= walk_right_sword or 
            walk_cycle_current < walk_right_sword-walk_cycles)
        {
            walk_cycle=0;
            walk_cycle_current=walk_right_sword-walk_cycles;
        }
        walk_cycle_current_limit = walk_right_sword;
        
    }
    else if (hero_facing = "left" and
        instance_exists(B_hero_sword_OBJ))
    {
        if (walk_cycle_current >= walk_left_sword or 
            walk_cycle_current < walk_left_sword-walk_cycles)
        {
            walk_cycle=0;
            walk_cycle_current=walk_left_sword-walk_cycles;
        }
        walk_cycle_current_limit = walk_left_sword;
        
    }
        
    if (walk_cycle >= walk_cycle_MAX)
    {
        walk_cycle=0;
        walk_cycle_current++;
        if (walk_cycle_current >= walk_cycle_current_limit)
        {
            walk_cycle_current = walk_cycle_current_limit - walk_cycles;
        }
    }
    image_index = walk_cycle_current;
}

#define B_hero_DRAW_SCR
if (global.B_hero_crouch == true or 
    (global.battle_jumped and (global.jumping_not_hit or no_deticated_damage_spr)))
{
    if( hero_facing == "right")
    {
        image_index = 0;
    }
    else
    {
        image_index = 2;
    }
    if (instance_exists(B_hero_sword_OBJ))
    {
        image_index++;
    }
    draw_self();
}
else
{
    draw_self();
}
if (false)
{
    draw_set_colour(c_white);
    draw_text_transformed(x,y,global.B_monster_count, 3,3,0);
}