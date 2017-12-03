#define OW_NPC_collision_INIT_SCR
// Inheret generic function
event_inherited();

depth_offset = -128;

parent = 0;

current_dialogue = "";

text_scale = 3;

#define OW_NPC_collision_STEP_SCR
// Inheret generic function
event_inherited();
if parent != 0
{
    if place_meeting(x, y, OW_hero_OBJ)
    {
        parent.hero_in_range = true;
    }
    else
    {
        parent.hero_in_range = false;
    }
}

#define OW_NPC_collision_DRAW_SCR
text_x = x - string_width(current_dialogue)/2*text_scale;
text_y = y - 256;

text_x_end = x + string_width(current_dialogue)/2*text_scale;
text_y_end = y - 256 + 16 * text_scale;

border = 5;

if current_dialogue != ""
{
    draw_set_alpha(0.85);
    draw_set_colour(c_ltgray);
    draw_roundrect(text_x - border, text_y - border, 
        text_x_end + border, text_y_end + border, false);
    
    draw_set_alpha(1.0);
    draw_set_colour(c_black);
    for (i = 0; i < border; i ++)
    {
        draw_roundrect(text_x - border + i, text_y - border + i, 
            text_x_end + border - i, text_y_end + border - i, true);
    }
}
draw_text_transformed(text_x, text_y, current_dialogue, text_scale, text_scale, 0);