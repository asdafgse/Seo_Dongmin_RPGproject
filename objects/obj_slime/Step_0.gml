// ========================
// 피격 넉백 중
// ========================

if (knockback_timer > 0)
{
    x += knockback_x * knockback_speed;
    y += knockback_y * knockback_speed;

    knockback_timer--;

    // 넉백 중에는 공격 행동 중지
    exit;
}


// ========================
// 플레이어 찾기
// ========================

var player = instance_nearest(x, y, obj_player);

if (player != noone)
{
    var dist = point_distance(
        x,
        y,
        player.x,
        player.y
    );


    // ========================
    // IDLE
    // ========================

    if (state == "idle")
    {
        image_blend = c_white;

        if (dist <= detect_range)
        {
            state = "charge";
            charge_timer = charge_time;
        }
    }


    // ========================
    // CHARGE
    // ========================

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


            image_blend = c_white;

            state = "dash";
            dash_timer = dash_time;
        }
    }


    // ========================
    // DASH
    // ========================

    else if (state == "dash")
    {
        image_blend = c_white;


        // 돌진 이동
        x += dash_x;
        y += dash_y;

        dash_timer--;


        // ========================
        // 플레이어 충돌
        // ========================

        if (place_meeting(x, y, obj_player))
        {
            var hit_player = instance_place(
                x,
                y,
                obj_player
            );


            if (hit_player != noone)
            {
                // ========================
                // 플레이어가 무적이 아닐 때
                // ========================

                if (
                    !hit_player.is_invincible
                    && hit_player.hp > 0
                )
                {
                    // ========================
                    // 방어 확률
                    // DEF 1 = 5%
                    // 최대 50%
                    // ========================

                    var block_chance =
                        hit_player.defense * 5;


                    if (block_chance > 50)
                    {
                        block_chance = 50;
                    }


                    var block_roll = irandom(99);


                    // ========================
                    // 방어 성공
                    // ========================

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


                    // ========================
                    // 방어 실패
                    // ========================

                    else
                    {
                        // ========================
                        // 플레이어 데미지
                        // ========================

                        hit_player.hp -= 1;


                        // ========================
                        // 플레이어 넉백
                        // 슬라임에서 플레이어 방향
                        // ========================

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


                        // ========================
                        // 플레이어 사망
                        // ========================

                        if (hit_player.hp <= 0)
                        {
                            hit_player.hp = 0;

                            show_debug_message(
                                "Player Dead"
                            );
                        }


                        // ========================
                        // 플레이어 생존
                        // ========================

                        else
                        {
                            show_debug_message(
                                "Player HP: "
                                + string(hit_player.hp)
                            );
                        }
                    }
                }


                // ========================
                // 공격 후 쿨다운
                // ========================

                state = "cooldown";
                cooldown_timer = cooldown_time;
            }
        }


        // ========================
        // 돌진 시간이 끝났을 때
        // ========================

        if (dash_timer <= 0)
        {
            state = "cooldown";
            cooldown_timer = cooldown_time;
        }
    }


    // ========================
    // COOLDOWN
    // ========================

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


// ========================
// 슬라임 피격 효과
// ========================

if (hit_flash_timer > 0)
{
    hit_flash_timer--;

    image_blend = c_red;
}
else
{
    if (state != "charge")
    {
        image_blend = c_white;
    }
}