#define OW_health_pickup_INIT_SCR
// Inheret generic function
event_inherited();

x -=32;
y -=32;


#define OW_health_pickup_STEP_SCR
// Inheret generic function
event_inherited();

if place_meeting(x, y, OW_hero_OBJ)
{
    player_add_hp_SCR(1);
    global.OW_OBJs--;
    instance_destroy();
}