class X2Action_Revive extends X2Action;

var private CustomAnimParams AnimParams;
var private XComGameState_Unit UnitState;

function Init()
{
	super.Init();
	UnitState = XComGameState_Unit(Metadata.StateObject_NewState);
}

simulated state Executing
{
Begin:
	Unit.SetHidden(true);
	Unit.SetVisible(false);
	UnitPawn.SetHidden(true);
	UnitPawn.SetVisible(false);
	Unit.Destroy();
	UnitPawn.Destroy();
	`XCOMHISTORY.SetVisualizer(UnitState.ObjectID, none);

	Unit = XGUnit(UnitState.FindOrCreateVisualizer());
	UnitState.SyncVisualizer();
	UnitPawn = Unit.GetPawn();
	Unit.GetInventory().GetPrimaryWeapon().Destroy();
	Unit.ApplyLoadoutFromGameState(UnitState, None);
	
	UnitPawn.EndRagDoll();
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.EnableFootIK(false);

	AnimParams = default.AnimParams;
	AnimParams.AnimName = 'HL_GetUp';
	AnimParams.BlendTime = 0.5f;
	//AnimParams.HasDesiredEndingAtom = true;
	//AnimParams.DesiredEndingAtom.Translation = Destination;
	//AnimParams.DesiredEndingAtom.Translation.Z = UnitPawn.GetGameUnit().GetDesiredZForLocation(AnimParams.DesiredEndingAtom.Translation);
	//AnimParams.DesiredEndingAtom.Rotation = QuatFromRotator(UnitPawn.Rotation);
	//AnimParams.DesiredEndingAtom.Scale = 1.0f;
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

	UnitPawn.EnableFootIK(true);
	UnitPawn.EnableRMA(false, false);
	UnitPawn.EnableRMAInteractPhysics(false);

	Unit.IdleStateMachine.CheckForStanceUpdate();
	`LOG("X2Action_Revive",,'JediClass');
}