#define room_loaded_INIT_SCR
new_map = true;

exact_player_values = false;

player_start_x = -1;
player_start_y = -1;


current_room_ID = first_room_ini;
map_to_load = current_room_ID + ".ini";

global.room_loaded = self;

die = false;


#define room_loaded_STEP_SCR
if global.OW_kill_all and global.OW_OBJs == 0
{
    new_map = true;
    global.OW_kill_all = false;
}

if new_map 
{
        
    map = 0;
    if file_exists(map_to_load)
    {
        ini_open(map_to_load);
        height = ini_read_real("room_data", "height", 0);
        room_region = ini_read_string( 'room_data', "map_type", "error" );
        global.region = room_region;
        set_region_colour(global.region);
        //i = 4;
        for ( i = 0; i < height; i++)
        {
            row_string =  ini_read_string( 'room_data', "r" + string(i), "0" );
            j = 1;
            k = 0;
            parse_string = "";
            while (j <= string_length(row_string) )
            {   
                current_char = string_char_at(row_string, j);
                if (current_char == ",")
                {
                    if (string_copy(parse_string, 0, 1) == "H")
                    {
                        spawn_x = OW_grid_pos_to_pixels_SCR(k)
                        spawn_y = OW_grid_pos_to_pixels_SCR(i)
                        instance_create(spawn_x, spawn_y, OW_health_pickup_OBJ);
                        if parse_string == "H1" {parse_string = "G1";}
                        if parse_string == "H2" {parse_string = "G2";}
                        else {parse_string = "G1";}
                    }
                    if (string_copy(parse_string, 0, 3) == "NPC")
                    {
                        spawn_x = OW_grid_pos_to_pixels_SCR(k)
                        spawn_y = OW_grid_pos_to_pixels_SCR(i)
                        object_set_sprite( OW_NPC_OBJ, OW_NPCs_SPR );
                        new_NPC = instance_create(spawn_x, spawn_y, OW_NPC_OBJ);
                        NPC_data = split_string_SCR(ini_read_string( 'room_data', parse_string, "G1" ), ",");
                        index_in_NPC_data = 0;
                        parse_string = NPC_data[index_in_NPC_data++];
                        npc_speech_index = 0;
                        while(index_in_NPC_data < array_length_1d(NPC_data) - 5)
                        {
                            for (index_in_NPC_data_sub_index = 0; 
                                index_in_NPC_data_sub_index < 6; 
                                index_in_NPC_data_sub_index++)
                            {
                                if NPC_data[index_in_NPC_data] == "true" or 
                                    NPC_data[index_in_NPC_data] == "false" or 
                                    index_in_NPC_data_sub_index == 2
                                {
                                    new_NPC.dialogue_tree[npc_speech_index, 
                                        index_in_NPC_data_sub_index] = 
                                        NPC_data[index_in_NPC_data++];
                                }
                                else
                                {
                                    new_NPC_data_read = real(NPC_data[index_in_NPC_data]);
                                    new_NPC.dialogue_tree[npc_speech_index, 
                                        index_in_NPC_data_sub_index] = 
                                        new_NPC_data_read;
                                    index_in_NPC_data++;                               
                                }
                            }
                            
                            npc_speech_index++;
                        }
                        //parse_string = ini_read_string( 'room_data', parse_string, "G1" );
                    }
                    if string_char_at(parse_string, 0) == "T"
                    {
                        spawn_x = OW_grid_pos_to_pixels_SCR(k)
                        spawn_y = OW_grid_pos_to_pixels_SCR(i)
                        new_warp = instance_create(spawn_x, spawn_y, OW_load_zone_OBJ);
                        start_string =  ini_read_string( 'room_data', parse_string, "2,3" );
                        l = 1;
                        data_segement = 0;
                        parse_string = "";
                        while ( l <= string_length(start_string) )
                        {
                            current_char = string_char_at(start_string, l);
                            if (current_char == ",")
                            {
                                if data_segement == 0
                                {
                                    new_warp.load_ROOM_ID = parse_string;
                                    data_segement++;
                                }else{
                                    new_warp.player_x = real(parse_string);
                                }
                                parse_string = "";
                            }
                            else
                            {
                                parse_string += current_char;
                            }
                            l++;
                        }
                        new_warp.player_y = real(parse_string);
                        new_warp.exact_player_values = false;
                        
                        // Set the warp to the colour defined by the region                        
                        new_warp.draw_colour = global.room_warp_colour;
                        
                        map[i, k] = parse_string;
                    }
                    else if string_char_at(parse_string, 0) == "G"
                    {
                        spawn_x = OW_grid_pos_to_pixels_SCR(k)
                        spawn_y = OW_grid_pos_to_pixels_SCR(i)
                        new_ground = instance_create(spawn_x, spawn_y, OW_ground_OBJ);
                        
                        new_ground.draw_colour = global.room_region_colour_1
                        if (parse_string == "G1")
                        {
                            new_ground.draw_colour = global.room_region_colour_1                                
                        }           
                        else if (parse_string == "G2")
                        {
                            new_ground.draw_colour = global.room_region_colour_2                                 
                        } 
                        map[i, k] = parse_string;
                    }
                    else
                    {
                        map[i, k] = real(parse_string);
                    }
                    //show_message(parse_string);
                    parse_string = "";
                    k++;
                }
                else
                {
                    parse_string += current_char;
                }
                j++;
            }
        }
        //show_message(row_string);
        if player_start_x < 0 or player_start_y < 0
        {
            start_string =  ini_read_string( 'room_data', "default_start", "2,3" );
            i = 1;
            parse_string = "";
            while ( i <= string_length(start_string) )
            {
                current_char = string_char_at(start_string, i);
                if (current_char == ",")
                {
                    player_start_x = real(parse_string);
                    spawn_x = OW_grid_pos_to_pixels_SCR(player_start_x);
                    parse_string = "";
                }
                else
                {
                    parse_string += current_char;
                }
                i++;
            }
            player_start_y = real(parse_string);
            
        }
        // Get monster encounter rate
        global.monster_encounter_rate = ini_read_real( 'room_data', "monsters", "0" ) / 100.0;
        
        // Get encounters
        encouncounter_string = ini_read_string( 'room_data', "encounters", "0" );
        encounter_list = split_string_SCR(encouncounter_string, ",");
        global.encounter_list = encounter_list;
        
        ini_close();
    }
    else
    {
        show_message("Error - " + map_to_load + " - Map missing");
    }
    
    for (i = 0; i < array_height_2d(map); i++)
    {
        for (j = 0; j < array_length_2d(map, i); j++)
        {
            tile_id = map[i, j];
            if !is_string(tile_id)  and  tile_id > 0
            {
                spawn_x = OW_grid_pos_to_pixels_SCR(j)
                spawn_y = OW_grid_pos_to_pixels_SCR(i)
                new_tile = instance_create(spawn_x, spawn_y, OW_collision_tile_OBJ);
                
                // Set tile colour
                new_tile.draw_colour = global.room_region_colour_1
                if (tile_id == 1)
                {
                    new_tile.draw_colour = global.room_region_colour_1                                
                }           
                else if (tile_id == 2)
                {
                    new_tile.draw_colour = global.room_region_colour_2                                 
                } 
            }
        }
    }
    
    if exact_player_values == false
    {
        spawn_x = OW_grid_pos_to_pixels_SCR(player_start_x);
        spawn_y = OW_grid_pos_to_pixels_SCR(player_start_y);
    }
    else
    {
        spawn_x = player_start_x;
        spawn_y = player_start_y;
    }
    global.player = instance_create(spawn_x, spawn_y, OW_hero_OBJ);
    global.player.image_speed = 0;
    new_map= false;
    global.current_room_ID = current_room_ID;
}

if die
{
    instance_destroy();
}