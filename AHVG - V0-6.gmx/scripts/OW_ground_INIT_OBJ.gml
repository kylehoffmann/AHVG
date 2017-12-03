#define OW_ground_INIT_OBJ
// Inheret self-distruction
OW_generic_INIT_SCR();

draw_colour = c_white;

depth_offset = 128;


#define OW_ground_DRAW_OBJ

if (global.game_state == "overworld_menu" or
    global.game_state == "overworld")
{
    draw_sprite_ext( sprite_index, image_index, x, y, 1, 1, 0, draw_colour, 1 );
}