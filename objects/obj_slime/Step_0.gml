// obj_slime -> Step (전체 교체)
// 낮: 기존 근접 공격
// 밤: Attack 1 (38px) 또는 Attack 2 (48px) 랜덤 50:50
// 변신: 낮->밤 정방향, 밤->낮 역방향

// 체력바 표시 시간 감소
if (hp_bar_timer > 0)
{
    hp_bar_timer--;
}

// 일시정지 / 인벤토리
var pause_menu = instance_find(obj_pause_menu, 0);
if (pause_menu != noone)
{
    if (pause_menu.menu_open || keyboard_check_pressed(vk_escape)) exit;
}
var player_pause = instance_find(obj_player, 0);
if (player_pause != noone && player_pause.inventory_open) exit;

// 현재 시간
var daytime = true;
var dn = instance_find(obj_daynight, 0);
if (dn != noone && variable_instance_exists(dn, "is_day")) daytime = dn.is_day;

// 사망 처리: 애니메이션 완료 후 드롭
if (state == "dying")
{
    var death_sprite = is_enraged ? spr_slime_night_death : spr_slime_death;
    if (sprite_index != death_sprite)
    {
        sprite_index = death_sprite;
        image_index = 0;
        image_speed = 0.25;
    }
    death_anim_timer--;
    if (death_anim_timer <= 0)
{
    // =====================================
    // CAPTAIN QUEST - SLIME KILL COUNT
    // =====================================

    var pl = instance_find(obj_player, 0);

    if (pl != noone)
    {
        // 퀘스트 진행 중일 때만 카운트
        if (pl.captain_quest == 1)
        {
            pl.quest_slime_kills = min(
                pl.quest_slime_kills + 1,
                pl.quest_slime_target
            );

            show_debug_message(
                "Captain Quest - Slime: "
                + string(pl.quest_slime_kills)
                + "/"
                + string(pl.quest_slime_target)
            );
        }
    }

    // =====================================
    // 기존 아이템 드롭 (변경 없음)
    // =====================================

    if (irandom(99) < 70)
        instance_create_layer(x - 12, y, layer, obj_slime_gel);

    if (irandom(99) < 30)
        instance_create_layer(x + 12, y, layer, obj_health_potion);

    if (irandom(99) < 40)
        instance_create_layer(x, y + 12, layer, obj_gold);

    instance_destroy();
}
    exit;
}

// 낮/밤 변경 감지
if (daytime != last_is_day)
{
    last_is_day = daytime;
    is_transforming = true;
    transform_to_night = !daytime;
    transform_frame = transform_to_night ? 0 : 7;
    state = "transform";
    melee_attacking = false;
    melee_hit_done = false;
    attack_hit_done = false;
    hit_anim_timer = 0;
    knockback_timer = 0;
    sprite_index = spr_slime_transform;
    image_speed = 0;
    image_index = transform_frame;
    image_blend = c_white;
}

// 변신 애니메이션
if (is_transforming)
{
    sprite_index = spr_slime_transform;
    image_speed = 0;
    image_index = clamp(floor(transform_frame), 0, 7);
    if (transform_to_night)
    {
        transform_frame += transform_speed;
        if (transform_frame >= 8)
        {
            is_transforming = false;
            is_enraged = true;
            state = "idle";
            sprite_index = spr_slime_night_idle;
            image_index = 0;
            image_speed = 0.15;
        }
    }
    else
    {
        transform_frame -= transform_speed;
        if (transform_frame < 0)
        {
            is_transforming = false;
            is_enraged = false;
            state = "idle";
            sprite_index = spr_slime_idle;
            image_index = 0;
            image_speed = 0.15;
        }
    }
    exit;
}

