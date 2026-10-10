// =====================================================
// PAUSE MENU가 열려 있으면 플레이어 조작 정지
// =====================================================

var pause_menu = instance_find(obj_pause_menu, 0);

if (pause_menu != noone)
{
    if (pause_menu.menu_open || keyboard_check_pressed(vk_escape))
    {
        exit;
    }
}


// =====================================================
// 피격 감지 및 사망 애니메이션
// =====================================================
if (hp < last_hp && hp > 0)
{
    audio_play_sound(snd_player_hit, 1, false);
    is_hit = true;
    hit_timer = hit_duration;
    is_attacking = false;
    combo_step = 0;
    combo_queued = false;
    combo_hit_mask = 0;
    sprite_index = spr_player_hit;
    image_index = 0;
    image_speed = 0.25;
}
last_hp = hp;

if (hp <= 0 && !is_dead)
{
    audio_play_sound(snd_player_death, 1, false);
    hp = 0;
    is_dead = true;
    is_hit = false;
    is_attacking = false;
    is_rolling = false;
    is_invincible = false;
    combo_step = 0;
    combo_queued = false;
    combo_hit_mask = 0;
    sprite_index = spr_player_death;
    image_index = 0;
    image_speed = 0.2;
}

if (is_dead)
{
    // 죽음 애니메이션을 한 번만 재생하고 마지막 프레임에서 멈춤
    if (sprite_index != spr_player_death)
    {
        sprite_index = spr_player_death;
        image_index = 0;
        image_speed = 0.2;
    }
    if (image_index >= image_number - 1)
    {
        image_index = image_number - 1;
        image_speed = 0;
    }

    if (keyboard_check_pressed(ord("R")))
    {
        var gold_loss = floor(gold * 0.08);
        gold -= gold_loss;
        x = save_x;
        y = save_y;
        hp = max_hp;
        last_hp = hp;
        is_dead = false;
        is_hit = false;
        hit_timer = 0;
        is_attacking = false;
        combo_step = 0;
        combo_queued = false;
        combo_hit_mask = 0;
        is_rolling = false;
        is_invincible = false;
        is_drinking_potion = false;
        attack_timer = 0;
        roll_timer = 0;
        potion_timer = 0;
        knockback_timer = 0;
        knockback_x = 0;
        knockback_y = 0;
        dialogue_open = false;
        upgrade_open = false;
        inventory_open = false;
        sprite_index = spr_player_idle;
        image_index = 0;
        image_speed = 0.15;
        show_debug_message("RESPAWNED! Lost " + string(gold_loss) + " Gold");
    }
    exit;
}

// =====================================================
// 인벤토리
// =====================================================

if (!inventory_open && keyboard_check_pressed(ord("I")))
{
    inventory_open = true;

    audio_play_sound(
        snd_ui_click,
        1,
        false
    );
}


if (inventory_open)
{
    if (keyboard_check_pressed(vk_escape))
    {
        inventory_open = false;

        audio_play_sound(
            snd_ui_click,
            1,
            false
        );
    }

    exit;
}


// =====================================================
// 랜덤 강화 카드 선택 중
// =====================================================

if (upgrade_open)
{
    var selected_card = -1;

    if (keyboard_check_pressed(ord("1")))
    {
        selected_card = card1;
    }

    if (keyboard_check_pressed(ord("2")))
    {
        selected_card = card2;
    }

    if (keyboard_check_pressed(ord("3")))
    {
        selected_card = card3;
    }

    if (selected_card != -1)
    {
        audio_play_sound(
            snd_ui_click,
            1,
            false
        );

        if (selected_card == 0)
        {
            attack_damage += 1;
        }

        if (selected_card == 1)
        {
            max_hp += 1;
            hp += 1;
        }

        if (selected_card == 2)
        {
            defense += 1;
        }

        if (selected_card == 3)
        {
            move_speed += 0.5;
        }

        if (selected_card == 4)
        {
            potion_heal += 1;
        }

        upgrade_open = false;
        upgrade_cost += 25;
    }

    exit;
}


// =====================================================
// 포션 사용 중 - 4프레임 힐 애니메이션
// =====================================================
if (is_drinking_potion)
{
    // 플레이어 스프라이트는 변경하지 않음.
    // 힐 마법은 Draw 이벤트에서 별도로 표시.
    potion_timer--;

    if (potion_timer <= 0)
    {
        is_drinking_potion = false;
        potion_timer = 0;
    }
    exit;
}


