/// Wizard NPC - Step

// 플레이어 방향 바라보기
var pl = instance_find(obj_player, 0);

if (pl != noone)
{
    if (pl.x < x)
    {
        image_xscale = -1;
    }
    else
    {
        image_xscale = 1;
    }
}

// 상호작용 애니메이션
if (is_interacting)
{
    if (image_index >= image_number - 1)
    {
        is_interacting = false;

        sprite_index = spr_wizard_idle;
        image_index = 0;
        image_speed = 0.15;
    }
}
else
{
    if (sprite_index != spr_wizard_idle)
    {
        sprite_index = spr_wizard_idle;
        image_index = 0;
    }

    image_speed = 0.15;
}