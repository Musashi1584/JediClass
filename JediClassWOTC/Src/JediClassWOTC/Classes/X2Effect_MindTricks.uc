class X2Effect_MindTricks extends X2Effect_ModifyStats;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange DetectionRadiusChange, SightRadiusChange;
	local XComGameState_Unit TargetUnit;
	local float CurrentDetectionRadius, CurrentSightRadius;
	
	TargetUnit = XComGameState_Unit(kNewTargetState);
	CurrentDetectionRadius = TargetUnit.GetCurrentStat(eStat_DetectionRadius);
	CurrentSightRadius = TargetUnit.GetCurrentStat(eStat_SightRadius);
	
	DetectionRadiusChange.StatType = eStat_DetectionRadius;
	DetectionRadiusChange.StatAmount = CurrentDetectionRadius * -1;
	DetectionRadiusChange.ModOp = MODOP_Addition;

	SightRadiusChange.StatType = eStat_SightRadius;
	SightRadiusChange.StatAmount = CurrentSightRadius * -1;
	SightRadiusChange.ModOp = MODOP_Addition;

	`LOG("X2Effect_MindTricks" @ CurrentDetectionRadius @ CurrentSightRadius,, 'SpecOpsClass');

	NewEffectState.StatChanges.AddItem(DetectionRadiusChange);
	NewEffectState.StatChanges.AddItem(SightRadiusChange);

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local XComGameStateContext_Ability  Context;
	local XComGameState_Unit UnitState;
	local X2Action_CameraLookAt LookAtAction;

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	if(Context.IsResultContextHit() && EffectApplyResult == 'AA_Success')
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "Mind Trick", '', eColor_Good);
	}
	else
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "Resisted Mind Trick", '', eColor_Bad);
	}

	LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	LookAtAction.UseTether = false;
	LookAtAction.LookAtObject = UnitState;
	LookAtAction.BlockUntilActorOnScreen = true;

}

