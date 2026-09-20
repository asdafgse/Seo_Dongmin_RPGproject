// =====================================================
// 인벤토리 열림 - 슬라임 정지
// =====================================================

var player_pause = instance_find(obj_player, 0);

if (player_pause != noone)
{
    if (player_pause.inventory_open)
    {
        exit;
    }
}



// =====================================================
// 피격 넉백 중
// =====================================================

if (knockback_timer > 0)
{
    x += knockback_x * knockback_speed;
    y += knockback_y * knockback_speed;

    knockback_timer--;

    exit;
}



// =====================================================
// 플레이어 찾기
// =====================================================

var player = instance_nearest(
    x,
    y,
    obj_player
);


if (player != noone)
{
    var dist = point_distance(
        x,
        y,
        player.x,
        player.y
    );


    // =================================================
    // IDLE
    // =================================================

    if (state == "idle")
    {
        image_blend = c_white;


        if (dist <= detect_range)
        {
            dash_count = 0;


            // =========================================
            // 낮 = 1번 돌진
            // 밤 = 2번 돌진
            // =========================================

            if (instance_exists(obj_daynight))
            {
                if (obj_daynight.is_day)
                {
                    max_dash_count = 1;
                }
                else
                {
                    max_dash_count = 2;
                }
            }
            else
            {
                max_dash_count = 1;
            }


            state = "charge";
            charge_timer = charge_time;
        }
    }


    // =================================================
    // CHARGE
    // =================================================

    else if (state == "charge")
    {
        image_blend = c_yellow;

        charge_timer--;


        if (charge_timer <= 0)
        {
            var dir = point_direction(
                x,
                y,
                player.x,
                player.y
            );


            dash_x = lengthdir_x(
                dash_speed,
                dir
            );

            dash_y = lengthdir_y(
                dash_speed,
                dir
            );


            dash_count += 1;

            image_blend = c_white;

            state = "dash";
            dash_timer = dash_time;
        }
    }


    // =================================================
    // DASH
    // =================================================

    else if (state == "dash")
    {
        image_blend = c_white;


        x += dash_x;
        y += dash_y;

        dash_timer--;


        // =============================================
        // 플레이어 충돌
        // =============================================

        if (place_meeting(x, y, obj_player))
        {
            var hit_player = instance_place(
                x,
                y,
                obj_player
            );


            if (hit_player != noone)
            {
                // =====================================
                // 무적 상태가 아닐 때만 공격
                // =====================================

                if (
                    !hit_player.is_invincible
                    && hit_player.hp > 0
                )
                {
                    // =================================
                    // DEF 방어 확률
                    // DEF 1 = 5%
                    // 최대 50%
                    // =================================

                    var block_chance =
                        hit_player.defense * 5;


                    if (block_chance > 50)
                    {
                        block_chance = 50;
                    }


                    var block_roll = irandom(99);


                    // =================================
                    // 방어 성공
                    // =================================

                    if (block_roll < block_chance)
                    {
                        show_debug_message(
                            "BLOCKED! DEF: "
                            + string(hit_player.defense)
                            + " | Block Chance: "
                            + string(block_chance)
                            + "%"
                        );
                    }


                    // =================================
                    // 방어 실패
                    // =================================

                    else
                    {
                        // 데미지
                        hit_player.hp -= 1;


                        // =================================
                        // 플레이어 넉백
                        // =================================

                        var knock_dir = point_direction(
                            x,
                            y,
                            hit_player.x,
                            hit_player.y
                        );


                        hit_player.knockback_x =
                            lengthdir_x(
                                1,
                                knock_dir
                            );


                        hit_player.knockback_y =
                            lengthdir_y(
                                1,
                                knock_dir
                            );


                        hit_player.knockback_timer = 6;


                        // =================================
                        // 플레이어 사망
                        // =================================

                        if (hit_player.hp <= 0)
                        {
                            hit_player.hp = 0;


                            // 사망 사운드만 재생
                            audio_play_sound(
                                snd_player_death,
                                1,
                                false
                            );


                            show_debug_message(
                                "Player Dead"
                            );
                        }


                        // =================================
                        // 플레이어 생존
                        // =================================

                        else
                        {
                            // 피격 사운드
                            audio_play_sound(
                                snd_player_hit,
                                1,
                                false
                            );


                            show_debug_message(
                                "Player HP: "
                                + string(hit_player.hp)
                            );
                        }
                    }
                }


                // =====================================
                // 다음 돌진 확인
                // =====================================

                if (dash_count < max_dash_count)
                {
                    state = "redash";
                    redash_timer = redash_time;
                }
                else
                {
                    state = "cooldown";
                    cooldown_timer = cooldown_time;
                }
            }
        }


        // =============================================
        // 돌진 시간 종료
        // =============================================

        if (
            state == "dash"
            && dash_timer <= 0
        )
        {
            if (dash_count < max_dash_count)
            {
                state = "redash";
                redash_timer = redash_time;
            }
            else
            {
                state = "cooldown";
                cooldown_timer = cooldown_time;
            }
        }
    }


    // =================================================
    // 두 번째 돌진 준비
    // =================================================

    else if (state == "redash")
    {
        image_blend = c_orange;

        redash_timer--;


        if (redash_timer <= 0)
        {
            // 플레이어의 현재 위치를 다시 조준
            var redash_dir = point_direction(
                x,
                y,
                player.x,
                player.y
            );


            dash_x = lengthdir_x(
                dash_speed,
                redash_dir
            );


            dash_y = lengthdir_y(
                dash_speed,
                redash_dir
            );


            dash_count += 1;

            image_blend = c_white;

            state = "dash";
            dash_timer = dash_time;
        }
    }


    // =================================================
    // COOLDOWN
    // =================================================

    else if (state == "cooldown")
    {
        image_blend = c_white;

        cooldown_timer--;


        if (cooldown_timer <= 0)
        {
            state = "idle";
        }
    }
}



// =====================================================
// 슬라임 피격 효과
// =====================================================

if (hit_flash_timer > 0)
{
    hit_flash_timer--;

    image_blend = c_red;
}
else
{
    if (
        state != "charge"
        && state != "redash"
    )
    {
        image_blend = c_white;
    }
}