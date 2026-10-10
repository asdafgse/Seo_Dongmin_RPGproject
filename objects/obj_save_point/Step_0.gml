// ==========================================
// 프리스트가 플레이어 바라보기
// ==========================================

var pl = instance_find(obj_player, 0);

if (pl != noone)
{
    if (pl.x < x)
    {
        image_xscale = -1;
    }
    else
    {
        image_xscale = 1;
    }
}