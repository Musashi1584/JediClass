class X2Action_Fire_ForceChoke extends X2Action_Fire;

var XComUnitPawn TargetUnitPawn;
var CustomAnimParams Params;
var vector SourceToTarget;
var float TimeUntilRagdoll, TimeUntilTargetAnimStart;
var int ScanNotify;
var AnimNotifyEvent NotifyEvent;
var AnimNodeSequence StopUnitSequence, StopTargetSequence, FireSequence;
var Name TargetBeginAnim, TargetEndAnim, SourceBeginAnim;

function Init()
{
	local array<AnimNotifyEvent> FoundFireWeaponNotifyEvents;
	local AnimNotifyEvent NotifyEvent;
	local AnimNotify_FireWeapon Notify;

	super.Init();

	TargetUnitPawn = TargetUnit.GetPawn();
	SourceToTarget = TargetUnitPawn.Location - UnitPawn.Location;

	FoundFireWeaponNotifyEvents = FindNotifies(UnitPawn, "FF_ForceChokeA", 'AnimNotify_FireWeapon');

	foreach FoundFireWeaponNotifyEvents(NotifyEvent)
	{
		Notify = AnimNotify_FireWeapon(NotifyEvent.Notify);
		TimeUntilTargetAnimStart = NotifyEvent.Time;
		`LOG(default.class @ GetFuncName() @ `ShowVar(NotifyEvent.Time) @ `ShowVar(Notify),, 'JediClassRevised');
		break;
	}

}

function ProjectileNotifyHit(bool bMainImpactNotify, Vector HitLocation)
{	
	`LOG(default.class @ GetFuncName() @ `ShowVar(bMainImpactNotify) @ `ShowVar(HitLocation),, 'JediClassRevised');
}

static function array<AnimNotifyEvent> FindNotifies(XComUnitPawn Pawn, string SequenceName, name NotifyClassName)
{
	local AnimSet Set;
	local AnimSequence Sequence;
	local int Index;
	local array<AnimNotifyEvent> FoundNotifyEvents;

	foreach Pawn.Mesh.AnimSets(Set)
	{
		foreach Set.Sequences(Sequence)
		{
			if (InStr(Sequence.SequenceName, SequenceName) != INDEX_NONE)
			{
				for (Index = 0; Index<Sequence.Notifies.Length; Index++)
				{
					
					if (Sequence.Notifies[Index].Notify.IsA(NotifyClassName))
					{
						FoundNotifyEvents.AddItem(Sequence.Notifies[Index]);
					}
				}
			}
		}
	}
	
	return FoundNotifyEvents;
}

simulated state Executing
{
Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;
	TargetUnitPawn.EnableRMA(true, true);
	TargetUnitPawn.EnableRMAInteractPhysics(true);
	TargetUnitPawn.bSkipIK = true;
	TargetUnit.IdleStateMachine.GoDormant(UnitPawn);

	Params = default.Params;
	Params.AnimName = SourceBeginAnim;
	Params.Looping = false;
	FireSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

	Sleep(TimeUntilTargetAnimStart);

	TargetUnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	Params = default.Params;
	Params.AnimName = TargetBeginAnim;
	Params.Looping = false;
	Params.DesiredEndingAtoms.Add(1);
	Params.DesiredEndingAtoms[0].Translation = TargetUnitPawn.Location;
	Params.DesiredEndingAtoms[0].Translation.Z = TargetUnitPawn.GetDesiredZForLocation(TargetUnitPawn.Location);
	Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(Rotator(-SourceToTarget));
	Params.DesiredEndingAtoms[0].Scale = 1.0f;
	TargetUnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	TargetUnitPawn.GetAnimTreeController().SetAllowNewAnimations(false);

	FinishAnim(FireSequence);

	TimeUntilRagdoll = -1.0f;

	Params = default.Params;
	Params.AnimName = TargetEndAnim;
	Params.Looping = false;
	TargetUnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	StopTargetSequence = TargetUnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	if(StopTargetSequence != None && StopTargetSequence.AnimSeq != None)
	{
		for(ScanNotify = 0; ScanNotify < StopTargetSequence.AnimSeq.Notifies.Length; ++ScanNotify)
		{
			NotifyEvent = StopTargetSequence.AnimSeq.Notifies[ScanNotify];
			if( XComAnimNotify_Ragdoll(NotifyEvent.Notify) != None )
			{
				TimeUntilRagdoll = NotifyEvent.Time;
			}
		}
	}

	if(TimeUntilRagdoll != -1.0f )
	{
		Sleep(TimeUntilRagdoll);
		//TargetUnitPawn.StartRagDoll();
	}
	//FinishAnim(StopUnitSequence);


	CompleteAction();
}

defaultproperties
{
	SourceBeginAnim = "FF_ForceChokeA"
	TargetBeginAnim = "FF_ForceChokedStartA"
	TargetEndAnim = "FF_ForceChokedStopA"
}