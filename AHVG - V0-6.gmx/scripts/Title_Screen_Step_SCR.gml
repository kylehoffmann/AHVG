#define Title_Screen_Step_SCR

// Check the keyboard to see if the user is moving down the list of menu options.
//
// -    For now the player must press the key every time to move down the menu options.
//
//  -   The menu cycles so it will return to the top if the key is pressed again 
//          at the bottom of the list.
if (keyboard_check_pressed(vk_down))
{
    menu_option ++;
    if ( menu_option == total_menu_options)
    {
        menu_option = 0;
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
    menu_option --;
    if ( menu_option < 0)
    {
        menu_option += total_menu_options;
    }
}


// Process user selection
//
//
if (keyboard_check_pressed(vk_enter))
{
    // Code for beginning the game
    if (menu_option == start_ID)
    {
        // Spawn a game controller
        //  -   This is effectively the main game loop.
        instance_create(0, 0, Game_Controller_OBJ);
                
        // Load the first room of the game based on the room id defined in global marcos
        //  -   Done to make changing the first room easy to find to edit.
        room_goto(First_Game_ROOM_ID);
        
        // Set game state
        global.game_state = first_ROOM_game_state;
        
        instance_create(0, 0, room_loader_OBJ);
        
        
        // Spawns the controller for the test game if the First_Game_ROOM_ID is a test room's id
        if (First_Game_ROOM_ID == 2)
        {
            instance_create(0, 0, ts1_R_Controller_OBJ);
        }
    }
    
    // Code for loading a save file
    if (menu_option == continue_ID and save_file_exists)
    {
    
        load_game_SCR();
    }
    
    // Code for opening the options menu.
    //  -   Unimplemented
    
    // Code for quitting
    if (menu_option == quit_ID)
    {
        game_end();
    }
}

// Cycle colour values
title_screen_colour_cycle++
if title_screen_colour_cycle == title_screen_colour_cycle_MAX
{
    title_screen_colour_cycle = 0;
}

// Selector Fade
selector_fade++;
if selector_fade == selector_fade_MAX
{
    selector_fade = 0;
}

#define Title_Screen_Draw_SCR
Title_DRAW_SCR();
Menu_Options_DRAW_SCR();

#define Title_DRAW_SCR
//Draw Cheap background
top_colour_1[0] = 45; 
top_colour_1[1] = 187; 
top_colour_1[2] = 239; 
top_colour_2[0] = 51;
top_colour_2[1] = 224; 
top_colour_2[2] = 89; 
bottom_colour_1[0] = 110; 
bottom_colour_1[1] = 14; 
bottom_colour_1[2] = 140; 
bottom_colour_2[0] = 10;
bottom_colour_2[1] = 35; 
bottom_colour_2[2] = 175; 
if ( title_screen_colour_cycle < title_screen_colour_cycle_MAX/2)
{
    mod_2 = title_screen_colour_cycle / title_screen_colour_cycle_MAX * 2;
    mod_1 = 1 - mod_2;
    for (i = 0; i < 3; i++)
    {
        top_colour[i] = top_colour_1[i] * mod_1 + top_colour_2[i] * mod_2;
        bottom_colour[i] = bottom_colour_1[i] * mod_1 + bottom_colour_2[i] * mod_2;
    }
}
else
{
    mod_2 = ( title_screen_colour_cycle_MAX - title_screen_colour_cycle ) / title_screen_colour_cycle_MAX * 2;
    mod_1 = 1 - mod_2;
    for (i = 0; i < 3; i++)
    {
        top_colour[i] = top_colour_1[i] * mod_1 + top_colour_2[i] * mod_2; 
        bottom_colour[i] = bottom_colour_1[i] * mod_1 + bottom_colour_2[i] * mod_2;   
    }
}
top_colour = make_color_rgb(top_colour[0], top_colour[1], top_colour[2]);
bottom_colour = make_color_rgb(bottom_colour[0], bottom_colour[1], bottom_colour[2]);
draw_rectangle_color(0, 0, window_get_width(), window_get_height(),
    top_colour, top_colour, bottom_colour, bottom_colour, false);

// Set Title colour
draw_set_colour(c_white);

// Print title of game.
//  - The name of the game can be changed in the "All configurations" Marcos
//      Adjust "Name_of_Game" to the new title.
draw_text_transformed(400, 250, Name_of_Game, 10, 10, 0);

#define Menu_Options_DRAW_SCR
// Set values for where to start drawing the menu, the scale of text and
//  the space between options
inital_x = 750;
inital_y = 600;
scale = 4;
space_between_lines = scale * 17.5;

draw_set_alpha(0.25);
draw_set_colour(c_white);
draw_roundrect(inital_x - 30, inital_y - 5, inital_x + 360, inital_y  + 5 + 70 * total_menu_options, false);
draw_set_alpha(1.0);
draw_set_colour(c_black);
for (i = 0; i < 4; i++)
{
    draw_roundrect(inital_x - 30 + i, inital_y + i - 5, inital_x + 360 - i, inital_y + 5  + 70 * total_menu_options - i, true);    
}

// an array that decides which menu option should be selected
//  -   This array needs to the know the total number of menu options.
//          This must be set in the Menu_Controller_OBJ
for (current_menu_item = 0; current_menu_item < total_menu_options; current_menu_item++)
{
    if (menu_option == current_menu_item)
    {
        option_chosen =  true;
    } 
    else
    {
        option_chosen= false;
    }
    
    Menu_Option_DRAW_SCR(inital_x, inital_y + space_between_lines * current_menu_item, 
    scale, option_name[current_menu_item], option_chosen, menu_option);
}


#define Menu_Option_DRAW_SCR
option_x = argument0;
option_y = argument1;
font_scale = argument2;
text = argument3;
is_current_option = argument4;
current_option = argument5;

move_offset_x = 20 * font_scale;
move_correct_x = move_offset_x;

move_offset_y = 5 * font_scale;
move_correct_y = move_offset_y;

// Choose a colour to draw the text in
if (is_current_option)
{
    /*draw_set_alpha(0.25);
    draw_set_colour(c_white);
    draw_roundrect(option_x - 20, option_y, option_x + 310, option_y + 64, false);
    draw_set_alpha(1.0);
    draw_set_colour(c_black);
    for (i = 0; i < 4; i++)
    {
        draw_roundrect(option_x - 20 + i, option_y + i, option_x + 310 - i, option_y + 64 - i, true);    
    }*/
    
    if (current_option == continue_ID and not save_file_exists)
    {
        draw_set_colour(c_gray);
    }
    else
    {
        fade_percent = 0.7;
        scale_effect = .2;
        hold_frames = selector_fade_MAX * hold_percent;
        scale_mod = 1;
        if (selector_fade < selector_fade_MAX)
        {
            scale_mod = (1 + scale_effect * ( selector_fade / selector_fade_MAX * 2 +
                selector_fade / selector_fade_MAX * 2 
                * hold_frames / selector_fade_MAX * 2) );
        }
        if (selector_fade < selector_fade_MAX / 2 - hold_frames)
        {
            alpha_fade = (1 - fade_percent) + 
                fade_percent * ( selector_fade / selector_fade_MAX * 2 +
                selector_fade / selector_fade_MAX * 2 
                * hold_frames / selector_fade_MAX * 2);
            //font_scale *= (1 + scale_effect * ( selector_fade / selector_fade_MAX * 2 +
            //    selector_fade / selector_fade_MAX * 2 
            //    * hold_frames / selector_fade_MAX * 2) );
        }
        else if (selector_fade < selector_fade_MAX/ 2 )
        {
            alpha_fade = 1;
            //scale_mod = 1 + scale_effect;
            
        }
        else
        {
            alpha_fade = (1 - fade_percent) + 
                fade_percent * (selector_fade_MAX - selector_fade) / selector_fade_MAX * 2;
            //font_scale *= (1 + scale_effect * (selector_fade_MAX - selector_fade) / selector_fade_MAX * 2 );
            scale_mod = (1 + scale_effect * (selector_fade_MAX - selector_fade) / selector_fade_MAX * 2 );
        
        }
        move_correct_x *= scale_mod;
        move_correct_y *= scale_mod;
        font_scale *= scale_mod;
        draw_set_colour(c_gray);
        draw_text_transformed(option_x + move_offset_x - move_correct_x, option_y + move_offset_y - move_correct_y, 
            text, font_scale, font_scale, 0);
        draw_set_alpha(alpha_fade);
        draw_set_colour(c_yellow);
    }
}
else
{
    draw_set_colour(c_black);
}

// Draw the menu option
draw_text_transformed(option_x + move_offset_x - move_correct_x, option_y + move_offset_y - move_correct_y, 
    text, font_scale, font_scale, 0);
draw_set_alpha(1);

#define Title_Screen_INIT_SCR
// Play music
audio_play_sound(Melies_Lune_SND, 0, true);

menu_option = 0;

// The total number of menu items. 
// -    This is used to make sure the menu selector cant get out of bounds.
//          The number of items is incremented by the total_menu_options++ 
//          when a new item is registered.
total_menu_options = 0;

// Defining menu options
// 
// Start with name of options
//
//  -   The first option is start game. 
//          Register the event ID and register the name as a menu item.
start_ID = total_menu_options;
option_name[total_menu_options++] = "Start";

//  -   The second menu item allows a player to load a saved game.
//          Register the event ID and register the name as a menu item.
continue_ID = total_menu_options;
option_name[total_menu_options++] = "Continue";

//  -   Initializes the option menu menu option.
//          Register the event ID and register the name as a menu item.
//          Currently unused.
//options_ID = total_menu_options;
//option_name[total_menu_options++] = "Options - Broken";

//  -   Initalizes the quit game option
//          Register the event ID and register the name as a menu item.
quit_ID = total_menu_options;
option_name[total_menu_options++] = "Quit";

// Look for a save file
if file_exists("save.ini")
{
    save_file_exists = true;
}
else
{
    save_file_exists = false;
}

// Core data initalize
// Score
global.collectum_score = 0;

//Inital Game State
global.game_state = "title"

//Initalize player
global.player = ""

title_screen_colour_cycle = 0;
title_screen_colour_cycle_MAX = 600;



//Menu selection fade
selector_fade = 0;
selector_fade_MAX = 120;
hold_percent = .20;