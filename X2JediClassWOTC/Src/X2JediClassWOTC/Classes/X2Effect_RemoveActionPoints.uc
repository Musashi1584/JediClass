class X2Effect_RemoveActionPoints extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		while (TargetUnit.NumActionPoints(class'X2CharacterTemplateManager'.default.StandardActionPoint) > 0)
		{
			TargetUnit.ActionPoints.RemoveItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
		}
		TargetUnit.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 1);
	}
}

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (TargetUnit != none)
	{
		while (TargetUnit.NumActionPoints(class'X2CharacterTemplateManager'.default.StandardActionPoint) > 0)
		{
			TargetUnit.ActionPoints.RemoveItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
		}
	}

	return super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication, Player);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit != none)
	{
		TargetUnit.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
		NewGameState.AddStateObject(TargetUnit);
	}
}