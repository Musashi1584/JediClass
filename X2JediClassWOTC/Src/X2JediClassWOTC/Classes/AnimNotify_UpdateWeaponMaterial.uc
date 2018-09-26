class AnimNotify_UpdateWeaponMaterial extends AnimNotify_Scripted;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComHumanPawn Pawn;
	local XComWeapon Weapon;

	`LOG(default.Class @ GetFuncName() @ Owner,, 'X2JediClassWotc');

	Pawn = XComHumanPawn(Owner);
	Weapon = XComWeapon(Pawn.Weapon);

	`LOG(default.Class @ GetFuncName() @ Weapon,, 'X2JediClassWotc');

	if (Weapon != none)
	{
		class'X2DownloadableContentInfo_JediClass'.static.UpdateWeaponMaterial(Weapon.m_kGameWeapon, Weapon.Mesh);
	}
	super.Notify(Owner, AnimSeqInstigator);
}