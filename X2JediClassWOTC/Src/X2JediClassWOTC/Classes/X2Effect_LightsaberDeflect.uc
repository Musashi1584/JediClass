class X2Effect_LightsaberDeflect extends X2Effect_Persistent config(JediClass);

var config array<name> IgnoreDamageTypes;       //  effects with the listed damage type will be allowed to hit the original target
var config array<name> IgnoreAbilities;         //  abilities listed here will be allowed to hit the original target
var config array<name> IgnoreEffects;           //  if the original target is affected by this effects allow to hit
var config array<name> UnlimitedUsesEffects;    //  if the original target is affected by this effects allow unlimited deflects/reflects

var privatewrite name DeflectUsed;
var privatewrite name DeflectBonus;
var privatewrite name AttackHit;

var protected bool bReflect;

function bool ChangeHitResultForTarget(
	XComGameState_Effect EffectState,
	XComGameState_Unit Attacker,
	XComGameState_Unit TargetUnit,
	XComGameState_Ability AbilityState,
	bool bIsPrimaryTarget,
	const EAbilityHitResult CurrentResult,
	out EAbilityHitResult NewHitResult
)
{
	local X2AbilityToHitCalc_StandardAim AttackToHit;
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local name CurrentEffect, DamageType;
	local int i;

	AbilityTemplate = AbilityState.GetMyTemplate();

	//	don't respond to reaction fire
	AttackToHit = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
	if (AttackToHit != none && AttackToHit.bReactionFire)
		return false;

	//	don't change a natural miss
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;

	// target must be able to respond to incoming fire
	if (!TargetUnit.IsAbleToAct())
		return false;

	// target must be wielding a lightsaber as their primary weapon (we'll deal with dual wielding conditions later?)
	if (X2WeaponTemplate(TargetUnit.GetPrimaryWeapon().GetMyTemplate()).WeaponCat != 'lightsaber')
		return false;

	// incoming attack must not have a non-reflectable damage type
	for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; i++)
	{
		DamageEffect = X2Effect_ApplyWeaponDamage(AbilityTemplate.AbilityTargetEffects[i]);
		if (DamageEffect != none)
		{
			foreach default.IgnoreDamageTypes(DamageType)
			{
				if (DamageEffect.DamageTypes.Find(DamageType) != INDEX_NONE)
				{
					return false;
				}
			}
		}
	}

	// incoming attack must not be a non-reflectable ability
	if (default.IgnoreAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE)
		return false;

	// target must not be affected by an effect that stops them from reflecting
	foreach default.IgnoreEffects(CurrentEffect)
	{
		if (TargetUnit.IsUnitAffectedByEffectName(CurrentEffect))
			return false;
	}
	
	//	Deflect cannot block melee abilities, so only check ranged single-target
	if (!AbilityState.IsMeleeAbility() && bIsPrimaryTarget)
	{
		// Check for the auto-deflect condition - do this after the reflect check so we have the option of hitting with it
		foreach default.UnlimitedUsesEffects(CurrentEffect)
		{
			if (TargetUnit.IsUnitAffectedByEffectName(CurrentEffect))
			{
				NewHitResult = eHit_Reflect;
				return true;
			}
		}

		NewHitResult = bReflect ? eHit_Reflect : eHit_Deflect;

		`LOG(default.class @ GetFuncName() @ NewHitResult @ bReflect,, 'X2JediClassWOTC');

		return true;
	}

	return false;
}

defaultproperties
{
	DeflectUsed="DeflectUsed"
	DeflectBonus="DeflectBonus"
	AttackHit="AttackHit"
	EffectName="LightsaberRedirect"
	DuplicateResponse=eDupe_Ignore
	bReflect=false
}