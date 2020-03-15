class XGLightSaber extends XGWeapon;

simulated function UpdateWeaponMaterial(MeshComponent MeshComp, MaterialInstanceConstant MIC)
{
    local XComLinearColorPalette Palette;
    local LinearColor GlowTint;

    super.UpdateWeaponMaterial(MeshComp, MIC);

    Palette = `CONTENT.GetColorPalette(ePalette_ArmorTint);
    if (Palette != none)
    {
        if(m_kAppearance.iWeaponTint != INDEX_NONE)
        {
            GlowTint = Palette.Entries[m_kAppearance.iWeaponTint].Primary;
            MIC.SetVectorParameterValue('Emissive Color', GlowTint);
        }
    }
}