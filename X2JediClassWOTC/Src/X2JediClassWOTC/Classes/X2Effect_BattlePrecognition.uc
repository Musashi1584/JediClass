class X2Effect_BattlePrecognition extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	`LOG(default.class @ GetFuncName() @ self.WatchRule,, 'X2JediClassWOTC');
}

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameState_Unit UnitState;
	local bool bKeepEffect;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	// This happens while it is not the unit's turn, so it should have no action points
	UnitState.ActionPoints.Length = 0;
	UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);

	bKeepEffect = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication, Player);

	`LOG(default.class @ GetFuncName() @ self.WatchRule @ Player.PlayerClassName @ Player.TeamFlag @ `ShowVar(FirstApplication) @ `ShowVar(bKeepEffect),, 'X2JediClassWOTC');
	
	return bKeepEffect;
}

simulated function bool FullTurnComplete(XComGameState_Effect kEffect, XComGameState_Player TurnPlayer)
{
	`LOG(default.class @ GetFuncName() @ kEffect @ TurnPlayer.PlayerClassName @ TurnPlayer.TeamFlag,, 'X2JediClassWOTC');
	return super.FullTurnComplete(kEffect, TurnPlayer);
}