// =====================================================
// 피격 애니메이션 / 넉백
// =====================================================
if (is_hit)
{
    sprite_index = spr_player_hit;
    image_speed = 0.25;
    if (knockback_timer > 0)
    {
        x += knockback_x * knockback_speed;
        y += knockback_y * knockback_speed;
        knockback_timer--;
    }
    hit_timer--;
    if (hit_timer <= 0)
    {
        is_hit = false;
    }
    exit;
}

if (knockback_timer > 0)
{
    x += knockback_x * knockback_speed;
    y += knockback_y * knockback_speed;
    knockback_timer--;
    exit;
}

// =====================================================
// 현재 방향키 입력
// =====================================================

var move_x =
    keyboard_check(vk_right)
    - keyboard_check(vk_left);

var move_y =
    keyboard_check(vk_down)
    - keyboard_check(vk_up);


// =====================================================
// 바라보는 방향 기억
// =====================================================

if (!is_rolling && !is_attacking)
{
    if (keyboard_check(vk_right))
    {
        facing = "right";
    }

    if (keyboard_check(vk_left))
    {
        facing = "left";
    }

    if (keyboard_check(vk_up))
    {
        facing = "up";
    }

    if (keyboard_check(vk_down))
    {
        facing = "down";
    }
}


// =====================================================
// 좌우 방향 전환 (원본 스프라이트는 오른쪽을 바라봄)
// =====================================================
if (facing == "left") image_xscale = -abs(image_xscale);
else if (facing == "right") image_xscale = abs(image_xscale);

// =====================================================
// IDLE / RUN 애니메이션
// =====================================================
if (!is_rolling && !is_attacking && !is_hit && !is_dead)
{
    if (move_x != 0 || move_y != 0)
    {
        if (sprite_index != spr_player_run)
        {
            sprite_index = spr_player_run;
            image_index = 0;
        }
        image_speed = 0.2;
    }
    else
    {
        if (sprite_index != spr_player_idle)
        {
            sprite_index = spr_player_idle;
            image_index = 0;
        }
        image_speed = 0.15;
    }
}

// =====================================================
// X키 - 8방향 구르기
// =====================================================

if (keyboard_check_pressed(ord("X")) && !is_rolling && !is_drinking_potion)
{
    roll_x = move_x;
    roll_y = move_y;

    if (roll_x == 0 && roll_y == 0)
    {
        if (facing == "right")
        {
            roll_x = 1;
        }

        if (facing == "left")
        {
            roll_x = -1;
        }

        if (facing == "up")
        {
            roll_y = -1;
        }

        if (facing == "down")
        {
            roll_y = 1;
        }
    }

    var roll_length =
        point_distance(
            0,
            0,
            roll_x,
            roll_y
        );

    if (roll_length > 0)
    {
        roll_x /= roll_length;
        roll_y /= roll_length;
    }

    // 공격 도중 회피하면 현재 콤보를 취소
    is_attacking = false;
    combo_step = 0;
    combo_queued = false;
    combo_hit_mask = 0;

    is_rolling = true;
    is_invincible = true;

    roll_timer = 8;

    audio_play_sound(
        snd_player_roll,
        1,
        false
    );
}


// =====================================================
// 구르기 / 일반 이동
// =====================================================

if (is_rolling)
{
    x += roll_x * roll_speed;
    y += roll_y * roll_speed;

    roll_timer--;

    if (roll_timer <= 0)
    {
        is_rolling = false;
        is_invincible = false;
    }
}
else if (!is_attacking && !keyboard_check_pressed(ord("Z")))
{
    var next_dx = move_x * move_speed;
    var next_dy = move_y * move_speed;

    // X축 충돌 검사
    if (
        !place_meeting(x + next_dx, y, obj_slime)
        && !place_meeting(x + next_dx, y, obj_npc)
        && !place_meeting(x + next_dx, y, obj_save_point)
    )
    {
        x += next_dx;
    }

    // Y축 충돌 검사
    if (
        !place_meeting(x, y + next_dy, obj_slime)
        && !place_meeting(x, y + next_dy, obj_npc)
        && !place_meeting(x, y + next_dy, obj_save_point)
    )
    {
        y += next_dy;
    }
}


// =====================================================
// Z키 - 3단 콤보 / 총 8회 타격
// Attack 1: 4프레임 (1타)
// Attack 2: 4, 7, 13프레임 (3타)
// Attack 3: 6, 8, 10, 12프레임 (4타)
// =====================================================

