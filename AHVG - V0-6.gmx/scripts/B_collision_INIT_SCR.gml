#define B_collision_INIT_SCR
image="";

// Inheret generic function
event_inherited();

draw_colour = c_white;

#define B_collision_DRAW_SCR

draw_sprite_ext( sprite_index, image_index, x, y, 1, 1, 0, draw_colour, 1 );