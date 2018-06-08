class X2Effect_GrantLightSidePoint extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit;

	if (ApplyEffectParameters.SourceStateObjectRef.ObjectID != ApplyEffectParameters.TargetStateObjectRef.ObjectID)
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		class'JediClassHelper'.static.AddLightSidePointToGameState(SourceUnit, NewGameState);
	}
}