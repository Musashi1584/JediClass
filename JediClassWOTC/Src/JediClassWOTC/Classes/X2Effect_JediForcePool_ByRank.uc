class X2Effect_JediForcePool_ByRank extends X2Effect_Persistent config(JediClass);

var config int BasePool, BonusPerRank;

var privatewrite name MaxForceName, CurrentForceName;

var localized string ForceLabel;
var localized string ForceDescription;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local UnitValue CurrUnitValue;
	local int ForceAmount;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		ForceAmount = GetPoolToInit(UnitState);

		UnitState.GetUnitValue(default.MaxForceName, CurrUnitValue);
		UnitState.SetUnitFloatValue(default.MaxForceName, CurrUnitValue.fValue + ForceAmount, eCleanup_BeginTactical);
		
		UnitState.GetUnitValue(default.CurrentForceName, CurrUnitValue);
		UnitState.SetUnitFloatValue(default.CurrentForceName, CurrUnitValue.fValue + ForceAmount, eCleanup_BeginTactical);
	}
}

simulated protected function int GetPoolToInit(XComGameState_Unit UnitState)
{
	return (default.BasePool + (UnitState.GetSoldierRank() * default.BonusPerRank));
}

defaultproperties
{
	EffectName="ForcePool"
	MaxForceName="MaxForce"
	CurrentForceName="CurrentForce"
}