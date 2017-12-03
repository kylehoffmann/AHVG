#define game_over_INIT_SCR
menu_option = 0;

// The total number of menu items. 
// -    This is used to make sure the menu selector cant get out of bounds.
//          The number of items is incremented by the total_menu_options++ 
//          when a new item is registered.
total_menu_options = 0;

// Defining menu options
// 
// Start with name of options
//  -   The first menu item allows a player to load a saved game.
//          Register the event ID and register the name as a menu item.
continue_ID = total_menu_options;
option_name[total_menu_options++] = "Continue";

// Quit to Tile
quit_title_ID = total_menu_options;
option_name[total_menu_options++] = "Quit to Title";

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
game_state = "game_over";

//Initalize player
global.player = ""

title_screen_colour_cycle = 0;
title_screen_colour_cycle_MAX = 600;


//Menu selection fade
selector_fade = 0;
selector_fade_MAX = 120;
hold_percent = .20;



#define game_over_STEP_SCR
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
    // Code for loading a save file
    if (menu_option == continue_ID and save_file_exists)
    {
    
        load_game_SCR();
        instance_destroy();
    }
    
    //Code for quitting to title
    if (menu_option == quit_title_ID)
    {
        audio_stop_sound(Reaching_the_sun_SND);
        room_goto(Title_Screen_ID);
        instance_destroy();
    }
        
    // Code for quitting
    if (menu_option == quit_ID)
    {
        game_end();
    }
}


// Selector Fade
selector_fade++;
if selector_fade == selector_fade_MAX
{
    selector_fade = 0;
}


#define game_over_DRAW_SCR
// Set values for where to start drawing the menu, the scale of text and
//  the space between options
inital_x = 700;
inital_y = 600;
scale = 4;
space_between_lines = scale * 17.5;


// Set Title colour
draw_set_colour(c_white);

// Print title of game.
//  - The name of the game can be changed in the "All configurations" Marcos
//      Adjust "Name_of_Game" to the new title.
if (game_state == "game_over")
{
    draw_text_transformed(500, 250, "GAME OVER", 10, 10, 0);
}
else
{
    draw_text_transformed(500, 150, "You Win!", 10, 10, 0);
    draw_text_transformed(300, 300, "Game By Kyle Hoffmann", 6, 6, 0);
    draw_text_transformed(200, 400, "Music composed by Oscar Owl", 6, 6, 0);
}

draw_set_alpha(0.25);
draw_set_colour(c_white);
draw_roundrect(inital_x - 30, inital_y - 5, inital_x + 500, inital_y  + 5 + 70 * total_menu_options, false);
draw_set_alpha(1.0);
draw_set_colour(c_black);
for (i = 0; i < 4; i++)
{
    draw_roundrect(inital_x - 30 + i, inital_y + i - 5, inital_x + 500 - i, inital_y + 5  + 70 * total_menu_options - i, true);    
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
