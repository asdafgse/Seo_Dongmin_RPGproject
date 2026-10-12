
/// obj_bat - Step
/// Day/night transformation, melee, wing attack, charged dash
/// Captain's Final Trial - Bat Kill Count

// =====================================================
// PAUSE AND INVENTORY
// =====================================================

var pm = instance_find(obj_pause_menu, 0);
if (pm != noone && pm.menu_open) exit;

var pl = instance_find(obj_player, 0);
if (pl != noone && pl.inventory_open) exit;

// Health bar timer
if (hp_bar_timer > 0) hp_bar_timer--;


// =====================================================
// DAY / NIGHT
// =====================================================

var is_day_now = true;
var dn = instance_find(obj_daynight, 0);

if (dn != noone && variable_instance_exists(dn, "is_day"))
{
    is_day_now = dn.is_day;
}

var should_enrage = !is_day_now;


// =====================================================
// DEATH START
// =====================================================

if (hp <= 0 && state != "dying")
{
    hp = 0;
    state = "dying";
    is_transforming = false;

    sprite_index = is_enraged
        ? spr_bat_night_death
        : spr_bat_death;

    image_index = 0;
    image_speed = 0.20;

    audio_play_sound(snd_slime_death, 1, false);
}


// =====================================================
// DEATH + CAPTAIN QUEST
// =====================================================

if (state == "dying")
{
    image_blend = c_white;

    if (image_index >= image_number - 1)
    {
        // Captain Quest - Bat Kill Count
        var player = instance_find(obj_player, 0);

        if (player != noone)
        {
            if (player.captain_quest == 1)
            {
                player.quest_bat_kills = min(
                    player.quest_bat_kills + 1,
                    player.quest_bat_target
                );

                show_debug_message(
                    "Captain Quest - Bat: "
                    + string(player.quest_bat_kills)
                    + "/"
                    + string(player.quest_bat_target)
                );
            }
        }

        // Archer Quest - count each defeated bat once
        if (player != noone)
        {
            if (variable_instance_exists(player, "archer_quest") && player.archer_quest == 1)
            {
                player.archer_bat_kills = min(player.archer_bat_kills + 1, 5);
                show_debug_message("Archer Quest - Bat: " + string(player.archer_bat_kills) + "/5");
            }
        }

        // Gold drop 40%
        if (irandom(99) < 40)
        {
            instance_create_layer(x, y, layer, obj_gold);
        }

        // Health Potion drop 20%
        if (irandom(99) < 20)
        {
            instance_create_layer(
                x + 12,
                y,
                layer,
                obj_health_potion
            );
        }

        // Bat Wing drop 85%
        if (irandom(99) < 85)
        {
            instance_create_layer(
                x - 12,
                y,
                layer,
                obj_bat_wing
            );
        }

        instance_destroy();
    }

    exit;
}


// =====================================================
// DAY / NIGHT TRANSFORMATION
// =====================================================

if (!is_transforming && should_enrage != is_enraged)
{
    is_transforming = true;
    transform_to_night = should_enrage;
    state = "transform";

    sprite_index = spr_bat_transform;
    image_speed = 0;

    transform_frame = transform_to_night
        ? 0
        : image_number - 1;

    image_index = transform_frame;
    image_blend = c_white;
}

if (is_transforming)
{
    sprite_index = spr_bat_transform;
    image_speed = 0;

    if (transform_to_night)
    {
        transform_frame += transform_speed;

        if (transform_frame >= image_number - 1)
        {
            is_enraged = true;
            is_transforming = false;
        }
    }
    else
    {
        transform_frame -= transform_speed;

        if (transform_frame <= 0)
        {
            is_enraged = false;
            is_transforming = false;
        }
    }

    if (is_transforming)
    {
        image_index = clamp(
            transform_frame,
            0,
            image_number - 1
        );

        exit;
    }

    state = "idle";

    sprite_index = is_enraged
        ? spr_bat_night_idle
        : spr_bat_idle;

    image_index = 0;
    image_speed = 0.15;
    image_blend = c_white;

    exit;
}


// =====================================================
// HIT REACTION
// =====================================================

