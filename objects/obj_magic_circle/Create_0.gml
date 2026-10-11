// 마법진 종류
// "summon" = 해골 소환
// "explosion" = 마법 폭발
circle_type = "summon";

// 소환한 보스
boss_id = noone;

// 마법진 대기 시간
warning_timer = room_speed * 1.5;

// 소환할 몬스터 종류
// 0 = 검사, 1 = 궁수, 2 = 기사
summon_type = irandom(2);

// 마법진 스프라이트
sprite_index = spr_magic_circle;
image_index = 0;
image_speed = 0.2;

// 실행 여부
activated = false;

// 마법진을 플레이어 뒤에 표시
depth = obj_player.depth + 10;