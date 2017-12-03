#define OW_load_zone_INI_SCR
// Inheret self-distruction
OW_generic_INIT_SCR();

load_ROOM_ID = 0;
player_x = 0;
player_y = 0;
exact_player_values = false;


draw_colour = c_white


depth_offset = 128;

#define OW_load_zone_STEP_SCR
// Inheret self-distruction
OW_generic_STEP_SCR();

if place_meeting(x, y, OW_hero_OBJ)
{
    if load_ROOM_ID == global.current_room_ID
    {
        global.player.x = OW_grid_pos_to_pixels_SCR(player_x);
        global.player.y = OW_grid_pos_to_pixels_SCR(player_y);
    }
    else
    {
        global.room_loaded.exact_player_values = exact_player_values;
        global.room_loaded.current_room_ID = load_ROOM_ID;
        global.room_loaded.map_to_load = load_ROOM_ID + ".ini";
        global.room_loaded.player_start_x = player_x;
        global.room_loaded.player_start_y = player_y;
        global.OW_kill_all = true;
    }
}
#define OW_load_zone_DRAW_SCR

if (global.game_state == "overworld_menu" or
    global.game_state == "overworld")
{
    draw_sprite_ext( sprite_index, image_index, x, y, 1, 1, 0, draw_colour, 1 );
}