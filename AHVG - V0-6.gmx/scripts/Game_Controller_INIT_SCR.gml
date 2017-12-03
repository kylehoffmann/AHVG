#define Game_Controller_INIT_SCR
// Play music
audio_stop_sound(Melies_Lune_SND);
audio_play_sound(Reaching_the_sun_SND, 0, true);

//Set player defaults
player_move_speed = 16;

// Set Player Health
//  -   Both should be initized to the same value but for now
//          having them different is best.
global.player_health = 3;
global.player_health_MAX = 3;

//battle facing
global.B_hero_facing = "right";
global.B_hero_crouch = false;

// The amount of distance a player should move per step.
global.player_move_x = 0;
global.player_move_y = 0;

// Object counter
global.OW_OBJs = 0;
global.OW_kill_all = false;

// Monster encounter rate
global.monster_encounter_rate = 0;

// In game menu setup
//
//  -   Define Menu
// Total menu items
total_in_game_menu_options = 0;
//  -   Define Menu Items
// Save
save_ID = total_in_game_menu_options;
option_name[total_in_game_menu_options++] = "Save";
// Options
//options_ID = total_in_game_menu_options;
//option_name[total_in_game_menu_options++] = "Quit";
// Quit to Tile
quit_title_ID = total_in_game_menu_options;
option_name[total_in_game_menu_options++] = "Quit to Title";
// Quit Game
quit_game_ID = total_in_game_menu_options;
option_name[total_in_game_menu_options++] = "Quit Game";
//  -   Draw Variables 
// Box Coordiates
menu_box_x1 = 600;
menu_box_x2 = menu_box_x1 + 700;
menu_box_y1 = 500;
menu_box_y2 = menu_box_y1 + 300;
border = 5;
// Scale
menu_text_scale = 6;
// menu option
in_game_menu_option = 0;
// stores if the game was just saved
saved = false;

//Menu selection fade
selector_fade = 0;
selector_fade_MAX = 120;
hold_percent = .20;

// Initlaize global variables
for (i = 0; i < num_of_NPC_DATA_slots; i++)
{
    global.NPC_DATA[i] = 0;
}


// The amount of distance a player should move per step.
global.B_player_move_x = 0;
global.B_player_move_y = 0;


// Object counter
global.B_OBJs = 0;
global.B_kill_all = false;
global.B_monster_count = 0;

// Mode swap
//  -   Used to make the player release all keys before anything will happen
global.mode_swap = false;

#define Game_Controller_STEP_SCR
// Reset player movement for this step
global.player_move_x = 0;
global.player_move_y = 0;

if global.B_kill_all and global.B_OBJs == 0
{
    view_visible[0] = true;
    global.B_kill_all = false;
}

// This quits the game when enter is pressed
// -    Used for testing.
//      Should be commented out or removed after testing.
if (keyboard_check_pressed(vk_enter))
{
    //game_end();
}

if !global.mode_swap
{
    if global.game_state == "overworld"
    {
        if keyboard_check_pressed(vk_escape)
        {
            global.game_state = "overworld_menu"
        }
        
        
        if (keyboard_check_pressed(vk_f12) and false)
        {
            global.game_state = "battle"
            global.B_monster_count = 0;
            global.battle_controller = 
                instance_create(x,y, battle_controller_OBJ);
            global.battle_controller.battle_start = true;
            view_visible[0] = false;
            view_visible[1] = true; 
            //global.B_player = 
            //    instance_create(100,100, B_hero_OBJ);
        }
        
        if (keyboard_check(vk_left))
        {
            global.player_move_x -= player_move_speed;
        } 
        else if  (keyboard_check(vk_right))
        {
            global.player_move_x += player_move_speed;
        }
        
        if (keyboard_check(vk_down))
        {
            global.player_move_y += player_move_speed;
        } 
        else if  (keyboard_check(vk_up))
        {
            global.player_move_y -= player_move_speed;
        } 
        
    }
    else if global.game_state == "overworld_menu"
    {
        
        // Check the keyboard to see if the user is moving down the list of menu options.
        //
        // -    For now the player must press the key every time to move down the menu options.
        //
        //  -   The menu cycles so it will return to the top if the key is pressed again 
        //          at the bottom of the list.
        if (keyboard_check_pressed(vk_down))
        {
            in_game_menu_option ++;
            if ( in_game_menu_option == total_in_game_menu_options)
            {
                in_game_menu_option = 0;
            }
        }
        
        // Check the keyboard to see if the user is moving up the list of menu options.
        //
        // -    For now the player must press the key every time to move up the menu options.
        //
        //  -   The menu cycles so it will return to the bottom if the key is pressed again 
        //          at the top of the list.
        if (keyboard_check_pressed(vk_up))
        {
            in_game_menu_option --;
            if ( in_game_menu_option < 0)
            {
                in_game_menu_option += total_in_game_menu_options;
            }
        }
        
        // Process user selection
        //
        //
        if (keyboard_check_pressed(vk_enter))
        {
                    
            // Code for loading a save file
            if (in_game_menu_option == save_ID)
            {
                ini_open("save.ini");
                ini_write_real("Core Data", "Collectum_Score", global.collectum_score);
                ini_write_string("Core Data", "game_state", "overworld");
                
                ini_close();
                
                save_global_varibles_SCR("save.ini");
                
                saved = true;
            }
            
            // Code for opening the options menu.
            //  -   Unimplemented
            
            // Code for quitting game
            if (in_game_menu_option == quit_game_ID)
            {
                game_end();
            }
            
            //Code for quitting to title
            if (in_game_menu_option == quit_title_ID)
            {
                audio_stop_sound(Reaching_the_sun_SND);
                global.room_loaded.die = true;
                room_goto(Title_Screen_ID);
                instance_destroy();
            }
        } 
        
        
        // Selector Fade
        selector_fade++;
        if selector_fade == selector_fade_MAX
        {
            selector_fade = 0;
        }
        
        // Check if menu escape key was pressed or the game was just saved.
        if keyboard_check_pressed(vk_escape) or saved
        {
            global.game_state = "overworld"
            in_game_menu_option = 0;
            saved = false;
            selector_fade = 0;
        }
        
    }
    else if global.game_state == "battle"
    {
        if ((keyboard_check_pressed(vk_escape) or
            keyboard_check_pressed(vk_f12)) and false)
        {
            battle_end_SCR();
        }
    
    }
}
else
{
    if keyboard_check(vk_nokey)
    {
        global.mode_swap = false;
    }
}