if (state == "hit")
{
    image_blend = c_red;

    var hit_sprite = is_enraged
        ? spr_bat_night_hit
        : spr_bat_hit;

    if (sprite_index != hit_sprite)
    {
        sprite_index = hit_sprite;
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

        sprite_index = is_enraged
            ? spr_bat_night_idle
            : spr_bat_idle;

        image_index = 0;
        image_speed = 0.15;
        image_blend = c_white;
        hit_flash_timer = 0;
    }

    exit;
}

image_blend = c_white;


// =====================================================
// PLAYER CHECK
// =====================================================

if (pl == noone)
{
    state = "idle";
    bat_wander_only = true;
}
else
{
    bat_wander_only = false;
}


// =====================================================
// WANDERING WITHOUT PLAYER
// =====================================================

if (bat_wander_only)
{
    if (wander_wait > 0)
    {
        wander_wait--;
    }
    else
    {
        wander_timer--;

        if (wander_timer <= 0)
        {
            wander_direction = irandom(359);
            wander_timer = irandom_range(20, 55);

            if (irandom(3) == 0)
            {
                wander_wait = irandom_range(10, 25);
            }
        }

        if (point_distance(x, y, spawn_x, spawn_y) >= wander_radius)
        {
            wander_direction = point_direction(
                x, y, spawn_x, spawn_y
            );
        }

        x += lengthdir_x(wander_speed, wander_direction);
        y += lengthdir_y(wander_speed, wander_direction);

        image_xscale =
            (lengthdir_x(1, wander_direction) < 0) ? -1 : 1;
    }

    var ws = is_enraged
        ? spr_bat_night_idle
        : spr_bat_idle;

    if (sprite_index != ws)
    {
        sprite_index = ws;
        image_index = 0;
    }

    image_speed = 0.15;
    exit;
}


// =====================================================
// PLAYER DEAD
// =====================================================

if (pl.is_dead)
{
    state = "idle";

    sprite_index = is_enraged
        ? spr_bat_night_idle
        : spr_bat_idle;

    image_index = 0;
    image_speed = 0.15;

    exit;
}


// =====================================================
// PLAYER DISTANCE AND DAMAGE
// =====================================================

var dist = point_distance(x, y, pl.x, pl.y);

var current_move_speed = is_enraged
    ? night_move_speed
    : day_move_speed;

var current_damage = is_enraged ? 2 : 1;


// =====================================================
// CHARGE ATTACK
// =====================================================

if (state == "charge")
{
    charge_timer--;

    image_blend =
        (charge_timer mod 10 < 5) ? c_red : c_white;

    dash_direction = point_direction(
        x, y, pl.x, pl.y
    );

    image_xscale = (pl.x < x) ? -1 : 1;

    if (charge_timer <= 0)
    {
        state = "dash";
        dash_timer = dash_duration;
        dash_hit_done = false;

        sprite_index = is_enraged
            ? spr_bat_night_attack1
            : spr_bat_attack;

        image_index = 0;
        image_speed = 0.15;
        image_blend = c_white;
    }

    exit;
}


// =====================================================
// DASH ATTACK
// =====================================================

if (state == "dash")
{
    var current_dash_speed = is_enraged
        ? 3.2
        : dash_speed;

    x += lengthdir_x(
        current_dash_speed,
        dash_direction
    );

    y += lengthdir_y(
        current_dash_speed,
        dash_direction
    );

    dash_timer--;

    if (
        !dash_hit_done
        && point_distance(x, y, pl.x, pl.y) <= 28
        && !pl.is_invincible
        && pl.hp > 0
    )
    {
        dash_hit_done = true;

        var block_chance = min(
            50,
            pl.defense * 5
        );

        if (irandom(99) >= block_chance)
        {
            pl.hp = max(
                0,
                pl.hp - current_damage
            );

            var knock_dir = point_direction(
                x, y, pl.x, pl.y
            );

            pl.knockback_x = lengthdir_x(
                1, knock_dir
            );

            pl.knockback_y = lengthdir_y(
                1, knock_dir
            );

            pl.knockback_timer = 6;
        }
    }

    if (dash_timer <= 0)
    {
        state = "cooldown";
        attack_cooldown = attack_cooldown_max;

        sprite_index = is_enraged
            ? spr_bat_night_idle
            : spr_bat_idle;

        image_index = 0;
        image_speed = 0.15;
    }

    exit;
}


