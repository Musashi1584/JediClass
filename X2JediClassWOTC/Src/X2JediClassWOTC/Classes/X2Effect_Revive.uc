class X2Effect_Revive extends X2Effect;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_OldState);

	if (UnitState.IsUnitAffectedByEffectName(class'X2StatusEffects'.default.BleedingOutName) ||
		UnitState.IsUnitAffectedByEffectName(class'X2StatusEffects'.default.UnconsciousName))
	{
		class 'X2StatusEffects'.static.UnconsciousVisualizationRemoved(VisualizeGameState, ActionMetadata, EffectApplyResult);
		//class'X2Action_Revive'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext());
	}
}


