/// obj_orc - Step (wandering added; existing combat retained)
// Requires: night sprites, spr_orc_transform, obj_orc_shockwave, obj_orc_hide.
var pm = instance_find(obj_pause_menu, 0);
if (pm != noone && pm.menu_open) exit;
var pl = instance_find(obj_player, 0);
if (pl != noone && pl.inventory_open) exit;
if (hp_bar_timer > 0) hp_bar_timer--;

// Death is handled first and is never overwritten by another state.
if (hp <= 0 && state != "dying")
{
    hp = 0;
    state = "dying";
    sprite_index = is_enraged ? spr_orc_night_death : spr_orc_death;
    image_index = 0;
    image_speed = 0;
    image_blend = c_white;
    death_frame = 0;
    death_hold = 0;
    death_drop_done = false;
    audio_play_sound(snd_slime_death, 1, false);
}
if (state == "dying")
{
    image_blend = c_white;
    image_speed = 0;
    var last_frame = max(0, sprite_get_number(sprite_index) - 1);
    if (death_frame < last_frame)
    {
        death_frame = min(last_frame, death_frame + death_anim_fps / room_speed);
        image_index = floor(death_frame);
    }
    else
    {
        image_index = last_frame;
        death_hold++;
        if (death_hold >= death_hold_max && !death_drop_done)
{
    death_drop_done = true;

    // =====================================
    // CAPTAIN QUEST - ORC KILL COUNT
    // =====================================

    var player = instance_find(obj_player, 0);

    if (player != noone)
    {
        if (player.captain_quest == 1)
        {
            player.quest_orc_kills = min(
                player.quest_orc_kills + 1,
                player.quest_orc_target
            );

            show_debug_message(
                "Captain Quest - Orc: "
                + string(player.quest_orc_kills)
                + "/"
                + string(player.quest_orc_target)
            );
        }
    }

    // Spearman quest - count this orc once on death
    if (player != noone && variable_instance_exists(player, "spearman_quest"))
    {
        if (player.spearman_quest == 1)
        {
            player.spearman_orc_kills = min(3, player.spearman_orc_kills + 1);
        }
    }

    // =====================================
    // 기존 아이템 드롭 (변경 없음)
    // =====================================

    // 골드 50%
    if (irandom(99) < 50)
        instance_create_layer(x, y, layer, obj_gold);

    // 포션 20%
    if (irandom(99) < 20)
        instance_create_layer(x + 12, y, layer, obj_health_potion);

    // 오크 가죽 70%
    if (irandom(99) < 70)
        instance_create_layer(x - 12, y, layer, obj_orc_hide);

    instance_destroy();
}
    }
    exit;
}

// Hit reaction: retain original knockback behavior.
if (state == "hit")
{
    image_blend = c_red;
    var hurt_spr = is_enraged ? spr_orc_night_hurt : spr_orc_hurt;
    if (sprite_index != hurt_spr)
    {
        sprite_index = hurt_spr;
        image_index = 0;
        image_speed = 0.25;
    }
    if (knockback_timer > 0)
    {
        x += knockback_x * knockback_speed;
        y += knockback_y * knockback_speed;
        knockback_timer--;
    }
    if (image_index >= image_number - 1)
    {
        state = "idle";
        sprite_index = is_enraged ? spr_orc_night_idle : spr_orc_idle;
        image_index = 0;
        image_speed = 0.15;
        image_blend = c_white;
        hit_flash_timer = 0;
    }
    exit;
}
image_blend = c_white;

// Transform: manually advance frames to prevent reverse animation looping.
if (state == "transform")
{
    image_speed = 0;
    var last_transform_frame = max(0, sprite_get_number(spr_orc_transform) - 1);
    var frame_step = transform_speed;
    if (transform_reverse)
        transform_frame = max(0, transform_frame - frame_step);
    else
        transform_frame = min(last_transform_frame, transform_frame + frame_step);
    image_index = clamp(floor(transform_frame), 0, last_transform_frame);

    if ((!transform_reverse && transform_frame >= last_transform_frame)
        || (transform_reverse && transform_frame <= 0))
    {
        is_enraged = transform_target_night;
        state = "idle";
        sprite_index = is_enraged ? spr_orc_night_idle : spr_orc_idle;
        image_index = 0;
        image_speed = 0.15;
        attack_cooldown = 0;
    }
    exit;
}

// Detect day/night change. Transform after an active attack finishes.
var dn = instance_find(obj_daynight, 0);
var should_be_night = is_enraged;
if (dn != noone && variable_instance_exists(dn, "is_day"))
    should_be_night = !dn.is_day;
if (should_be_night != is_enraged && state != "attack" && state != "night_attack")
{
    transform_target_night = should_be_night;
    transform_reverse = !should_be_night;
    state = "transform";
    sprite_index = spr_orc_transform;
    image_speed = 0;
    transform_frame = transform_reverse ? max(0, sprite_get_number(spr_orc_transform) - 1) : 0;
    image_index = floor(transform_frame);
    exit;
}

// Keep wandering even when there is no living player.
var player_active = (pl != noone);
if (player_active) player_active = !pl.is_dead;
var dist = 1000000;
if (player_active) dist = point_distance(x, y, pl.x, pl.y);

