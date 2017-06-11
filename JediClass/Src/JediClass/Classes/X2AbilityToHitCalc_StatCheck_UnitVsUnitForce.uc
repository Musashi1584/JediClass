class X2AbilityToHitCalc_StatCheck_UnitVsUnitForce extends X2AbilityToHitCalc_StatCheck_UnitVsUnit;

protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional bool bDebugLog=false)
{
	local XComGameState_Unit UnitState;
	local int AttackVal, DefendVal, TargetRoll, ForceAlignmentModifier;
	local ShotBreakdown EmptyShotBreakdown;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	ForceAlignmentModifier = class'JediClassHelper'.static.GetSuccessModifier(UnitState, kAbility.GetMyTemplateName());
	
	//reset shot breakdown
	m_ShotBreakdown = EmptyShotBreakdown;

	AttackVal = GetAttackValue(kAbility, kTarget.PrimaryTarget);
	DefendVal = GetDefendValue(kAbility, kTarget.PrimaryTarget);
	TargetRoll = BaseValue + AttackVal + ForceAlignmentModifier - DefendVal;
	AddModifier(BaseValue, GetBaseString());
	AddModifier(AttackVal, GetAttackString());
	AddModifier(-DefendVal, GetDefendString());
	AddModifier(ForceAlignmentModifier, class'JediClassHelper'.static.GetForceAlignmentModifierString());
	m_ShotBreakdown.FinalHitChance = TargetRoll;
	return TargetRoll;
}

//function int GetAttackValue(XComGameState_Ability kAbility, StateObjectReference TargetRef)
//{
//	local XComGameState_Unit UnitState;
//
//	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
//	return UnitState.GetCurrentStat(AttackerStat) + class'JediClassHelper'.static.GetSuccessModifier(UnitState, kAbility.GetMyTemplateName());
//}
