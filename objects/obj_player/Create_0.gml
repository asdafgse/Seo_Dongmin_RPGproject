// =====================================================
// PLAYER CREATE - TEONIA
// =====================================================

// 체력 및 능력치
max_hp = 5;
hp = max_hp;

attack_damage = 1;
defense = 0;
move_speed = 4;
potion_heal = 2;

// 이동 방향
facing = "down";

// 기본 애니메이션
sprite_index = spr_player_idle;
image_index = 0;
image_speed = 0.15;

// =====================================================
// 공격 - 8타 콤보
// =====================================================

is_attacking = false;
attack_timer = 0;

combo_step = 0;
combo_queued = false;
combo_speed = 0.25;
combo_hit_mask = 0;

// =====================================================
// 구르기
// =====================================================

is_rolling = false;
roll_timer = 0;
roll_speed = 8;
roll_x = 0;
roll_y = 0;

is_invincible = false;

// =====================================================
// 피격 애니메이션
// =====================================================

is_hit = false;
hit_timer = 0;
hit_duration = 12;
last_hp = hp;

// =====================================================
// 사망
// =====================================================

is_dead = false;

game_over_sound_played = false;

// =====================================================
// 대화
// =====================================================

dialogue_open = false;
dialogue_text = "";

// =====================================================
// 아이템 및 인벤토리
// =====================================================

slime_gel = 0;
health_potion = 3;
inventory_open = false;
gold = 0;

// =====================================================
// 상인 업그레이드
// =====================================================

upgrade_open = false;
upgrade_cost = 15;

card1 = -1;
card2 = -1;
card3 = -1;

// =====================================================
// 피격 넉백
// =====================================================

knockback_x = 0;
knockback_y = 0;
knockback_timer = 0;
knockback_speed = 6;

// =====================================================
// 세이브 포인트
// =====================================================

save_x = x;
save_y = y;
has_save_point = false;

// =====================================
// 포션 힐 애니메이션
// =====================================
is_drinking_potion = false;
potion_timer = 0;
potion_time = 16;

heal_animation_speed = 0.25;

bat_wing = 0;

// 오크 가죽 보유 수량
orc_hide = 0;
// 봉인석 보유 여부
has_seal_stone = false;

// =====================================================
// CAPTAIN'S FINAL TRIAL - QUEST SYSTEM
// =====================================================

// 퀘스트 상태
// 0 = 시작 전
// 1 = 진행 중
// 2 = 완료 (봉인석 지급)
captain_quest = 0;

// 몬스터 처치 횟수
quest_slime_kills = 0;
quest_bat_kills = 0;
quest_orc_kills = 0;

// 몬스터 처치 목표
quest_slime_target = 10;
quest_bat_target = 7;
quest_orc_target = 5;

// 재료 수집 목표
quest_slime_gel_target = 10;
quest_bat_wing_target = 5;
quest_orc_hide_target = 3;

// Knight Quest
knight_quest = 0; // 0: 시작 전, 1: 진행 중, 2: 완료

archer_quest = 0;
archer_bat_kills = 0;

// Add at the END of obj_player Create, do not replace it.
spearman_quest = 0;
spearman_orc_kills = 0;
