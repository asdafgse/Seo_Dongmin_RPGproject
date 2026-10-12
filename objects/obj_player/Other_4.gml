/// obj_player - Room Start

// 포탈을 통해 방을 이동했을 때만 실행
if (variable_global_exists("portal_destination"))
{
    if (global.portal_destination == room)
    {
        // 현재 Room에 배치된 포탈 찾기
        var portal = instance_find(obj_boss_portal, 0);

        if (portal != noone)
        {
            // 포탈이 설치된 위치로 이동
            x = portal.x;
            y = portal.y;

            // 즉시 다시 이동하는 것 방지
            portal.portal_cooldown = 60;
        }

        // 이동 정보 초기화
        global.portal_destination = -1;
    }
}