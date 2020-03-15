class AnimNotify_UpdateWeaponMaterial extends AnimNotify_Scripted;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComHumanPawn Pawn;
	local XComWeapon Weapon;
	//local XComGameState_Unit UnitState;
	local SkeletalMeshComponent UnitSkeletalMesh;
	local int i;

	Pawn = XComHumanPawn(Owner);

	`LOG(default.Class @ GetFuncName() @ Owner @ Pawn.ObjectID,, 'JediClassWOTC');

	//UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Pawn.ObjectID));

	//if (UnitState != none)
	//{
	//	PrimaryWeapon = XGWeapon(UnitState.GetPrimaryWeapon().GetVisualizer()).GetEntity();
	//	SecondaryWeapon = XGWeapon(UnitState.GetSecondaryWeapon().GetVisualizer()).GetEntity();
	//
	//	`LOG(default.Class @ GetFuncName() @ UnitState @ PrimaryWeapon @ SecondaryWeapon,, 'JediClassWOTC');
	//
	//	if (PrimaryWeapon != none)
	//	{
	//		class'X2DownloadableContentInfo_JediClass'.static.UpdateWeaponMaterial(PrimaryWeapon.m_kGameWeapon, PrimaryWeapon.Mesh);
	//	}
	//
	//	if (SecondaryWeapon != none && X2WeaponTemplate(UnitState.GetSecondaryWeapon().GetMyTemplate()).WeaponCat == 'lightsaber')
	//	{
	//		class'X2DownloadableContentInfo_JediClass'.static.UpdateWeaponMaterial(SecondaryWeapon.m_kGameWeapon, SecondaryWeapon.Mesh);
	//	}
	//}

	UnitSkeletalMesh = Pawn.Mesh;

	for (i = 0; i < UnitSkeletalMesh.Attachments.Length; ++i)
	{
		if (UnitSkeletalMesh.Attachments[i].Component != none)
		{
			Weapon = XComWeapon(UnitSkeletalMesh.Attachments[i].Component.Outer);
			if (Weapon != none)
			{
				`LOG(default.Class @ GetFuncName() @ Weapon.ObjectArchetype,, 'JediClassWOTC');
				class'X2DownloadableContentInfo_JediClass'.static.UpdateWeaponMaterial(Weapon.m_kGameWeapon, Weapon.Mesh);
			}
		}
	}

	super.Notify(Owner, AnimSeqInstigator);
}