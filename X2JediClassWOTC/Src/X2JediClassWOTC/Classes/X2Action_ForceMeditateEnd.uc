class X2Action_ForceMeditateEnd extends X2Action;

var private CustomAnimParams				Params;
var private XComGameState_Unit				UnitState;
var private Vector							DesiredLocation;
var private bool                            bUnitIsAliveAndConcious;
var private AnimNodeSequence	            UnitAnimSeq;

function Init()
{
	super.Init();

	UnitState = Unit.GetVisualizedGameState(CurrentHistoryIndex);
	
	bUnitIsAliveAndConcious = UnitState.IsAlive() && !UnitState.IsUnconscious() && !UnitState.IsBleedingOut();
}

simulated state Executing
{
	function AnimNodeSequence EndBind(XComGameState_Unit PlayOnGameStateUnit, XGUnit PlayOnUnit, XComUnitPawn PlayOnPawn)
	{
		PlayOnPawn.EnableRMA(true,true);
		PlayOnPawn.EnableRMAInteractPhysics(true);

		Params = default.Params;
		Params.AnimName = 'NO_ForceMeditationStop';
		DesiredLocation = `XWORLD.GetPositionFromTileCoordinates(PlayOnGameStateUnit.TileLocation);
	
		// Set Z so our feet are on the ground
		DesiredLocation.Z = PlayOnUnit.GetDesiredZForLocation(DesiredLocation);
		Params.DesiredEndingAtoms.Add(1);
		Params.DesiredEndingAtoms[0].Translation = DesiredLocation;
		Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(PlayOnPawn.Rotation);
		Params.DesiredEndingAtoms[0].Scale = 1.0f;

		PlayOnUnit.IdleStateMachine.PersistentEffectIdleName = '';
		PlayOnPawn.GetAnimTreeController().SetAllowNewAnimations(true);
		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

Begin:

	if(bUnitIsAliveAndConcious)
	{
		UnitAnimSeq = EndBind(UnitState, Unit, UnitPawn);
	}

	FinishAnim(UnitAnimSeq);
	
	UnitPawn.bSkipIK = false;

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}