// =====================================================
// MELEE ATTACK 1 / WING ATTACK 2
// =====================================================

if (state == "melee1" || state == "melee2")
{
    var hit_frame =
        (state == "melee2") ? 4 : 3;

    if (!melee_hit_done && image_index >= hit_frame)
    {
        melee_hit_done = true;

        var hit_range =
            (state == "melee2") ? 55 : melee_range;

        if (
            point_distance(x, y, pl.x, pl.y) <= hit_range
            && !pl.is_invincible
            && pl.hp > 0
        )
        {
            var block_chance = min(
                50,
                pl.defense * 5
            );

            if (irandom(99) >= block_chance)
            {
                pl.hp = max(
                    0,
                    pl.hp - current_damage
                );

                var knock_dir = point_direction(
                    x, y, pl.x, pl.y
                );

                pl.knockback_x = lengthdir_x(
                    1, knock_dir
                );

                pl.knockback_y = lengthdir_y(
                    1, knock_dir
                );

                pl.knockback_timer = 6;
            }
        }
    }

    if (image_index >= image_number - 1)
    {
        state = "cooldown";
        attack_cooldown = attack_cooldown_max;

        sprite_index = is_enraged
            ? spr_bat_night_idle
            : spr_bat_idle;

        image_index = 0;
        image_speed = 0.15;
    }

    exit;
}


// =====================================================
// ATTACK COOLDOWN
// =====================================================

if (state == "cooldown")
{
    attack_cooldown--;

    if (attack_cooldown <= 0)
    {
        state = "idle";
    }

    exit;
}


// =====================================================
// ATTACK SELECTION
// =====================================================

image_xscale = (pl.x < x) ? -1 : 1;

if (dist <= detect_range)
{
    // Melee attack
    if (dist <= melee_range)
    {
        melee_hit_done = false;

        if (is_enraged && irandom(1) == 1)
        {
            state = "melee2";
            sprite_index = spr_bat_night_attack2;
        }
        else
        {
            state = "melee1";

            sprite_index = is_enraged
                ? spr_bat_night_attack1
                : spr_bat_attack;
        }

        image_index = 0;
        image_speed = melee_frame_speed;

        exit;
    }

    // Charged dash
    if (dist >= dash_trigger_range)
    {
        state = "charge";

        charge_timer = is_enraged
            ? round(room_speed * 0.5)
            : charge_duration;

        sprite_index = is_enraged
            ? spr_bat_night_idle
            : spr_bat_idle;

        image_index = 0;
        image_speed = 0.20;

        exit;
    }

    // Chase player
    state = "chase";

    var follow_dir = point_direction(
        x, y, pl.x, pl.y
    );

    x += lengthdir_x(
        current_move_speed,
        follow_dir
    );

    y += lengthdir_y(
        current_move_speed,
        follow_dir
    );
}
else
{
    // =================================================
    // WANDER AROUND SPAWN POINT
    // =================================================

    state = "idle";

    if (wander_wait > 0)
    {
        wander_wait--;
    }
    else
    {
        wander_timer--;

        if (wander_timer <= 0)
        {
            wander_direction = irandom(359);
            wander_timer = irandom_range(20, 55);

            if (irandom(3) == 0)
            {
                wander_wait = irandom_range(10, 25);
            }
        }

        if (point_distance(x, y, spawn_x, spawn_y) >= wander_radius)
        {
            wander_direction = point_direction(
                x, y, spawn_x, spawn_y
            );
        }

        x += lengthdir_x(
            wander_speed,
            wander_direction
        );

        y += lengthdir_y(
            wander_speed,
            wander_direction
        );

        image_xscale =
            (lengthdir_x(1, wander_direction) < 0) ? -1 : 1;
    }
}


// =====================================================
// IDLE ANIMATION
// =====================================================

var idle_sprite = is_enraged
    ? spr_bat_night_idle
    : spr_bat_idle;

if (sprite_index != idle_sprite)
{
    sprite_index = idle_sprite;
    image_index = 0;
}

image_speed = 0.15;
