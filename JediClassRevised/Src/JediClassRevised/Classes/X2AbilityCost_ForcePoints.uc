class X2AbilityCost_ForcePoints extends X2AbilityCost_Focus;

var int ForceAmount;		// Could've reused FocusAmount from X2AC_Focus, but this is more intuitive
var bool ConsumeAllForce;	// "

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
	local UnitValue ForceValue;
	
	ActivatingUnit.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, ForceValue);

	if (ForceValue.fValue >= ForceAmount)
		return 'AA_Success';

	return 'AA_CannotAfford_Focus';
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local UnitValue ForceValue;
	local XComGameState_Unit ActivatingUnit;

	ActivatingUnit = XComGameState_Unit(AffectState);
	ActivatingUnit.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, ForceValue);

	if (bFreeCost || ForceAmount < 1)
		return;

	if( ConsumeAllForce )
	{
		ActivatingUnit.SetUnitFloatValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, 0, eCleanup_BeginTactical);
	}
	else
	{
		ActivatingUnit.SetUnitFloatValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, ForceValue.fValue - ForceAmount, eCleanup_BeginTactical);
	}
}

simulated function bool PreviewFocusCost(XComGameState_Unit UnitState, XComGameState_Ability AbilityState, out int TotalPreviewCost)
{
	local UnitValue ForceValue;

	UnitState.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, ForceValue);

	if (ConsumeAllForce && ForceValue.fValue > 0)
	{
		TotalPreviewCost = ForceValue.fValue;
		return true;
	}

	TotalPreviewCost += ForceAmount;

	return false;
}

DefaultProperties
{
	ForceAmount = 1;
} 