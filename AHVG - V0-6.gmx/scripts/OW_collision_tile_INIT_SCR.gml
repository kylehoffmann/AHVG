#define OW_collision_tile_INIT_SCR
image="";

// Inheret self-distruction
OW_generic_INIT_SCR();

draw_colour = c_white;

#define OW_collision_tile_DRAW_SCR

if (global.game_state == "overworld_menu" or
    global.game_state == "overworld")
{
    draw_sprite_ext( sprite_index, image_index, x, y, 1, 1, 0, draw_colour, 1 );
}