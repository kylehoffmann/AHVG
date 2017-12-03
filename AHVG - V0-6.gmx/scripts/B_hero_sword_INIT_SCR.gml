#define B_hero_sword_INIT_SCR
// Animation Control
current_frame = 0;
swipe_frames = 4;
hold_frame = 3;
shine_frame = 4;
frames_MAX = swipe_frames* 3 + 2 * hold_frame + 2 * shine_frame;

//get hero facing
hero_facing = global.B_hero_facing;
if (hero_facing == "right")
{
    sprite_index = B_hero_sword_SPR;
}
else
{
    sprite_index = B_hero_sword_flipped_SPR;
}


// Set sword draw offset
if (global.B_hero_crouch)
{
    x_offest = 64;
    y_offset = 48;
}
/*else if(global.jumping_not_hit and global.battle_jumped)
{
    x_offest = 64;
    y_offset = 136;
}*/
else 
{
    x_offest = 64;
    y_offset = 128;
}


jump_offset = 136 - y_offset;

#define B_hero_sword_DRAW_SCR
if (global.B_kill_all)
{
    instance_destroy();
}

// when animation is done destroy self
/*if (current_frame >= frames_MAX and
    !keyboard_check(vk_enter)) {instance_destroy();}*/
if (current_frame >= frames_MAX) {instance_destroy();}

// Used to check the current frame of animation
frame_checker = 0;
sub_image_to_use = 0;


//correct co-ordinates
x = global.B_player.x;
y = global.B_player.y - y_offset;
if (global.jumping_not_hit and global.battle_jumped) {y -= jump_offset;}
if (hero_facing == "right") {x += x_offest;}
else {x -= x_offest;}

// Set frame on animation
for (i = 0; i < 3; i ++)
{
    if (current_frame > frame_checker) 
    {
        if (sub_image_to_use == 0)
        {
            y -= 6;
        }
        else if (sub_image_to_use == 1)
        {
            y -= 8;
        }
        else if (sub_image_to_use == 2)
        {
            y += 12;        
        }
        image_index = sub_image_to_use++;
    }
    frame_checker += swipe_frames;
}
if (current_frame > frame_checker) {image_index = sub_image_to_use++;}
frame_checker += hold_frame;
if (current_frame > frame_checker) {image_index = sub_image_to_use++;}
frame_checker += shine_frame;
if (current_frame > frame_checker) {image_index = sub_image_to_use++;}
frame_checker += shine_frame;
if (current_frame > frame_checker) {image_index = sub_image_to_use++;}

draw_self();

// Next frame
current_frame++;



#define B_hero_sword_STEP_SCR
if (global.B_kill_all)
{
    instance_destroy();
}