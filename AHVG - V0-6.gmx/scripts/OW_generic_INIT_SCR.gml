#define OW_generic_INIT_SCR
global.OW_OBJs++;

depth_offset = 0;

#define OW_generic_STEP_SCR
if global.OW_kill_all
{
    global.OW_OBJs--;
    instance_destroy();
}

depth = -y + depth_offset;
#define OW_generic_DRAW_SCR
if (global.game_state == "overworld_menu" or
    global.game_state == "overworld")
{
    draw_self();
}