if (keyboard_check_pressed(ord("Z")) && !is_rolling && !is_drinking_potion)
{
    if (!is_attacking)
    {
        is_attacking = true;
        combo_step = 1;
        combo_queued = false;
        combo_hit_mask = 0;

        sprite_index = spr_player_attack1;
        image_index = 0;
        image_speed = combo_speed;

        audio_play_sound(snd_sword_swing, 1, false);
        audio_play_sound(snd_player_attack, 1, false);
    }
    else if (combo_step < 3)
    {
        combo_queued = true;
    }
}

if (is_attacking)
{
    // GameMaker image_index는 0부터 시작함
    var combo_frames = [];

    switch (combo_step)
    {
        case 1:
            combo_frames = [3];
            break;

        case 2:
            combo_frames = [3, 6, 12];
            break;

        case 3:
            combo_frames = [5, 7, 9, 11];
            break;
    }

    var current_frame = floor(image_index);

    for (var hit_i = 0; hit_i < array_length(combo_frames); hit_i++)
    {
        var hit_bit = 1 << hit_i;

        if (current_frame >= combo_frames[hit_i]
            && (combo_hit_mask & hit_bit) == 0)
        {
            combo_hit_mask |= hit_bit;

            // 마지막 8번째 타격만 강한 넉백
            var last_hit = (combo_step == 3 && hit_i == 3);
            scr_combo_hit(id, last_hit ? 3 : 1);
        }
    }

    // 애니메이션 종료 시 다음 콤보로 연결
    if (image_index >= image_number - 1)
    {
        if (combo_queued && combo_step < 3)
        {
            combo_step++;
            combo_queued = false;
            combo_hit_mask = 0;

            if (combo_step == 2) sprite_index = spr_player_attack2;
            if (combo_step == 3) sprite_index = spr_player_attack3;

            image_index = 0;
            image_speed = combo_speed;

            audio_play_sound(snd_sword_swing, 1, false);
            audio_play_sound(snd_player_attack, 1, false);
        }
        else
        {
            is_attacking = false;
            combo_step = 0;
            combo_queued = false;
            combo_hit_mask = 0;
            image_speed = 0;
        }
    }
}


// =====================================================
// C키 - 포션 사용 + 힐 애니메이션
// =====================================================
if (keyboard_check_pressed(ord("C")))
{
    if (health_potion > 0 && hp < max_hp
        && !is_attacking && !is_rolling
        && !is_drinking_potion && !is_dead && !is_hit)
    {
        health_potion -= 1;
        hp = min(hp + potion_heal, max_hp);

        is_drinking_potion = true;
        potion_timer = potion_time;
        // 힐 이펙트는 Draw 이벤트에서 재생함.
        // 플레이어의 현재 스프라이트는 유지.

        audio_play_sound(snd_potion_use, 1, false);
        show_debug_message("Health Potion used! HP: " + string(hp));
    }
}

// =====================================================
// E키 - 마법사 상인 대화 / 거래
// =====================================================

var npc = instance_nearest(x, y, obj_npc);

