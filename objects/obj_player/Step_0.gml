// =====================================================
// 사망 확인
// =====================================================

if (hp <= 0)
{
    hp = 0;
    is_dead = true;

    sprite_index = spr_player_grave;
    image_speed = 0;
    image_index = 0;
}


// =====================================================
// 죽었을 때
// =====================================================

if (is_dead)
{
    if (keyboard_check_pressed(ord("R")))
    {
        // Gold 8% 손실
        var gold_loss = floor(gold * 0.08);
        gold -= gold_loss;

        // 저장된 위치로 이동
        x = save_x;
        y = save_y;

        // HP 완전 회복
        hp = max_hp;

        // 상태 초기화
        is_dead = false;

        is_attacking = false;
        is_rolling = false;
        is_invincible = false;
        is_drinking_potion = false;

        attack_timer = 0;
        roll_timer = 0;
        potion_timer = 0;

        knockback_timer = 0;
        knockback_x = 0;
        knockback_y = 0;

        // UI 닫기
        dialogue_open = false;
        upgrade_open = false;
        inventory_open = false;

        show_debug_message(
            "RESPAWNED! Lost "
            + string(gold_loss)
            + " Gold"
        );
    }

    if (keyboard_check_pressed(vk_escape))
    {
        game_end();
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
// 포션 사용 중
// =====================================================

if (is_drinking_potion)
{
    // 현재 방향에 맞는 포션 포즈
    if (facing == "down")
    {
        sprite_index = spr_player_potion_down;
    }

    if (facing == "up")
    {
        sprite_index = spr_player_potion_up;
    }

    if (facing == "left")
    {
        sprite_index = spr_player_potion_left;
    }

    if (facing == "right")
    {
        sprite_index = spr_player_potion_right;
    }

    // 1프레임 고정
    image_speed = 0;
    image_index = 0;

    potion_timer--;

    if (potion_timer <= 0)
    {
        is_drinking_potion = false;
    }

    exit;
}


// =====================================================
// 넉백 중
// =====================================================

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

if (!is_rolling)
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
// IDLE / RUN 방향 스프라이트
// =====================================================

if (!is_rolling && !is_attacking)
{
    // 움직이는 중 = RUN
    if (move_x != 0 || move_y != 0)
    {
        if (facing == "down")
        {
            sprite_index = spr_player_run_down;
        }

        if (facing == "up")
        {
            sprite_index = spr_player_run_up;
        }

        if (facing == "left")
        {
            sprite_index = spr_player_run_left;
        }

        if (facing == "right")
        {
            sprite_index = spr_player_run_right;
        }

        image_speed = 0.2;
    }

    // 가만히 있음 = IDLE
    else
    {
        if (facing == "down")
        {
            sprite_index = spr_player_idle_down;
        }

        if (facing == "up")
        {
            sprite_index = spr_player_idle_up;
        }

        if (facing == "left")
        {
            sprite_index = spr_player_idle_left;
        }

        if (facing == "right")
        {
            sprite_index = spr_player_idle_right;
        }

        image_speed = 0;
        image_index = 0;
    }
}


// =====================================================
// X키 - 8방향 구르기
// =====================================================

if (keyboard_check_pressed(ord("X")) && !is_rolling)
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
else
{
    x += move_x * move_speed;
    y += move_y * move_speed;
}


// =====================================================
// Z키 - 검 공격
// =====================================================

if (keyboard_check_pressed(ord("Z")) && !is_rolling)
{
    var slash;

    slash = instance_create_layer(
        x,
        y,
        layer,
        obj_attack_slash
    );

    if (facing == "right")
    {
        slash.image_angle = 0;
    }

    if (facing == "left")
    {
        slash.image_angle = 180;
    }

    if (facing == "up")
    {
        slash.image_angle = 90;
    }

    if (facing == "down")
    {
        slash.image_angle = 270;
    }

    audio_play_sound(
        snd_sword_swing,
        1,
        false
    );

    audio_play_sound(
        snd_player_attack,
        1,
        false
    );

    is_attacking = true;
    attack_timer = 10;
}


// =====================================================
// 공격 시간
// =====================================================

if (attack_timer > 0)
{
    attack_timer--;
}
else
{
    is_attacking = false;
}


// =====================================================
// C키 - Health Potion 사용
// =====================================================

if (keyboard_check_pressed(ord("C")))
{
    if (health_potion > 0 && hp < max_hp)
    {
        health_potion -= 1;

        hp += potion_heal;

        if (hp > max_hp)
        {
            hp = max_hp;
        }

        // 포션 포즈 시작
        is_drinking_potion = true;
        potion_timer = potion_time;

        // 현재 방향 포션 Sprite
        if (facing == "down")
        {
            sprite_index = spr_player_potion_down;
        }

        if (facing == "up")
        {
            sprite_index = spr_player_potion_up;
        }

        if (facing == "left")
        {
            sprite_index = spr_player_potion_left;
        }

        if (facing == "right")
        {
            sprite_index = spr_player_potion_right;
        }

        image_speed = 0;
        image_index = 0;

        audio_play_sound(
            snd_potion_use,
            1,
            false
        );

        show_debug_message(
            "Health Potion used! HP: "
            + string(hp)
        );
    }
}


// =====================================================
// E키 - 상인 NPC 상호작용
// =====================================================

var npc = instance_nearest(
    x,
    y,
    obj_npc
);

if (npc != noone)
{
    var npc_distance =
        point_distance(
            x,
            y,
            npc.x,
            npc.y
        );

    if (npc_distance <= 50)
    {
        if (keyboard_check_pressed(ord("E")))
        {
            if (!dialogue_open)
            {
                dialogue_open = true;

                dialogue_text =
                    "Merchant\n"
                    + "F: Sell Slime Gel (+5 Gold)\n"
                    + "B: Buy Health Potion (10 Gold)\n"
                    + "U: Random Upgrade ("
                    + string(upgrade_cost)
                    + " Gold)";

                audio_play_sound(
                    snd_shop_open,
                    1,
                    false
                );
            }
            else
            {
                dialogue_open = false;

                audio_play_sound(
                    snd_ui_click,
                    1,
                    false
                );
            }
        }


        // =================================================
        // F - Slime Gel 판매
        // =================================================

        if (
            dialogue_open
            && keyboard_check_pressed(ord("F"))
        )
        {
            if (slime_gel > 0)
            {
                slime_gel -= 1;
                gold += 5;

                audio_play_sound(
                    snd_item_sell,
                    1,
                    false
                );

                dialogue_text =
                    "Sold Slime Gel!\n"
                    + "+5 Gold\n"
                    + "F: Sell More\n"
                    + "B: Buy Potion\n"
                    + "U: Random Upgrade";

                show_debug_message(
                    "Gold: "
                    + string(gold)
                );
            }
            else
            {
                dialogue_text =
                    "You don't have any Slime Gel.";
            }
        }


        // =================================================
        // B - Health Potion 구매
        // =================================================

        if (
            dialogue_open
            && keyboard_check_pressed(ord("B"))
        )
        {
            if (gold >= 10)
            {
                gold -= 10;
                health_potion += 1;

                audio_play_sound(
                    snd_ui_click,
                    1,
                    false
                );

                dialogue_text =
                    "Bought Health Potion!\n"
                    + "-10 Gold\n"
                    + "Potion: "
                    + string(health_potion);

                show_debug_message(
                    "Health Potion: "
                    + string(health_potion)
                );
            }
            else
            {
                dialogue_text =
                    "Not enough Gold!\n"
                    + "Health Potion costs 10 Gold.";
            }
        }


        // =================================================
        // U - 랜덤 강화
        // =================================================

        if (
            dialogue_open
            && keyboard_check_pressed(ord("U"))
        )
        {
            if (gold >= upgrade_cost)
            {
                gold -= upgrade_cost;

                audio_play_sound(
                    snd_ui_click,
                    1,
                    false
                );

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

                upgrade_open = true;
                dialogue_open = false;
            }
            else
            {
                dialogue_text =
                    "Not enough Gold!\n"
                    + "Random Upgrade costs "
                    + string(upgrade_cost)
                    + " Gold.";
            }
        }
    }
    else
    {
        dialogue_open = false;
    }
}


// =====================================================
// 세이브 포인트
// =====================================================

var save_point = instance_nearest(
    x,
    y,
    obj_save_point
);

if (save_point != noone)
{
    var save_distance =
        point_distance(
            x,
            y,
            save_point.x,
            save_point.y
        );

    if (save_distance <= 50)
    {
        if (
            keyboard_check_pressed(ord("E"))
            && !save_point.activated
        )
        {
            // 세이브 위치 저장
            save_x = save_point.x;
            save_y = save_point.y;

            has_save_point = true;

            // HP 회복
            hp = max_hp;

            // 세이브포인트 활성화
            save_point.activated = true;

            // Frame 1 = 불 켜짐
            save_point.image_speed = 0;
            save_point.image_index = 1;

            // 효과음
            audio_play_sound(
                snd_save_point,
                1,
                false
            );

            show_debug_message(
                "CHECKPOINT SAVED!"
            );
        }
    }
}


// =====================================================
// ESC키 - 게임 종료
// =====================================================

if (keyboard_check_pressed(vk_escape))
{
    game_end();
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