class X2Effect_ExtraDeflectChance extends X2Effect_Persistent;

var public int DeflectBonus;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local UnitValue CurrUnitValue;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		UnitState.GetUnitValue(class'X2Effect_LightsaberDeflect'.default.DeflectBonus, CurrUnitValue);
		UnitState.SetUnitFloatValue(class'X2Effect_LightsaberDeflect'.default.DeflectBonus, CurrUnitValue.fValue + DeflectBonus, eCleanup_BeginTactical);
	}
}