if (npc != noone)
{
    var npc_distance = point_distance(x, y, npc.x, npc.y);

    if (npc_distance <= 50)
    {
        var nearest_priest = instance_nearest(
            x, y, obj_save_point
        );

        var merchant_is_closer =
            (nearest_priest == noone)
            || (
                npc_distance < point_distance(
                    x, y,
                    nearest_priest.x,
                    nearest_priest.y
                )
            );

        // =============================================
        // 마법사 상호작용 애니메이션
        // =============================================

        if (
            merchant_is_closer
            && (
                keyboard_check_pressed(ord("E"))
                || (
                    dialogue_open
                    && (
                        keyboard_check_pressed(ord("F"))
                        || keyboard_check_pressed(ord("B"))
                        || keyboard_check_pressed(ord("U"))
                    )
                )
            )
        )
        {
            npc.is_interacting = true;
            npc.sprite_index = spr_wizard_interact;
            npc.image_index = 0;
            npc.image_speed = 0.20;
        }

        // =============================================
        // E - 대화 열기 / 닫기
        // =============================================

        if (
            keyboard_check_pressed(ord("E"))
            && merchant_is_closer
        )
        {
            if (!dialogue_open)
            {
                dialogue_open = true;

                dialogue_text =
                    "Ah, a traveler! Need some magic?";

                audio_play_sound(
                    snd_shop_open, 1, false
                );
            }
            else
            {
                dialogue_open = false;

                audio_play_sound(
                    snd_ui_click, 1, false
                );
            }
        }

        // =============================================
        // F - Slime Gel 판매 (+5 Gold)
        // =============================================

        if (
            dialogue_open
            && merchant_is_closer
            && keyboard_check_pressed(ord("F"))
        )
        {
            if (slime_gel > 0)
            {
                slime_gel -= 1;
                gold += 5;

                dialogue_text =
                    "Excellent! I can use this for spells!";

                audio_play_sound(
                    snd_item_sell, 1, false
                );

                show_debug_message(
                    "Gold: " + string(gold)
                );
            }
            else
            {
                dialogue_text =
                    "Bring me some Slime Gel, traveler!";
            }
        }

        // =============================================
        // B - Health Potion 구매 (10 Gold)
        // =============================================

        if (
            dialogue_open
            && merchant_is_closer
            && keyboard_check_pressed(ord("B"))
        )
        {
            if (gold >= 10)
            {
                gold -= 10;
                health_potion += 1;

                dialogue_text =
                    "A healing potion! Use it wisely.";

                audio_play_sound(
                    snd_ui_click, 1, false
                );

                show_debug_message(
                    "Health Potion: "
                    + string(health_potion)
                );
            }
            else
            {
                dialogue_text =
                    "Even magic isn't free, my friend!";
            }
        }

        // =============================================
        // U - 랜덤 강화 카드
        // =============================================

        if (
            dialogue_open
            && merchant_is_closer
            && keyboard_check_pressed(ord("U"))
        )
        {
            if (gold >= upgrade_cost)
            {
                gold -= upgrade_cost;

                audio_play_sound(
                    snd_ui_click, 1, false
                );

                // 서로 다른 카드 3개 생성
                card1 = irandom(4);
                card2 = irandom(4);

                while (card2 == card1)
                {
                    card2 = irandom(4);
                }

                card3 = irandom(4);

                while (
                    card3 == card1
                    || card3 == card2
                )
                {
                    card3 = irandom(4);
                }

                dialogue_text =
                    "Choose your magical blessing!";

                upgrade_open = true;
                dialogue_open = false;
            }
            else
            {
                dialogue_text =
                    "You need more gold for my magic!";
            }
        }
    }
    else
    {
        // 상인에게서 멀어지면 대화 종료
        dialogue_open = false;
    }
}

// =====================================================
// 프리스트: E 대화 / F 기도(힐 + 세이브) / E 대화 종료
// =====================================================
var priest = instance_nearest(x, y, obj_save_point);
if (priest != noone)
{
    var priest_distance = point_distance(x, y, priest.x, priest.y);
    if (priest_distance <= priest.interact_range)
    {
        // 상인 대화와 동시에 열리지 않도록 제한
        if (!dialogue_open && !upgrade_open && !is_attacking && !is_rolling && (instance_nearest(x, y, obj_npc) == noone || point_distance(x, y, priest.x, priest.y) <= point_distance(x, y, instance_nearest(x, y, obj_npc).x, instance_nearest(x, y, obj_npc).y)))
        {
            if (keyboard_check_pressed(ord("E")))
            {
                priest.priest_dialogue_open = !priest.priest_dialogue_open;
                audio_play_sound(snd_ui_click, 1, false);
            }
            if (priest.priest_dialogue_open && keyboard_check_pressed(ord("F")))
            {
                priest.priest_dialogue_open = false;
                priest.is_healing = true;
                priest.sprite_index = spr_priest_heal;
                priest.image_index = 0;
                priest.image_speed = 0.20;

                hp = max_hp;
                last_hp = hp;
                save_x = priest.x;
                save_y = priest.y + 36; // 프리스트 발밑에서 조금 아래에 부활
                has_save_point = true;
                priest.activated = true;
                audio_play_sound(snd_save_point, 1, false);
                show_debug_message("HP RESTORED! CHECKPOINT SAVED!");
            }
        }
    }
    else
    {
        priest.priest_dialogue_open = false;
    }
}


// =====================================================
// 카메라 - 플레이어 중앙 고정
// =====================================================

var cam = view_camera[0];

var cam_w =
    camera_get_view_width(cam);

var cam_h =
    camera_get_view_height(cam);

camera_set_view_pos(
    cam,
    x - cam_w * 0.5,
    y - cam_h * 0.5
);