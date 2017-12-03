#define battle_controller_INIT_SCR
// Play battle jams
audio_stop_sound(Reaching_the_sun_SND);
audio_play_sound(Rings_of_saturn_SND, 0, true);

// Boolean that ends the battlephase
end_battle = false;

// Calls the battle loading scripts
battle_loaded_INIT_SCR();

//Player Move speed
player_move_speed = 16;
battle_gravity_MAX = 32;
battle_gravity = battle_gravity_MAX;
battle_gravity_rate = 4;
global.battle_gravity = battle_gravity;
battle_jump_rate = 4;
battle_jump_MAX = 8;
battle_jump_duration = 20;
battle_jump_time = 0;
global.battle_jumped = false;
global.jumping_not_hit = true;
        
//battle exit points
left_exit = OW_grid_pos_to_pixels_SCR(0);
right_exit = OW_grid_pos_to_pixels_SCR(floor(room_height/128));

// Battle end start
battle_end = false;

// Player hit
global.player_hit = false;

global.b_region_colour_1 = c_ltgray;
global.b_region_colour_2 = c_dkgray;

battle_loaded = false;

#define battle_controller_STEP_SCR
// Deletes self if the battle is over
if ( end_battle) 
{
    instance_destroy();
}

// Calls the battle loading scripts
battle_loaded_STEP_SCR();

if (instance_exists(B_hero_OBJ))
{
    // Reset move speed
    global.B_player_move_x  = 0;
    global.B_player_move_y  = 0;
      
    
    
    // Battle controllers
    if (!global.mode_swap)
    {   
        if  (keyboard_check(vk_down))
        {
            if (!instance_exists(B_hero_sword_OBJ))
            {
                global.B_hero_crouch = true;
            }
        }
        else if (!instance_exists(B_hero_sword_OBJ))
        {
            global.B_hero_crouch = false;
        }
        if (!global.B_hero_crouch)
        {
            if (keyboard_check(vk_left))
            {
                global.B_player_move_x -= player_move_speed;
                if (!global.battle_jumped and
                    !instance_exists(B_hero_sword_OBJ)){global.B_hero_facing = "left";}
            } 
            else if  (keyboard_check(vk_right))
            {
                global.B_player_move_x += player_move_speed;
                if (!global.battle_jumped and
                    !instance_exists(B_hero_sword_OBJ)){global.B_hero_facing = "right";}
            }
            if  (keyboard_check_pressed(vk_space) and
                !global.battle_jumped )
            {
                player_jump_SCR();
                global.jumping_not_hit = true;
            }
        }
        if (keyboard_check_pressed(vk_enter) and
            !instance_exists(B_hero_sword_OBJ) and
            (global.jumping_not_hit or
            !global.battle_jumped or no_deticated_damage_spr))
        {
            instance_create(global.B_player.x, global.B_player.y, B_hero_sword_OBJ);
        }
    }
    
    
    // Jump duration and Gravity
    if (battle_jump_time <= battle_jump_duration
        and global.battle_jumped)
    {
        if ( battle_gravity > -battle_jump_MAX)
        {
            battle_gravity -= battle_jump_rate;
            if ( battle_gravity < -battle_jump_MAX)
            {
                battle_gravity = -battle_jump_MAX;
            }
        }
        global.battle_gravity = battle_gravity;
        battle_jump_time++;
    }
    else 
    {
        if ( battle_gravity < battle_gravity_MAX )
        {
            battle_gravity += battle_gravity_rate;
            if (battle_gravity > battle_gravity_MAX)
            {
                battle_gravity = battle_gravity_MAX;
            }
            global.battle_gravity = battle_gravity;
        }
    }
    
    
    if(!battle_end)
    {
        if (global.B_player.x <= left_exit or
              global.B_player.x >= right_exit)
        {
            battle_end_SCR();
            battle_end = true;
        }
        if (global.B_monster_count <= 0)
        {
            global.B_monster_count = 0;
            battle_end_SCR();
            battle_end = true;
        }
    }
    
    if (global.player_hit )
    {
        global.player_hit = false;
        if (global.B_player.hero_facing == "left")
        {
            //global.B_player.inertia = player_move_speed;
        }
        player_jump_SCR();
        global.jumping_not_hit = false;
    }

 }
    

#define battle_controller_DRAW_SCR
draw_set_color(c_white);
draw_rectangle_colour(0, 0, 
    room_width, window_get_height(),
    global.b_region_colour_1, global.b_region_colour_1,
    global.b_region_colour_2, global.b_region_colour_2,
    false);
if (instance_exists(B_hero_OBJ) and false)
{
    draw_set_color(c_white)
    draw_text_transformed(global.B_player.x, global.B_player.y-32, string(global.B_player.player_move_y), 3,3,0);
    draw_text_transformed(global.B_player.x, global.B_player.y, string(right_exit), 3,3,0);
    draw_text_transformed(global.B_player.x, global.B_player.y-64, global.battle_jumped, 3,3,0);
    draw_text_transformed(global.B_player.x, global.B_player.y-96, string(battle_gravity), 3,3,0);
    
}

#define battle_end_SCR

// End battle
view_visible[1] = false;
global.game_state = "overworld"
global.battle_controller.end_battle = true;
global.B_kill_all = true;

global.mode_swap = true;
//end battle jams
audio_stop_sound(Rings_of_saturn_SND);
audio_play_sound(Reaching_the_sun_SND, 0, true);

#define battle_controller_DRAW_GUI_SCR
sprite = B_heart_SPR;


length_of_sprite = sprite_get_width(sprite);
space_between_sprites = length_of_sprite * .25;

hp_box_offset = 0;
hp_box_x1 = -hp_box_offset;
hp_box_y1 = -hp_box_offset;
hp_box_x2 = space_between_sprites + 
    global.player_health_MAX * (space_between_sprites + length_of_sprite) + hp_box_offset;
hp_box_y2 = sprite_get_height(sprite) + 2 * space_between_sprites + hp_box_offset;
border = 5;

draw_set_alpha(0.85);
draw_set_colour(c_ltgray);
draw_roundrect(hp_box_x1 - border, hp_box_y1 - border, 
    hp_box_x2 + border, hp_box_y2 + border, false);

draw_set_alpha(1.0);
draw_set_colour(c_black);
for (i = 0; i < border; i ++)
{
    draw_roundrect(hp_box_x1 - border + i, hp_box_y1 - border + i, 
        hp_box_x2 + border - i, hp_box_y2 + border - i, true);
}

for (i = 0; i < global.player_health_MAX; i++)
{
    if (i < global.player_health){ draw_colour = c_white; }
    else { draw_colour = c_black; }
    draw_sprite_ext( sprite, 0, space_between_sprites + i * (space_between_sprites + length_of_sprite), 
        space_between_sprites, 1, 1, 0, draw_colour, 1 );
}

if (false)
{
    draw_set_color(c_white);
    draw_text_transformed(100,100,"test",3,3,0);
}

#define player_jump_SCR

battle_gravity = 0;
global.battle_gravity = battle_gravity;
global.battle_jumped = true;
battle_jump_time = 0;