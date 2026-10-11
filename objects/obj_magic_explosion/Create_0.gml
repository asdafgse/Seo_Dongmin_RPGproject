// 폭발 설정
boss_id = noone;

damage = 2;
damage_radius = 55;
damage_done = false;

// 폭발 애니메이션
sprite_index = spr_magic_explosion;
image_index = 0;
image_speed = 8 / room_speed;

// 애니메이션 종료 시간
life_timer = max(1, ceil(image_number / image_speed));

// 스프라이트 표시
image_alpha = 1;
image_blend = c_white;