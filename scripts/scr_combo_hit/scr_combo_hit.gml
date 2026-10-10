// scr_combo_hit (전체 교체)
function scr_combo_hit(_player, _combo)
{
    var range = 75;
    var half_width = 35;
    with (obj_slime)
    {
        if (state == "dying" || hp <= 0) continue;
        var dx = x - _player.x;
        var dy = y - _player.y;
        var in_range = false;
        switch (_player.facing)
        {
            case "right": in_range = dx >= 0 && dx <= range && abs(dy) <= half_width; break;
            case "left": in_range = dx <= 0 && dx >= -range && abs(dy) <= half_width; break;
            case "up": in_range = dy <= 0 && dy >= -range && abs(dx) <= half_width; break;
            case "down": in_range = dy >= 0 && dy <= range && abs(dx) <= half_width; break;
        }
        if (!in_range) continue;
        hp -= _player.attack_damage;
        audio_play_sound(snd_slime_hit, 1, false);
        var dir = point_direction(_player.x, _player.y, x, y);
        knockback_x = lengthdir_x(1, dir);
        knockback_y = lengthdir_y(1, dir);
        knockback_timer = (_combo == 3) ? 10 : 5;
        melee_attacking = false;
        attack_hit_done = false;
        if (hp <= 0)
        {
            hp = 0;
            state = "dying";
            is_transforming = false;
            knockback_timer = 0;
            hit_anim_timer = 0;
            sprite_index = is_enraged ? spr_slime_night_death : spr_slime_death;
            image_index = 0;
            image_speed = 0.25;
            death_anim_timer = 16;
            audio_play_sound(snd_slime_death, 1, false);
        }
        else
        {
            state = "idle";
            is_transforming = false;
            hit_anim_timer = 16;
            sprite_index = is_enraged ? spr_slime_night_hit : spr_slime_hit;
            image_index = 0;
            image_speed = 0.25;
        }
    }
}