// Player runs our of health
if (global.player_health <= 0)
{
    global.room_loaded.die = true;
    room_goto(game_over_ROOM);
    audio_stop_sound(Rings_of_saturn_SND);
    audio_stop_sound(Reaching_the_sun_SND);
    audio_play_sound(Melies_Lune_SND, 0, true);
    game_over_controller = instance_create(x, y, game_over_OBJ);
    instance_destroy();
}

if (global.NPC_DATA[0] = 1)
{
    global.room_loaded.die = true;
    room_goto(game_over_ROOM);
    audio_stop_sound(Rings_of_saturn_SND);
    audio_stop_sound(Reaching_the_sun_SND);
    audio_play_sound(Melies_Lune_SND, 0, true);
    game_over_controller = instance_create(x, y, game_over_OBJ);
    game_over_controller.game_state = "you_win";
    instance_destroy();    
}


#define Game_Controller_DRAW_GUI_SCR
if global.game_state == "overworld_menu"
{
    draw_set_alpha(0.85);
    draw_set_colour(c_ltgray);
    draw_roundrect(menu_box_x1 - border, menu_box_y1 - border, 
        menu_box_x2 + border, menu_box_y2 + border, false);
    
    draw_set_alpha(1.0);
    draw_set_colour(c_black);
    for (i = 0; i < border; i ++)
    {
        draw_roundrect(menu_box_x1 - border + i, menu_box_y1 - border + i, 
            menu_box_x2 + border - i, menu_box_y2 + border - i, true);
    }
    
    for (i = 0; i < total_in_game_menu_options; i++)
    {
        draw_set_colour(c_black);
        if i == in_game_menu_option 
        {
            draw_set_colour(c_dkgray);
            draw_text_transformed(menu_box_x1 + 24, menu_box_y1 + 
                (menu_text_scale * 16) * i, option_name[i], menu_text_scale, 
                menu_text_scale, 0);
            fade_percent = 0.7;
            hold_frames = selector_fade_MAX * hold_percent;
            if (selector_fade < selector_fade_MAX / 2 - hold_frames)
            {
                alpha_fade = (1 - fade_percent) + 
                    fade_percent * ( selector_fade / selector_fade_MAX * 2 +
                    selector_fade / selector_fade_MAX * 2 
                    * hold_frames / selector_fade_MAX * 2);
            }
            else if (selector_fade < selector_fade_MAX/ 2 )
            {
                alpha_fade = 1;
            }
            else
            {
                alpha_fade = (1 - fade_percent) + 
                    fade_percent * (selector_fade_MAX - selector_fade) / selector_fade_MAX * 2;
            
            }
            draw_set_alpha(alpha_fade);
            draw_set_colour(c_yellow);
        }
        draw_text_transformed(menu_box_x1 + 24, menu_box_y1 + 
            (menu_text_scale * 16) * i, option_name[i], menu_text_scale, 
            menu_text_scale, 0);
        draw_set_alpha(1.0);
    }
}
if (false)
{
    draw_set_colour(c_white);
    draw_text_transformed(100,100,global.monster_encounter_rate, 3,3,0);
}