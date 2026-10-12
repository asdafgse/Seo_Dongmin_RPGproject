/// obj_boss_portal - Step

// 쿨다운
if (portal_cooldown > 0)
{
    portal_cooldown--;
}

// 메시지 타이머
if (message_timer > 0)
{
    message_timer--;
}

var pl = instance_find(obj_player, 0);

if (pl == noone) exit;
if (pl.is_dead) exit;

// Room2에서는 포탈 이동 불가능
if (room == Room2) exit;

// Room1에서만 포탈 사용
if (room != Room1) exit;

// 플레이어와 포탈 사이 거리
var dist_x = abs(pl.x - x);
var dist_y = abs(pl.y - y);

// 포탈 범위 안에 들어왔는지 확인
if (dist_x < 12 && dist_y < 20 && portal_cooldown <= 0)
{
    // 봉인석이 있으면 보스방 입장
    if (pl.has_seal_stone)
    {
        global.portal_destination = Room2;
        room_goto(Room2);
        exit;
    }
    else
    {
        // 봉인석이 없으면 입장 불가
        portal_message =
            "I sense an evil presence...\nI can't enter without protection.";

        message_timer = 150;
        portal_cooldown = 150;
    }
}