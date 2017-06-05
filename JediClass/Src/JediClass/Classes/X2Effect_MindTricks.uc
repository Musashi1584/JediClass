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

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationTrack BuildTrack, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local XComGameStateContext_Ability  Context;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	if(Context.IsResultContextMiss() && EffectApplyResult != 'AA_Success')
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "Resisted Mind Trick", '', eColor_Bad);
	}
	else if(Context.IsResultContextHit() && EffectApplyResult == 'AA_Success')
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "Mind Trick", '', eColor_Good);
	}
}

