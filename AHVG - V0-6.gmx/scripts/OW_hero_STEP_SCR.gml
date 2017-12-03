#define OW_hero_STEP_SCR
// Inheret self-distruction
OW_generic_STEP_SCR();


if !global.OW_kill_all
{
    if global.game_state == "overworld"
    {
        //Clean up varibles by making global values local values
        player_move_x = global.player_move_x;
        player_move_y = global.player_move_y;
        
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
        if (player_move_x == 0 and player_move_y == 0)
        {
            image_speed = 0;
        }
        else
        {
            image_speed = 0.125;
            if (random(1)< global.monster_encounter_rate)
            {
                // Monster encounter            
                global.game_state = "battle"
                global.B_monster_count = 0;
                global.battle_controller = 
                    instance_create(x,y, battle_controller_OBJ);
                rand_value = random(array_length_1d(global.encounter_list));
                encounter_index = 0;
                while ( encounter_index < rand_value)
                {
                    global.battle_controller.battle_ID = global.encounter_list[encounter_index];
                    encounter_index++; 
                }
                global.battle_controller.battle_start = true;
                view_visible[0] = false;
                view_visible[1] = true;
                global.mode_swap = true;
            }
        }
        
        //Special cases to check if the player is already as close to the wall as possible.
        //
        //  -   Will need to be fixed as once the program allows the user to walk within a pixel 
        //          of the walls
        //
        // horizontal
        move_sign = sign(player_move_x);
        if player_move_x != 0 and
            place_meeting(x + player_move_x, y, OW_collision_tile_OBJ)
        {
            player_move_x = 0;
        }
        // vertical
        move_sign = sign(player_move_y);
        if player_move_y != 0 and
            place_meeting(x , y + player_move_y, OW_collision_tile_OBJ)
        {
            player_move_y = 0;
        }
        
        
        //Player Move x !=0 y =0
        if ( player_move_x != 0 and player_move_y == 0 and 
            !place_meeting(x + player_move_x, y, OW_collision_tile_OBJ))
        {
            x += player_move_x;
        }
        
        //Player Move x =0 y !=0
        if ( player_move_x == 0 and player_move_y != 0 and 
            !place_meeting(x, y + player_move_y, OW_collision_tile_OBJ))
        {
            y += player_move_y;
        }
        
        //Player Move x !=0 y !=0
        if ( player_move_x != 0 and player_move_y != 0 and 
            !place_meeting(x + player_move_x, y + player_move_y, OW_collision_tile_OBJ) )
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
    

#define OW_hero_INIT_SCR
// Inheret self-distruction
OW_generic_INIT_SCR();

image_speed = 0;