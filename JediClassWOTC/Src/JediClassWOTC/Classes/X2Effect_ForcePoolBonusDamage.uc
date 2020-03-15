class X2Effect_ForcePoolBonusDamage extends X2Effect_Persistent config (JediClass);

var config array<name> ValidAbilities;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{ 
	local UnitValue CurrentForcePool;

	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		return 0;
	}

	if (default.ValidAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
	{
		return 0;
	}

	if (Attacker.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, CurrentForcePool))
	{
		return int(CurrentForcePool.fValue);
	}

	return 0; 
}


defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
