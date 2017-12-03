#define ts1_R_Controller_INIT_SCR
text_scale = 4;
text_colour = c_white;

// Game state
global.game_state = "game"

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
// Quit
quit_ID = total_in_game_menu_options;
option_name[total_in_game_menu_options++] = "Quit";
//  -   Draw Variables 
// Box Coordiates
menu_box_x1 = 800;
menu_box_x2 = menu_box_x1 + 300;
menu_box_y1 = 500;
menu_box_y2 = menu_box_y1 + 200;
// Scale
menu_text_scale = 6;
// menu option
in_game_menu_option = 0;

start_text = instance_create(200, 300, test_background_text_OBJ);
start_text.text = "Welcome";
start_text.controller_ID = self;

scroll_x = 0;

collectum_score = 0;

ground_start = 1000;

player_default_y = ground_start - 40;
player = instance_create(148, player_default_y, test_hero_OBJ);
walking_startup = 0;
player_jump_max = 8;
walking = false;
lean_right = true;
lean_cycle = 0;
lean_neutral = 5;
lean_extreme = 5;
run_multiplier = 2;
active_run_mod = 1;
run = false;

for (i = 0; i < 34; i++)
{
    row = 0;
    floor_cube[i, row] = instance_create(31 + 64 * i, ground_start + 64 * row, test_brick_OBJ);
    floor_cube[i, row++].controller_ID = self;
    floor_cube[i, row] = instance_create(31 + 64 * i, ground_start + 64 * row, test_brick_OBJ);
    floor_cube[i, row++].controller_ID = self;
    floor_cube[i, row] = instance_create(31 + 64 * i, ground_start + 64 * row, test_brick_OBJ);
    floor_cube[i, row++].controller_ID = self;
    floor_cube[i, row] = instance_create(31 + 64 * i, ground_start + 64 * row, test_brick_OBJ);
    floor_cube[i, row++].controller_ID = self;
}

spawn_reset = 0;


#define ts1_R_Controller_STEP_SCR
if global.game_state == "game"
{
    if keyboard_check_pressed(vk_escape)
    {
        global.game_state = "menu"
    }
    
    if keyboard_check(vk_right)
    {
        scroll_x = 6 * active_run_mod;
        walking = true;
        if ( walking_startup == 4)
        {
            if (lean_cycle == lean_neutral + lean_extreme) 
            {
                lean_cycle = 0;
                if (lean_right) lean_right = false;
                else lean_right = true;
            }
            lean_cycle++;
        }
    }
    else
    {
        scroll_x = 0;
        walking = false;
        lean_cycle = 0;
        if (lean_right) lean_right = false;
        else lean_right = true;
    }
    
    // Implement Run
    if keyboard_check(vk_space)
    {        
        run = true;
        active_run_mod = run_multiplier;
    }
    else
    {
        run = false;
        active_run_mod = 1;
    }
    
    if (walking == false and walking_startup == 4)
    {
        walking_startup = 0;
    }
    
    if ( walking == true or walking_startup > 0)
    {
        if (walking_startup < 4) walking_startup++;
    }
    
    // Spawn items
    //
    // Reduce by distance covered
    if ( walking == true ) spawn_reset -= active_run_mod;
    
    // Reset delay passed, spawn new items. 
    if (spawn_reset <= 0)
    {
        spawn_reset = ceil(random(25)) + 25;
        new_collectum = instance_create(2000, ground_start - 64, test_collectum_OBJ);
        new_collectum.controller_ID = self;
    }
}
else
{
    
    // Close menu
    if keyboard_check_pressed(vk_escape)
    {
        global.game_state = "game"
    }

    // Stop the game from running
    scroll_x = 0;
    
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
            ini_write_real("Core Data", "room ID", room);
            ini_close();
        }
        
        // Code for opening the options menu.
        //  -   Unimplemented
        
        // Code for quitting
        if (in_game_menu_option == quit_ID)
        {
            game_end();
        }
    }
}  

#define ts1_R_Controller_Draw_SCR
draw_set_colour(c_yellow);

collectum_counter_x_start = 1800;
collectum_counter_y_start = 24;
text_scale = 3;

number_offset = floor(log10(global.collectum_score));

draw_sprite_ext( collectum_test_SPR, 0, collectum_counter_x_start + 70 , 
    collectum_counter_y_start + 16, 2, 2, 0, c_white, 1 );

draw_text_transformed(collectum_counter_x_start - 11 * text_scale * number_offset,
 collectum_counter_y_start, global.collectum_score, text_scale, text_scale, 0);

if ( walking_startup == 1)
{
    player.y -= player_jump_max;
}
else if (walking_startup == 3)
{
    player.y += player_jump_max;
}

if ( lean_cycle > lean_neutral) 
{
    if (lean_right) lean_mod = -1;
    else lean_mod = 1; 
    player.image_angle = 20 * lean_mod;
}
else player.image_angle = 0;

// Draw menu
if global.game_state == "menu"
{
    draw_set_colour(c_blue);
    draw_roundrect(menu_box_x1, menu_box_y1, menu_box_x2, menu_box_y2, false);
    for (i = 0; i < total_in_game_menu_options; i++)
    {
        draw_set_colour(c_black);
        if i == in_game_menu_option draw_set_colour(c_white);
        draw_text_transformed(menu_box_x1 + 24, menu_box_y1 + (menu_text_scale * 16) * i, option_name[i], menu_text_scale, menu_text_scale, 0);
    }
}