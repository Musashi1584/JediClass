class X2Effect_ForceSpeed extends X2Effect_Persistent config (JediClass);

var config float ForceSpeedGameSpeedMutliplier;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	class'WorldInfo'.static.GetWorldInfo().Game.SetGameSpeed(default.ForceSpeedGameSpeedMutliplier);
	`LOG("X2Effect_ForceSpeed.OnEffectAdded" @ class'X2Effect_ForceSpeed'.default.ForceSpeedGameSpeedMutliplier @ "active ForceSpeed on" @ XComGameState_Unit(kNewTargetState).GetFullName(),, 'JediClass');
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	class'WorldInfo'.static.GetWorldInfo().Game.SetGameSpeed(1);
	`LOG("X2Effect_ForceSpeed.OnEffectRemoved SetGameSpeed 1",, 'JediClass');
}

DefaultProperties
{
	EffectName = "ForceSpeed"
}