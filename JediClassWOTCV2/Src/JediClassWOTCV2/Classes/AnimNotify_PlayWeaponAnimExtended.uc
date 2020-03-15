class AnimNotify_PlayWeaponAnimExtended extends AnimNotify_Scripted;

var() editinline  EInventorySlot InventorySlot <ToolTip="Inventory slot of the weapon the animation should be played on">;
var() editinline  name SequenceName <ToolTip="Sequence name of the weapon animation to play">;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComHumanPawn Pawn;
	local XComWeapon Weapon;
	local XComGameState_Unit UnitState;
	local AnimSequence FoundAnimSeq;
	local CustomAnimParams AnimParams;

	Pawn = XComHumanPawn(Owner);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Pawn.ObjectID));

	if (UnitState != none)
	{
		Weapon = XGWeapon(UnitState.GetItemInSlot(InventorySlot).GetVisualizer()).GetEntity();
	}
	if (Weapon != none)
	{
		AnimParams.AnimName = SequenceName;
		AnimParams.Looping = false;

		FoundAnimSeq = SkeletalMeshComponent(Weapon.Mesh).FindAnimSequence(AnimParams.AnimName);
		if(FoundAnimSeq != None)
		{
			Weapon.DynamicNode.PlayDynamicAnim(AnimParams);
			
		}
	}

	super.Notify(Owner, AnimSeqInstigator);
}

defaultproperties
{
	InventorySlot = eInvSlot_PrimaryWeapon
}