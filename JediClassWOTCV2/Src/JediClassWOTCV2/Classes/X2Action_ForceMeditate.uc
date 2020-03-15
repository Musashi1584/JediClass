class X2Action_ForceMeditate extends X2Action;

var private CustomAnimParams	Params;
var private AnimNodeSequence	StartAnim;

function ForceImmediateTimeout()
{
	// Do nothing. This is causing the animation to not finish. This animation has a fixup that
	// gets the two units to their desired positions.
}

function bool CheckInterrupted()
{
	return VisualizationBlockContext.InterruptionStatus == eInterruptionStatus_Interrupt;
}

simulated state Executing
{
	function AnimNodeSequence PlayStartAnim(XComUnitPawn PlayOnPawn)
	{
		Params = default.Params;
		Params.AnimName = 'NO_ForceMeditationStartA';

		return PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

	function PlayLoopAnim(XComUnitPawn PlayOnPawn)
	{
		Params = default.Params;
		Params.AnimName = 'NO_ForceMeditationLoopA';
		Params.Looping = true;
		PlayOnPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}

Begin:
	//Wait for the idle state machine to return to idle
	while(UnitPawn.m_kGameUnit.IdleStateMachine.IsEvaluatingStance() || bInterrupted)
	{
		Sleep(0.01f);
	}

	UnitPawn.SetUpdateSkelWhenNotRendered(true);
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	StartAnim = PlayStartAnim(UnitPawn);
	UnitPawn.bSkipIK = true;

	//Make sure the animations are finished
	FinishAnim(StartAnim);
	
	PlayLoopAnim(UnitPawn);

	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}