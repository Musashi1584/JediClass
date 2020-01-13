class X2AbilityToHitCalc_LightsaberDeflect extends X2AbilityToHitCalc;

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
	local XComGameState_Unit UnitState;
	local UnitValue DidAttackHit;
	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	UnitState.GetUnitValue(class'X2Effect_LightsaberDeflect'.default.AttackHit, DidAttackHit);

	`LOG(default.class @ GetFuncName() @ ResultContext.HitResult @ DidAttackHit.fValue,, 'X2JediClassWOTC');
	UnitState.SetUnitFloatValue(class'X2Effect_LightsaberDeflect'.default.AttackHit, 0, eCleanup_BeginTurn);

	if (DidAttackHit.fValue > 0)
	{
		ResultContext.HitResult = eHit_Success;
		return;
	}
	
	ResultContext.HitResult = eHit_Miss;
}


//protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog=false)
//{
//	local XComGameState_Unit UnitState;
//	local UnitValue DidAttackHit;
//
//	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
//	UnitState.GetUnitValue(class'X2Effect_LightsaberDeflect'.default.AttackHit, DidAttackHit);
//
//	//`log(default.class @ GetFuncName() @ UnitState.SummaryString() @ "did deflect roll reflect at attacker:" @ DidAttackHit.fValue,, 'X2JediClassWOTC');
//
//	if (DidAttackHit.fValue > 0)
//	{
//		`log(default.class @ GetFuncName() @ UnitState.SummaryString() @ "did deflect roll reflect at attacker:" @ DidAttackHit.fValue,, 'X2JediClassWOTC');
//		//UnitState.SetUnitFloatValue(class'X2Effect_LightsaberDeflect'.default.AttackHit, 0, eCleanup_BeginTurn);
//		return 100;
//	}
//	
//	return 0;
//}