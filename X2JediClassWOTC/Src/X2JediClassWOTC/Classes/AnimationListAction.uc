class AnimationListAction extends Actor
	dependson(XComAnimTreeController);

var XComUnitPawn				UnitPawn;
var private AnimNodeSequence	PlayingSequence;
var array<name>					AnimSequenceList;
var public bool					bOffsetRMA;
var public BlendMaskIndex		BlendType;
var public float				BlendOutTime;
var public bool					bBlendOut;
var	public CustomAnimParams		Params;
var private name				CurrentSequence;
var private int					Index;
var private StateObjectReference ObjectRef;

simulated state Executing
{
Begin:

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	if(bOffsetRMA)
	{
		Params.DesiredEndingAtoms.Add(1);
		Params.DesiredEndingAtoms[0].Translation = UnitPawn.Location;
		Params.DesiredEndingAtoms[0].Translation.Z = UnitPawn.GetDesiredZForLocation(UnitPawn.Location);
		Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(UnitPawn.Rotation);
		Params.DesiredEndingAtoms[0].Scale = 1.0f;

		UnitPawn.SetLocation(UnitPawn.GetAnimTreeController().GetStartingAtomFromDesiredEndingAtom(Params).Translation);
	}

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	while(Index < AnimSequenceList.Length)
	{
		CurrentSequence = AnimSequenceList[Index];
		Params.AnimName = CurrentSequence;

		if (UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName) || Params.HasPoseOverride)
		{
			ObjectRef.ObjectID = UnitPawn.m_kGameUnit.ObjectID;
			class'UIWorldMessageMgr'.static.DamageDisplay(
				UnitPawn.Location,
				ObjectRef,
				string(CurrentSequence),
				UnitPawn.m_eTeamVisibilityFlags
			);

			if (Params.Additive)
			{
				UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(Params);
			}
			else
			{
				PlayingSequence = UnitPawn.GetAnimTreeController().PlayDynamicAnim(Params, BlendType);

				FinishAnim(PlayingSequence);

				if (bBlendOut)
				{
					UnitPawn.GetAnimTreeController().BlendOutDynamicNode(BlendOutTime, BlendType);
				}
			}
		}
		else
		{
			`LOG(default.class @ GetFuncName() @ "Could not play animation" @ CurrentSequence);
		}

		sleep(0);

		Index++;
	}
}