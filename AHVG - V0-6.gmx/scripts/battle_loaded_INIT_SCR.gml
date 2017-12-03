#define battle_loaded_INIT_SCR
// Setting this varaible will cause the stage to load.
//  -   Done like this allows setting which battle file to load.
battle_start = false;

// This is the name of the file.
//  -   The .ini will be appended when the file tries to load
battle_ID = "test_battle_1";

// Player Start position. These values are the relative grid position on the map.
player_start_x = -1;
player_start_y = -1;

// Defualt room region
room_region = "error";

// Set monster counter to 0
global.B_monster_count = 0;

#define battle_loaded_STEP_SCR



// Load the battle map
if (battle_start)
{
    battle_load_file = battle_ID + ".ini";
    battle_map = 0;
    
    if file_exists(battle_load_file)
    {
        ini_open(battle_load_file);
        height = ini_read_real("room_data", "height", 0);
        room_region = ini_read_string( 'room_data', "map_type", "error" );
        if (room_region == "parent")
        {
            room_region = global.region;
        }
        if (room_region == "grey_void")
        {
            global.b_region_colour_1 = c_ltgray;
            global.b_region_colour_2 = c_dkgray;
        }
        else if (room_region == "forest")
        {
            global.b_region_colour_1 = c_green;
            global.b_region_colour_2 = c_olive;        
        }
        else if (room_region == "dirt")
        {
            global.b_region_colour_1 = c_olive;
            global.b_region_colour_2 = c_dkgray;        
        }
        else 
        {
            global.b_region_colour_1 = c_black;
            global.b_region_colour_2 = c_dkgray;        
        }
        
        
        for ( row_index = 0; row_index < height; row_index++)
        {
            row_string =  ini_read_string( 'room_data', "r" + string(row_index), "0" );
            row_data = split_string_SCR(row_string, ",");
            for (column_index = 0; column_index < array_length_1d(row_data); column_index++)
            {
                if (row_data[column_index] == "M1")
                {
                    spawn_x = OW_grid_pos_to_pixels_SCR(column_index);
                    spawn_y = OW_grid_pos_to_pixels_SCR(row_index);
                    new_tile = instance_create(spawn_x, spawn_y, B_slime_OBJ);                    
                }
                if (row_data[column_index] == "1")
                {
                    spawn_x = OW_grid_pos_to_pixels_SCR(column_index);
                    spawn_y = OW_grid_pos_to_pixels_SCR(row_index);
                    new_tile = instance_create(spawn_x, spawn_y, B_collision_OBJ);
                    if room_region == "grey_void"
                    {
                        new_tile.draw_colour = c_gray                        
                    }
                    else if room_region == "forest"
                    {
                        new_tile.draw_colour = c_green                        
                    }
                    else if room_region == "dirt"
                    {
                        new_tile.draw_colour = c_olive                       
                    }
                    else
                    {
                        new_tile.draw_colour = c_dkgray
                    }
                    battle_map[row_index, column_index] = row_data[column_index];
                }
            }
            //
            exit_boundry = abs(ini_read_real("room_data", "exit_boundry", 0));
            left_exit = OW_grid_pos_to_pixels_SCR(exit_boundry);
            right_exit = OW_grid_pos_to_pixels_SCR(array_length_2d(battle_map, height-1)-1 -exit_boundry);
        }
        
        start_string =  ini_read_string( 'room_data', "default_start", "2,3" );
        player_data = split_string_SCR(start_string, ",");
        spawn_x = OW_grid_pos_to_pixels_SCR(real(player_data[0]));
        spawn_y = OW_grid_pos_to_pixels_SCR(real(player_data[1])) + 39;
        //spawn_y = OW_grid_pos_to_pixels_SCR(real(player_data[1]));
        
        global.B_player = 
            instance_create(spawn_x, spawn_y, B_hero_OBJ);
        
        ini_close();
    }
    battle_start= false;
    
    battle_loaded = true;
    
}