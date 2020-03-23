class X2Action_Fire_SyncedAnimation extends X2Action_Fire;

const SyncedAnimChance = 40;//50;

function Init()
{
	local name SyncedFireAnimName;
	local int Index, RandRoll;
	local array<SyncedAnimation> FoundSequences;
	local SyncedAnimation Sequence;

	super.Init();

	`LOG(default.class @ GetFuncName() @ `ShowVar(AnimParams.AnimName),, 'JediClassRevised');
	
	SyncedFireAnimName = name(AnimParams.AnimName $ "Synced");

	RandRoll = `SYNC_RAND(100);
	if (RandRoll > SyncedAnimChance)
	{
		return;
	}

	for (Index = 0; Index < class'X2Action_SyncedAnimationDeath'.default.SyncedAnimations.Length; Index++)
	{
		Sequence = class'X2Action_SyncedAnimationDeath'.default.SyncedAnimations[Index];
		if (InStr(Sequence.AttackAnimSequence, SyncedFireAnimName) != INDEX_NONE)
		{
			FoundSequences.AddItem(Sequence);
		}
	}

	if (FoundSequences.Length == 0)
	{
		return;
	}

	RandRoll = `SYNC_RAND(FoundSequences.Length);
	Sequence = FoundSequences[RandRoll];

	if(UnitPawn.GetAnimTreeController().CanPlayAnimation(Sequence.AttackAnimSequence))
	{
		if (TargetUnit.GetPawn().GetAnimTreeController().CanPlayAnimation(Sequence.DeathAnimSequence))
		{
			AnimParams.AnimName = Sequence.AttackAnimSequence;
		}
	}
}