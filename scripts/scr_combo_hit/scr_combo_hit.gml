/// scr_combo_hit
/// 슬라임 + 박쥐 + 오크
/// 플레이어 3단 콤보 공격

function scr_combo_hit(_player, _combo)
{
    var range = 75;
    var half_width = 35;

    // ==========================================
    // 1. 슬라임 공격
    // ==========================================

    with (obj_slime)
    {
        if (state == "dying" || hp <= 0) continue;

        var dx = x - _player.x;
        var dy = y - _player.y;
        var in_range = false;

        switch (_player.facing)
        {
            case "right":
                in_range = dx >= 0 && dx <= range
                    && abs(dy) <= half_width;
                break;

            case "left":
                in_range = dx <= 0 && dx >= -range
                    && abs(dy) <= half_width;
                break;

            case "up":
                in_range = dy <= 0 && dy >= -range
                    && abs(dx) <= half_width;
                break;

            case "down":
                in_range = dy >= 0 && dy <= range
                    && abs(dx) <= half_width;
                break;
        }

        if (!in_range) continue;

        // 데미지
        hp -= _player.attack_damage;

        // 체력바 3초 표시
        hp_bar_timer = room_speed * 3;

        // 피격 효과음
        audio_play_sound(snd_slime_hit, 1, false);

        // 넉백 방향
        var dir = point_direction(
            _player.x, _player.y, x, y
        );

        knockback_x = lengthdir_x(1, dir);
        knockback_y = lengthdir_y(1, dir);

        knockback_timer = (_combo == 3) ? 10 : 5;

        // 공격 취소
        melee_attacking = false;
        attack_hit_done = false;

        // ======================================
        // 슬라임 사망
        // ======================================

        if (hp <= 0)
        {
            hp = 0;
            state = "dying";

            is_transforming = false;
            knockback_timer = 0;
            hit_anim_timer = 0;

            sprite_index = is_enraged
                ? spr_slime_night_death
                : spr_slime_death;

            image_index = 0;
            image_speed = 0.25;

            death_anim_timer = 16;

            audio_play_sound(
                snd_slime_death, 1, false
            );
        }
        else
        {
            // ==================================
            // 슬라임 피격
            // ==================================

            state = "idle";
            is_transforming = false;

            hit_anim_timer = 16;

            sprite_index = is_enraged
                ? spr_slime_night_hit
                : spr_slime_hit;

            image_index = 0;
            image_speed = 0.25;
        }
    }

    // ==========================================
    // 2. 박쥐 공격
    // ==========================================

    with (obj_bat)
    {
        if (state == "dying" || hp <= 0) continue;

        var dx = x - _player.x;
        var dy = y - _player.y;
        var in_range = false;

        switch (_player.facing)
        {
            case "right":
                in_range = dx >= 0 && dx <= range
                    && abs(dy) <= half_width;
                break;

            case "left":
                in_range = dx <= 0 && dx >= -range
                    && abs(dy) <= half_width;
                break;

            case "up":
                in_range = dy <= 0 && dy >= -range
                    && abs(dx) <= half_width;
                break;

            case "down":
                in_range = dy >= 0 && dy <= range
                    && abs(dx) <= half_width;
                break;
        }

        if (!in_range) continue;

        // ======================================
        // 박쥐 데미지
        // ======================================

        hp -= _player.attack_damage;

        hp_bar_timer = room_speed * 3;

        audio_play_sound(
            snd_slime_hit, 1, false
        );

        // ======================================
        // 박쥐 넉백
        // ======================================

        var dir = point_direction(
            _player.x, _player.y, x, y
        );

        knockback_x = lengthdir_x(1, dir);
        knockback_y = lengthdir_y(1, dir);

        knockback_timer = (_combo == 3) ? 10 : 5;

        // ======================================
        // 박쥐 사망
        // ======================================

        if (hp <= 0)
        {
            hp = 0;
            state = "dying";

            is_transforming = false;
            knockback_timer = 0;
            hit_flash_timer = 0;

            sprite_index = is_enraged
                ? spr_bat_night_death
                : spr_bat_death;

            image_index = 0;
            image_speed = 0.20;

            audio_play_sound(
                snd_slime_death, 1, false
            );
        }
        else
        {
            // ==================================
            // 박쥐 피격
            // ==================================

            state = "hit";

            is_transforming = false;
            hit_flash_timer = 8;

            sprite_index = is_enraged
                ? spr_bat_night_hit
                : spr_bat_hit;

            image_index = 0;
            image_speed = 0.25;
        }
    }

    // ==========================================
    // 3. 오크 공격
    // ==========================================

    with (obj_orc)
    {
        if (state == "dying" || hp <= 0) continue;

        var dx = x - _player.x;
        var dy = y - _player.y;
        var in_range = false;

        switch (_player.facing)
        {
            case "right":
                in_range = dx >= 0 && dx <= range
                    && abs(dy) <= half_width;
                break;

            case "left":
                in_range = dx <= 0 && dx >= -range
                    && abs(dy) <= half_width;
                break;

            case "up":
                in_range = dy <= 0 && dy >= -range
                    && abs(dx) <= half_width;
                break;

            case "down":
                in_range = dy >= 0 && dy <= range
                    && abs(dx) <= half_width;
                break;
        }

        if (!in_range) continue;

        // ======================================
        // 오크 데미지
        // ======================================

        hp -= _player.attack_damage;

        hp_bar_timer = room_speed * 3;

        audio_play_sound(
            snd_slime_hit, 1, false
        );

        // ======================================
        // 오크 넉백
        // ======================================

        var dir = point_direction(
            _player.x, _player.y, x, y
        );

        knockback_x = lengthdir_x(1, dir);
        knockback_y = lengthdir_y(1, dir);

        knockback_timer = (_combo == 3) ? 10 : 5;

        // ======================================
        // 오크 사망
        // ======================================

        if (hp <= 0)
        {
            hp = 0;
            state = "dying";

            knockback_timer = 0;
            hit_flash_timer = 0;

            sprite_index = spr_orc_death;
            image_index = 0;
            image_speed = 0.20;

            audio_play_sound(
                snd_slime_death, 1, false
            );
        }
        else
        {
            // ==================================
            // 오크 피격
            // ======================================

            state = "hit";
            hit_flash_timer = 8;

            sprite_index = spr_orc_hurt;
            image_index = 0;
            image_speed = 0.25;
        }
    }
	    // ==========================================
    // 4. 해골 검사 공격
    // ==========================================

    with (obj_skeleton)
    {
        if (state == "dying" || hp <= 0) continue;

        var dx = x - _player.x;
        var dy = y - _player.y;
        var in_range = false;

        switch (_player.facing)
        {
            case "right":
                in_range = dx >= 0 && dx <= range
                    && abs(dy) <= half_width;
                break;

            case "left":
                in_range = dx <= 0 && dx >= -range
                    && abs(dy) <= half_width;
                break;

            case "up":
                in_range = dy <= 0 && dy >= -range
                    && abs(dx) <= half_width;
                break;

            case "down":
                in_range = dy >= 0 && dy <= range
                    && abs(dx) <= half_width;
                break;
        }

        if (!in_range) continue;

        hp -= _player.attack_damage;
        hp_bar_timer = room_speed * 3;

        audio_play_sound(snd_slime_hit, 1, false);

        var dir = point_direction(
            _player.x, _player.y, x, y
        );

        knockback_x = lengthdir_x(1, dir);
        knockback_y = lengthdir_y(1, dir);
        knockback_timer = (_combo == 3) ? 10 : 5;

        if (hp <= 0)
        {
            hp = 0;
            state = "dying";
            is_dead = true;

            knockback_timer = 0;
            hit_anim_timer = 0;

            sprite_index = spr_skeleton_death;
            image_index = 0;
            image_speed = 8 / room_speed;

            death_anim_timer = max(
                1,
                ceil(sprite_get_number(spr_skeleton_death) / image_speed)
            );

            audio_play_sound(snd_slime_death, 1, false);
        }
        else
        {
            state = "hit";
            hit_anim_timer = 12;
            hit_flash_timer = 8;

            sprite_index = spr_skeleton_hit;
            image_index = 0;
            image_speed = 0.25;
        }
    }
	// ==========================================
// 5. 해골 궁수 공격 판정
// ==========================================

with (obj_skeleton_archer)
{
    if (state == "dying" || hp <= 0) continue;

    var dx = x - _player.x;
    var dy = y - _player.y;
    var in_range = false;

    switch (_player.facing)
    {
        case "right":
            in_range = dx >= 0 && dx <= range
                && abs(dy) <= half_width;
            break;

        case "left":
            in_range = dx <= 0 && dx >= -range
                && abs(dy) <= half_width;
            break;

        case "up":
            in_range = dy <= 0 && dy >= -range
                && abs(dx) <= half_width;
            break;

        case "down":
            in_range = dy >= 0 && dy <= range
                && abs(dx) <= half_width;
            break;
    }

    if (!in_range) continue;

    hp -= _player.attack_damage;
    hp_bar_timer = room_speed * 3;

    audio_play_sound(snd_slime_hit, 1, false);

    var dir = point_direction(
        _player.x, _player.y, x, y
    );

    knockback_x = lengthdir_x(1, dir);
    knockback_y = lengthdir_y(1, dir);
    knockback_timer = (_combo == 3) ? 10 : 5;

    if (hp <= 0)
    {
        hp = 0;
        state = "dying";
        is_dead = true;

        knockback_timer = 0;
        hit_anim_timer = 0;

        sprite_index = spr_skeleton_archer_death;
        image_index = 0;
        image_speed = 8 / room_speed;

        death_anim_timer = max(
            1,
            ceil(sprite_get_number(spr_skeleton_archer_death) / image_speed)
        );

        audio_play_sound(snd_slime_death, 1, false);
    }
    else
    {
        state = "hit";
        hit_anim_timer = 12;
        hit_flash_timer = 8;

        sprite_index = spr_skeleton_archer_hit;
        image_index = 0;
        image_speed = 0.25;
    }
}
    // ==========================================
    // 6. 해골 기사 공격 판정
    // ==========================================

    with (obj_skeleton_knight)
    {
        if (state == "dying" || hp <= 0) continue;

        var dx = x - _player.x;
        var dy = y - _player.y;
        var in_range = false;

        switch (_player.facing)
        {
            case "right":
                in_range = dx >= 0 && dx <= range
                    && abs(dy) <= half_width;
                break;

            case "left":
                in_range = dx <= 0 && dx >= -range
                    && abs(dy) <= half_width;
                break;

            case "up":
                in_range = dy <= 0 && dy >= -range
                    && abs(dx) <= half_width;
                break;

            case "down":
                in_range = dy >= 0 && dy <= range
                    && abs(dx) <= half_width;
                break;
        }

        if (!in_range) continue;

        // 데미지
        hp -= _player.attack_damage;
        hp_bar_timer = room_speed * 3;

        audio_play_sound(snd_slime_hit, 1, false);

        // 넉백
        var dir = point_direction(
            _player.x, _player.y, x, y
        );

        knockback_x = lengthdir_x(1, dir);
        knockback_y = lengthdir_y(1, dir);

        knockback_timer = (_combo == 3) ? 10 : 5;

        // 사망
        if (hp <= 0)
        {
            hp = 0;
            state = "dying";
            is_dead = true;

            knockback_timer = 0;
            hit_anim_timer = 0;
            hit_flash_timer = 0;

            sprite_index = spr_skeleton_knight_death;
            image_index = 0;
            image_speed = 8 / room_speed;

            death_anim_timer = max(
                1,
                ceil(
                    sprite_get_number(spr_skeleton_knight_death)
                    / image_speed
                )
            );

            audio_play_sound(snd_slime_death, 1, false);
        }
        else
        {
            // 피격 애니메이션
            state = "hit";
            hit_anim_timer = 12;
            hit_flash_timer = 8;

            sprite_index = spr_skeleton_knight_hit;
            image_index = 0;
            image_speed = 0.25;
        }
    }
	    // ==========================================
    // 7. 네크로맨서 보스 공격 판정
    // ==========================================

    with (obj_necromancer)
    {
        if (is_dead || state == "dying" || hp <= 0)
            continue;

        var dx = x - _player.x;
        var dy = y - _player.y;
        var in_range = false;

        switch (_player.facing)
        {
            case "right":
                in_range = dx >= 0 && dx <= range
                    && abs(dy) <= half_width;
                break;

            case "left":
                in_range = dx <= 0 && dx >= -range
                    && abs(dy) <= half_width;
                break;

            case "up":
                in_range = dy <= 0 && dy >= -range
                    && abs(dx) <= half_width;
                break;

            case "down":
                in_range = dy >= 0 && dy <= range
                    && abs(dx) <= half_width;
                break;
        }

        if (!in_range) continue;

        // 플레이어 공격력 적용
        hp = max(0, hp - _player.attack_damage);

        // HP 바 표시
        hp_bar_timer = room_speed * 3;

        // 피격 효과음
        audio_play_sound(snd_slime_hit, 1, false);

        // 넉백 방향
        var dir = point_direction(
            _player.x, _player.y, x, y
        );

        knockback_x = lengthdir_x(1, dir);
        knockback_y = lengthdir_y(1, dir);

        // 보스는 넉백 저항이 높음
        knockback_timer = (_combo == 3) ? 5 : 2;

        if (hp <= 0)
        {
            // 사망 처리는 보스 Step 이벤트에서 실행
            hp = 0;
            knockback_timer = 0;
            hit_anim_timer = 0;
        }
        else
        {
            // 피격 애니메이션
            hit_anim_timer = 8;
            hit_flash_timer = 8;

            sprite_index = spr_necro_hit;
            image_index = 0;
            image_speed = 0.25;
        }
    }
}