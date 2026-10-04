// =====================================================
// QUIT 버튼 등장 애니메이션
// =====================================================

if (appear_delay > 0)
{
    appear_delay--;
}
else
{
    image_xscale = lerp(image_xscale, target_scale, 0.2);
    image_yscale = lerp(image_yscale, target_scale, 0.2);

    if (abs(image_xscale - target_scale) < 0.01)
    {
        image_xscale = target_scale;
        image_yscale = target_scale;
    }
}