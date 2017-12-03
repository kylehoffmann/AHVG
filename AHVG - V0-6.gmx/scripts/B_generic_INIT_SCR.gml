#define B_generic_INIT_SCR
global.B_OBJs++;

depth_offset = 0;

#define B_generic_STEP_SCR
if global.B_kill_all
{
    B_generic_kill_self_SCR();
}

depth = -y + depth_offset;

#define B_generic_kill_self_SCR
global.B_OBJs--;
instance_destroy();