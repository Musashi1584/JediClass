class X2Effect_GrantDarkSidePoint extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit, TargetUnit;

	if (ApplyEffectParameters.SourceStateObjectRef.ObjectID != ApplyEffectParameters.TargetStateObjectRef.ObjectID)
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

		if (TargetUnit.IsFriendlyUnit(SourceUnit) || TargetUnit.IsCivilian())
		{
			class'JediClassHelper'.static.AddDarkSidePointToGameState(SourceUnit, NewGameState);
		}
	}
}