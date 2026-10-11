/// obj_controls_sign - Step

var pl = instance_find(obj_player, 0);

if (pl == noone)
{
    sign_open = false;
    exit;
}

if (pl.is_dead)
{
    sign_open = false;
    exit;
}

// 일시정지 메뉴가 열려 있으면 조작 불가
var pm = instance_find(obj_pause_menu, 0);

if (pm != noone && pm.menu_open)
{
    exit;
}

// 플레이어와 거리 계산
var dist = point_distance(x, y, pl.x, pl.y);
var nearby = dist <= read_distance;

// 멀어지면 자동으로 닫기
if (!nearby)
{
    sign_open = false;
}

// E키로 열기 / 닫기
if (nearby && keyboard_check_pressed(ord("E")))
{
    // NPC 대화 중에는 표지판을 열지 않음
    if (!pl.dialogue_open)
    {
        sign_open = !sign_open;
    }
}