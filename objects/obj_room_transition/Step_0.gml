/// obj_room_transition - Step

var pl = instance_find(obj_player, 0);
if (pl == noone || pl.is_dead) exit;

// 출입구 영역에 들어왔는지 확인
if (
    abs(pl.x - x) <= transition_width / 2 &&
    abs(pl.y - y) <= transition_height / 2
)
{
    // 다음 방에서 등장할 위치 저장
    global.portal_target_x = target_x;
    global.portal_target_y = target_y;
    global.portal_pending = true;

    room_goto(target_room);
}