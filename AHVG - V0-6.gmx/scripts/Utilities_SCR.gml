#define Utilities_SCR



#define OW_grid_pos_to_pixels_SCR
grid_x_or_y = argument0;

return 64 + 128 * grid_x_or_y;

#define load_global_varibles_SCR
ini_name = argument0;

ini_open(ini_name);

global.room_loaded.current_room_ID = ini_read_string("Core Data", "current_room_ID", "test_room_1");
global.room_loaded.map_to_load = (global.room_loaded.current_room_ID + ".ini");
global.room_loaded.player_start_x = ini_read_real("Core Data", "player_start_x", global.collectum_score);
global.room_loaded.player_start_y = ini_read_real("Core Data", "player_start_y", global.collectum_score);
global.room_loaded.exact_player_values = true;
global.player_health = ini_read_real("Core Data", "player_health", 1);
global.player_health_MAX = ini_read_real("Core Data", "player_health_MAX", 1);

for (i = 0; i < num_of_NPC_DATA_slots; i++)
{
    global.NPC_DATA[i] = ini_read_real("Core Data", "npc_data" + string(i), 0);
}

ini_close();


#define save_global_varibles_SCR
ini_name = argument0;

ini_open(ini_name);

ini_write_string("Core Data", "current_room_ID", global.room_loaded.current_room_ID);
ini_write_real("Core Data", "room ID", room);
ini_write_real("Core Data", "player_start_x", global.player.x);
ini_write_real("Core Data", "player_start_y", global.player.y); 
ini_write_real("Core Data", "player_health", global.player_health);
ini_write_real("Core Data", "player_health_MAX", global.player_health_MAX);

for (i = 0; i < num_of_NPC_DATA_slots; i++)
{
    ini_write_real("Core Data", "npc_data" + string(i), global.NPC_DATA[i]);
}

ini_close();


#define split_string_SCR
string_to_split = argument0;
character_to_split_on = argument1;

return_array = 0;

return_array[0] = "string_to_split";

current_array_index = 0;

split_string_SCR_i = 1;
parse_string = "";
while ( split_string_SCR_i <= string_length(string_to_split) )
{
    current_char = string_char_at(string_to_split, split_string_SCR_i);
    if (current_char == ",")
    {
        return_array[current_array_index++] = parse_string;
        parse_string = "";
    }
    else
    {
        parse_string += current_char;
    }
    split_string_SCR_i++;
}
return_array[current_array_index++] = parse_string;

return return_array;


#define player_add_hp_SCR
health_increase = argument0;

global.player_health += health_increase; 
if (global.player_health > global.player_health_MAX)
{
    global.player_health = global.player_health_MAX;
}

#define load_game_SCR
// Spawn a game controller
//  -   This is effectively the main game loop.
instance_create(0, 0, Game_Controller_OBJ);

// Read save file
ini_open("save.ini");
global.collectum_score = ini_read_real("Core Data", "Collectum_Score", global.collectum_score);
// Set game state
global.game_state = ini_read_string("Core Data", "game_state", first_ROOM_game_state);
load_ROOM_ID = ini_read_string("Core Data", "room ID", First_Game_ROOM_ID);



// Close ini
ini_close();

instance_create(0, 0, room_loader_OBJ);        
load_global_varibles_SCR("save.ini");

        
        
room_goto(load_ROOM_ID);

#define set_region_colour
set_room_region = argument0;

// Set colour defualts, Just incase.
global.room_region_colour_1 = c_black;
global.room_region_colour_2 = c_dkgray;   
global.room_warp_colour = c_gray; 

if (set_room_region == "grey_void")
{
    global.room_region_colour_1 = c_ltgray;
    global.room_region_colour_2 = c_dkgray;
    global.room_warp_colour = c_silver;
}
else if (set_room_region == "forest")
{
    global.room_region_colour_1 = c_green;
    global.room_region_colour_2 = c_olive;  
    global.room_warp_colour = c_lime;      
}
else if (set_room_region == "house")
{
    global.room_region_colour_1 = c_olive;
    global.room_region_colour_2 = c_red;  
    global.room_warp_colour = c_yellow;      
}
else if (set_room_region == "dirt")
{
    global.room_region_colour_1 = c_olive;
    global.room_region_colour_2 = c_dkgray; 
    global.room_warp_colour = c_orange;            
}
else 
{
    global.room_region_colour_1 = c_black;
    global.room_region_colour_2 = c_dkgray;   
    global.room_warp_colour = c_gray;             
}