// 피격 애니메이션
if (hit_anim_timer > 0)
{
    var hit_sprite = is_enraged ? spr_slime_night_hit : spr_slime_hit;
    if (sprite_index != hit_sprite)
    {
        sprite_index = hit_sprite;
        image_index = 0;
        image_speed = 0.25;
    }
    hit_anim_timer--;
    if (hit_anim_timer <= 0)
    {
        state = "idle";
        sprite_index = is_enraged ? spr_slime_night_idle : spr_slime_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 넉백
if (knockback_timer > 0)
{
    x += knockback_x * knockback_speed;
    y += knockback_y * knockback_speed;
    knockback_timer--;
    exit;
}

// 피격 플래시
image_blend = c_white;
if (hit_flash_timer > 0)
{
    hit_flash_timer--;
    image_blend = c_red;
}

// 플레이어와 충분히 멀면 스폰 지점 주변에서 자유 배회
var player = instance_nearest(x, y, obj_player);
var dist = (player == noone) ? 999999 : point_distance(x, y, player.x, player.y);

if (dist > detect_range * 1.5 || (player != noone && player.is_dead))
{
    state = "idle";

    // 방향 변경 또는 휴식
    if (wander_wait > 0)
    {
        wander_wait--;
    }
    else
    {
        wander_timer--;
        if (wander_timer <= 0)
        {
            if (irandom(99) < 35)
            {
                wander_wait = irandom_range(20, 60);
            }
            wander_direction = irandom(359);
            wander_timer = irandom_range(30, 90);
        }

        // 스폰 위치에서 멀어지면 중심으로 복귀
        var home_dist = point_distance(x, y, spawn_x, spawn_y);
        var move_dir = wander_direction;
        if (home_dist >= wander_radius)
            move_dir = point_direction(x, y, spawn_x, spawn_y);

        var wx = lengthdir_x(wander_speed, move_dir);
        var wy = lengthdir_y(wander_speed, move_dir);
        x += wx;
        y += wy;
        if (abs(wx) > 0.01) image_xscale = (wx < 0) ? -1 : 1;
    }

    var roaming = (wander_wait <= 0);
    var wander_spr = is_enraged
        ? (roaming ? spr_slime_night_walk : spr_slime_night_idle)
        : (roaming ? spr_slime_walk : spr_slime_idle);
    if (sprite_index != wander_spr)
    {
        sprite_index = wander_spr;
        image_index = 0;
    }
    image_speed = 0.15;
    exit;
}

// 공통 쿨타임
if (state == "melee_cooldown" || state == "night_cooldown")
{
    melee_cooldown--;
    var idle_sprite = is_enraged ? spr_slime_night_idle : spr_slime_idle;
    if (sprite_index != idle_sprite)
    {
        sprite_index = idle_sprite;
        image_index = 0;
        image_speed = 0.15;
    }
    if (melee_cooldown <= 0) state = "idle";
    exit;
}

// ---------------- 낮 ----------------
if (!is_enraged)
{
    if (state == "melee_attack")
    {
        // 6프레임 공격: 4번째 프레임에 1회 판정
        if (!melee_hit_done && image_index >= 3)
        {
            melee_hit_done = true;
            if (point_distance(x, y, player.x, player.y) <= melee_range && !player.is_invincible && player.hp > 0)
            {
                var block_chance = min(50, player.defense * 5);
                if (irandom(99) >= block_chance)
                {
                    player.hp = max(0, player.hp - melee_damage);
                    var knock_dir = point_direction(x, y, player.x, player.y);
                    player.knockback_x = lengthdir_x(1, knock_dir);
                    player.knockback_y = lengthdir_y(1, knock_dir);
                    player.knockback_timer = 6;
                }
            }
        }
        if (image_index >= 5)
        {
            melee_attacking = false;
            state = "melee_cooldown";
            melee_cooldown = melee_cooldown_max;
        }
        exit;
    }

    if (dist > detect_range * 1.5) state = "idle";
    else if (dist <= detect_range) state = "melee_chase";

    if (state == "melee_chase" && dist <= melee_range)
    {
        state = "melee_attack";
        melee_attacking = true;
        melee_hit_done = false;
        image_xscale = (player.x < x) ? -1 : 1;
        sprite_index = spr_slime_attack;
        image_index = 0;
        image_speed = melee_frame_speed;
        exit;
    }
    if (state == "melee_chase")
    {
        if (sprite_index != spr_slime_walk)
        {
            sprite_index = spr_slime_walk;
            image_index = 0;
            image_speed = 0.15;
        }
        image_xscale = (player.x < x) ? -1 : 1;
        var follow_dir = point_direction(x, y, player.x, player.y);
        x += lengthdir_x(day_move_speed, follow_dir);
        y += lengthdir_y(day_move_speed, follow_dir);
    }
    else if (sprite_index != spr_slime_idle)
    {
        sprite_index = spr_slime_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// ---------------- 밤 ----------------
// Attack 1: 6프레임, 전방 38px, 세로 폭 +/- 24px
if (state == "night_attack1")
{
    attack_frame += night_anim_speed;
    image_index = min(5, floor(attack_frame));

    if (!attack_hit_done && attack_frame >= 3)
    {
        attack_hit_done = true;
        var dx1 = player.x - x;
        var dy1 = player.y - y;
        var front1 = (attack_facing == 1) ? (dx1 >= 0) : (dx1 <= 0);
        if (front1 && abs(dx1) <= 38 && abs(dy1) <= 24
            && point_distance(x, y, player.x, player.y) <= 38
            && !player.is_invincible && player.hp > 0)
        {
            var block1 = min(50, player.defense * 5);
            if (irandom(99) >= block1)
            {
                player.hp = max(0, player.hp - 1);
                var knock1 = point_direction(x, y, player.x, player.y);
                player.knockback_x = lengthdir_x(1, knock1);
                player.knockback_y = lengthdir_y(1, knock1);
                player.knockback_timer = 6;
            }
        }
    }

    if (attack_frame >= 6)
    {
        state = "night_cooldown";
        melee_cooldown = night_cooldown_max;
        sprite_index = spr_slime_night_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// Attack 2: 9프레임, 전방 48px, 세로 폭 +/- 24px
// 기존 Draw End 이펙트는 night_attack2 상태에서 그대로 표시됨
if (state == "night_attack2")
{
    attack_frame += night_anim_speed;
    image_index = min(8, floor(attack_frame));

    // 5번째 프레임(index 4): 전방 1회 피격
    if (!attack_hit_done && attack_frame >= 4)
    {
        attack_hit_done = true;
        var dx2 = player.x - x;
        var dy2 = player.y - y;
        var front2 = (attack_facing == 1) ? (dx2 >= 0) : (dx2 <= 0);
        if (front2 && abs(dx2) <= 48 && abs(dy2) <= 24
            && point_distance(x, y, player.x, player.y) <= 48
            && !player.is_invincible && player.hp > 0)
        {
            var block2 = min(50, player.defense * 5);
            if (irandom(99) >= block2)
            {
                player.hp = max(0, player.hp - 1);
                var knock2 = point_direction(x, y, player.x, player.y);
                player.knockback_x = lengthdir_x(1, knock2);
                player.knockback_y = lengthdir_y(1, knock2);
                player.knockback_timer = 6;
            }
        }
    }
    if (attack_frame >= 9)
    {
        state = "night_cooldown";
        melee_cooldown = night_cooldown_max;
        sprite_index = spr_slime_night_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

if (dist > detect_range * 1.5) state = "idle";
else if (dist <= detect_range) state = "night_chase";

// 48px 이내에서 Attack 1 / Attack 2를 항상 50:50 랜덤 선택.
// 공격별 실제 피격 판정 거리는 각각 38px / 48px로 유지.
if (state == "night_chase" && dist <= 48)
{
    var chosen_attack = irandom_range(1, 2);
    state = (chosen_attack == 1) ? "night_attack1" : "night_attack2";
    attack_frame = 0;
    attack_hit_done = false;
    attack_facing = (player.x < x) ? -1 : 1;
    image_xscale = attack_facing;
    sprite_index = (chosen_attack == 1) ? spr_slime_night_attack1 : spr_slime_night_attack2;
    image_index = 0;
    image_speed = 0;
    exit;
}
if (state == "night_chase")
{
    if (sprite_index != spr_slime_night_walk)
    {
        sprite_index = spr_slime_night_walk;
        image_index = 0;
        image_speed = 0.15;
    }
    image_xscale = (player.x < x) ? -1 : 1;
    var follow_dir = point_direction(x, y, player.x, player.y);
    x += lengthdir_x(night_move_speed, follow_dir);
    y += lengthdir_y(night_move_speed, follow_dir);
}
else if (sprite_index != spr_slime_night_idle)
{
    sprite_index = spr_slime_night_idle;
    image_index = 0;
    image_speed = 0.15;
}
