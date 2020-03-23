class X2Effect_ForceSpeed extends X2Effect_Persistent config (JediClass);

var config float ForceSpeedGameSpeedMultiplier;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kNewTargetState);
	XComHumanPawn(XGUnit(UnitState.GetVisualizer()).GetPawn()).Mesh.GlobalAnimRateScale = default.ForceSpeedGameSpeedMultiplier;
	XComHumanPawn(XGUnit(UnitState.GetVisualizer()).GetPawn()).Mesh.bPerBoneMotionBlur = true;
	`LOG("X2Effect_ForceSpeed.OnEffectAdded" @ class'X2Effect_ForceSpeed'.default.ForceSpeedGameSpeedMultiplier @ "active ForceSpeed on" @ XComGameState_Unit(kNewTargetState).GetFullName(),, 'JediClassRevised');
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit UnitState;
	//class'WorldInfo'.static.GetWorldInfo().Game.SetGameSpeed(1);
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`LOG("X2Effect_ForceSpeed.OnEffectRemoved SetGameSpeed 1",, 'JediClassRevised');
	XComHumanPawn(XGUnit(UnitState.GetVisualizer()).GetPawn()).Mesh.GlobalAnimRateScale = 1;
	XComHumanPawn(XGUnit(UnitState.GetVisualizer()).GetPawn()).Mesh.bPerBoneMotionBlur = false;
}

DefaultProperties
{
	EffectName = "ForceSpeed"
}