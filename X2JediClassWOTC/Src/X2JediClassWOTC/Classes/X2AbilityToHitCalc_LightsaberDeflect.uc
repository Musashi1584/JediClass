class X2AbilityToHitCalc_LightsaberDeflect extends X2AbilityToHitCalc;

protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog=false)
{
	local XComGameState_Unit AttackerState;
	local UnitValue DidAttackHit;

	AttackerState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	AttackerState.GetUnitValue(class'X2Effect_LightsaberDeflect'.default.AttackHit, DidAttackHit);

	`log(default.class @ GetFuncName() @ "did deflect roll reflect at attacker:" @ DidAttackHit.fValue,, 'X2JediClassWOTC');

	if (DidAttackHit.fValue > 0)
	{
		AttackerState.SetUnitFloatValue(class'X2Effect_LightsaberDeflect'.default.AttackHit, 0, eCleanup_BeginTurn);
		return 100;
	}
	
	return 0;
}