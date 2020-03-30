class AnimNotify_UpdateWeaponMaterial extends AnimNotify_Scripted;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComHumanPawn Pawn;
	local XComWeapon Weapon;
	local SkeletalMeshComponent UnitSkeletalMesh;
	local int i;

	Pawn = XComHumanPawn(Owner);

	UnitSkeletalMesh = Pawn.Mesh;

	for (i = 0; i < UnitSkeletalMesh.Attachments.Length; ++i)
	{
		if (UnitSkeletalMesh.Attachments[i].Component != none)
		{
			Weapon = XComWeapon(UnitSkeletalMesh.Attachments[i].Component.Outer);
			if (Weapon != none)
			{
				UpdateWeaponMaterial(Weapon.m_kGameWeapon, Weapon.Mesh);
			}
		}
	}

	super.Notify(Owner, AnimSeqInstigator);
}

static function UpdateWeaponMaterial(XGWeapon WeaponArchetype, MeshComponent MeshComp)
{
	local XComLinearColorPalette Palette;
	local LinearColor GlowTint;
	local int i;
	local MaterialInterface Mat, ParentMat;
	local MaterialInstanceTimeVarying MITV, ParentMITV, NewMITV;

	if (MeshComp != none)
	{
		for (i = 0; i < MeshComp.GetNumElements(); ++i)
		{
			Mat = MeshComp.GetMaterial(i);
			MITV = MaterialInstanceTimeVarying(Mat);

			if (MITV != none)
			{
				// If this is not a child MIC, make it one. This is done so that the material updates below don't stomp
				// on each other between units.
				if (InStr(MITV.Name, "MaterialInstanceTimeVarying") == INDEX_NONE)
				{
					NewMITV = new (WeaponArchetype) class'MaterialInstanceTimeVarying';
					NewMITV.SetParent(MITV);
					MeshComp.SetMaterial(i, NewMITV);
					MITV = NewMITV;
				}
				
				ParentMat = MITV.Parent;
				while (!ParentMat.IsA('Material'))
				{
					ParentMITV = MaterialInstanceTimeVarying(ParentMat);
					if (ParentMITV != none)
						ParentMat = ParentMITV.Parent;
					else
						break;
				}

				if (InStr(ParentMat, "MAT_Lightsaber_Blade") != INDEX_NONE)
				{
					Palette = `CONTENT.GetColorPalette(ePalette_ArmorTint);
					if (Palette != none)
					{
						if(WeaponArchetype.m_kAppearance.iWeaponTint != INDEX_NONE)
						{
							GlowTint = Palette.Entries[WeaponArchetype.m_kAppearance.iWeaponTint].Primary;
							MITV.SetVectorParameterValue('Emissive Color', GlowTint);
						}
					}
				}
			}
		}
	}	
}