// Day: retain original 1-2 attack sequence.
if (state == "attack")
{
    if (!melee_hit_done && image_index >= 3)
    {
        melee_hit_done = true;
        if (player_active && dist <= melee_range && !pl.is_invincible && pl.hp > 0)
        {
            var block_chance = min(50, pl.defense * 5);
            if (irandom(99) >= block_chance)
            {
                pl.hp = max(0, pl.hp - melee_damage);
                var kd = point_direction(x, y, pl.x, pl.y);
                pl.knockback_x = lengthdir_x(1, kd);
                pl.knockback_y = lengthdir_y(1, kd);
                pl.knockback_timer = 6;
            }
        }
    }
    if (image_index >= image_number - 1)
    {
        attack_count++;
        if (attack_count < attack_count_max)
        {
            sprite_index = spr_orc_attack2;
            image_index = 0;
            image_speed = melee_frame_speed;
            melee_hit_done = false;
        }
        else
        {
            state = "cooldown";
            attack_cooldown = attack_cooldown_max;
            sprite_index = spr_orc_idle;
            image_index = 0;
            image_speed = 0.15;
        }
    }
    exit;
}

// Night: one of three distinct attacks per cooldown.
if (state == "night_attack")
{
    if (!melee_hit_done && image_index >= night_hit_frame)
    {
        melee_hit_done = true;
        if (night_attack_kind == 3)
        {
            if (!night_shockwave_spawned)
            {
                night_shockwave_spawned = true;
                var wave = instance_create_layer(x, y, layer, obj_orc_shockwave);
                wave.max_radius = night_shockwave_radius;
                wave.damage = night_shockwave_damage;
            }
        }
        else if (player_active)
        {
            var facing = (image_xscale < 0) ? 180 : 0;
            var target_dir = point_direction(x, y, pl.x, pl.y);
            var arc = (night_attack_kind == 2) ? 30 : 80;
            if (dist <= night_hit_range && abs(angle_difference(facing, target_dir)) <= arc
                && !pl.is_invincible && pl.hp > 0)
            {
                var block_chance = min(50, pl.defense * 5);
                if (irandom(99) >= block_chance)
                {
                    pl.hp = max(0, pl.hp - night_attack_damage);
                    var kd = point_direction(x, y, pl.x, pl.y);
                    pl.knockback_x = lengthdir_x(1, kd);
                    pl.knockback_y = lengthdir_y(1, kd);
                    pl.knockback_timer = 6;
                }
            }
        }
    }
    if (image_index >= image_number - 1)
    {
        state = "cooldown";
        attack_cooldown = attack_cooldown_max;
        sprite_index = spr_orc_night_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

if (state == "cooldown")
{
    attack_cooldown--;
    if (attack_cooldown <= 0) state = "idle";
    exit;
}

if (player_active && dist <= detect_range)
{
    image_xscale = (pl.x < x) ? -1 : 1;
    var engage_range = is_enraged ? 72 : melee_range;
    if (dist <= engage_range)
    {
        if (is_enraged)
        {
            state = "night_attack";
            night_attack_kind = irandom_range(1, 3);
            night_shockwave_spawned = false;
            melee_hit_done = false;
            if (night_attack_kind == 1)
            {
                sprite_index = spr_orc_night_attack1;
                night_hit_range = 48;
                night_attack_damage = 3;
            }
            else if (night_attack_kind == 2)
            {
                sprite_index = spr_orc_night_attack2;
                night_hit_range = 72;
                night_attack_damage = 2;
            }
            else sprite_index = spr_orc_night_attack3;
            image_index = 0;
            image_speed = night_attack_speed;
        }
        else
        {
            state = "attack";
            attack_count = 0;
            attack_count_max = (random(1) < double_attack_chance) ? 2 : 1;
            melee_hit_done = false;
            sprite_index = spr_orc_attack1;
            image_index = 0;
            image_speed = melee_frame_speed;
        }
        exit;
    }
    state = "chase";
    var follow_dir = point_direction(x, y, pl.x, pl.y);
    var spd = is_enraged ? night_move_speed : day_move_speed;
    var mx = lengthdir_x(spd, follow_dir);
    var my = lengthdir_y(spd, follow_dir);
    if (!place_meeting(x + mx, y, obj_player)) x += mx;
    if (!place_meeting(x, y + my, obj_player)) y += my;
    var walk_spr = is_enraged ? spr_orc_night_walk : spr_orc_walk;
    if (sprite_index != walk_spr)
    {
        sprite_index = walk_spr;
        image_index = 0;
    }
    image_speed = 0.15;
}
else
{
    // Wander around spawn_x / spawn_y; keep original combat logic intact.
    state = "idle";
    if (wander_wait > 0)
    {
        wander_wait--;
        var rest_spr = is_enraged ? spr_orc_night_idle : spr_orc_idle;
        if (sprite_index != rest_spr)
        {
            sprite_index = rest_spr;
            image_index = 0;
        }
        image_speed = 0.15;
    }
    else
    {
        if (point_distance(x, y, spawn_x, spawn_y) >= wander_radius)
        {
            wander_direction = point_direction(x, y, spawn_x, spawn_y);
            wander_timer = irandom_range(35, 70);
        }
        else if (wander_timer <= 0)
        {
            wander_direction = irandom(359);
            wander_timer = irandom_range(45, 100);
            if (irandom(99) < 35) wander_wait = irandom_range(15, 50);
        }
        if (wander_wait <= 0)
        {
            var wx = lengthdir_x(wander_speed, wander_direction);
            var wy = lengthdir_y(wander_speed, wander_direction);
            // Preserve the original no-overlap-with-player movement rule.
            if (!place_meeting(x + wx, y, obj_player)) x += wx;
            if (!place_meeting(x, y + wy, obj_player)) y += wy;
            if (abs(wx) > 0.01) image_xscale = (wx < 0) ? -1 : 1;
            var wandering_spr = is_enraged ? spr_orc_night_walk : spr_orc_walk;
            if (sprite_index != wandering_spr)
            {
                sprite_index = wandering_spr;
                image_index = 0;
            }
            image_speed = 0.15;
        }
        wander_timer--;
    }
}
