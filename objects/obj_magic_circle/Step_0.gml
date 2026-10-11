// 일시정지
var pm = instance_find(obj_pause_menu, 0);
if (pm != noone && pm.menu_open) exit;

var pl = instance_find(obj_player, 0);
if (pl != noone && pl.inventory_open) exit;

// 소환한 보스가 사라지면 마법진 제거
if (boss_id != noone)
{
    if (!instance_exists(boss_id))
    {
        instance_destroy();
        exit;
    }

    if (boss_id.is_dead)
    {
        instance_destroy();
        exit;
    }
}

// 이미 실행한 마법진은 중복 실행 방지
if (activated) exit;

// 대기 시간
warning_timer--;

if (warning_timer > 0) exit;

activated = true;

// =====================================
// 해골 소환
// =====================================
if (circle_type == "summon")
{
    var monster = noone;

    switch (summon_type)
    {
        case 0:
            monster = instance_create_depth(
                x, y, depth - 1, obj_skeleton
            );
            break;

        case 1:
            monster = instance_create_depth(
                x, y, depth - 1, obj_skeleton_archer
            );
            break;

        case 2:
            monster = instance_create_depth(
                x, y, depth - 1, obj_skeleton_knight
            );
            break;
    }

    if (monster != noone)
    {
        monster.boss_id = boss_id;
    }

    instance_destroy();
    exit;
}

// =====================================
// 2페이즈 마법 폭발
// =====================================
if (circle_type == "explosion")
{
    var explosion = instance_create_depth(
        x, y, depth - 1, obj_magic_explosion
    );

    explosion.boss_id = boss_id;

    instance_destroy();
    exit;
}