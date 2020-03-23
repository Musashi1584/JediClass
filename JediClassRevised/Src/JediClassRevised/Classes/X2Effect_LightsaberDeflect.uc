class X2Effect_LightsaberDeflect extends X2Effect_Persistent config(JediClass);

var config array<name> ValidWeaponCategories;        // valid weapon categories for deflect/reflect
var config array<name> IgnoreDamageTypes;       //  effects with the listed damage type will be allowed to hit the original target
var config array<name> IgnoreAbilities;         //  abilities listed here will be allowed to hit the original target
var config array<name> IgnoreEffects;           //  if the original target is affected by this effects allow to hit
var config array<name> UnlimitedUsesEffects;    //  if the original target is affected by this effects allow unlimited deflects/reflects
var config int BaseChance;

var privatewrite name DeflectUsed;
var privatewrite name DeflectBonus;

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
	local name CurrentEffect, DamageType, WeaponCat;
	local UnitValue DeflectUsedValue, ReflectBonusValue;
	local int Index, RandRoll, ReflectMalus, ReflectBonus, ModifiedHitChance;;

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
	WeaponCat = X2WeaponTemplate(TargetUnit.GetPrimaryWeapon().GetMyTemplate()).WeaponCat;
	if (default.ValidWeaponCategories.Find(WeaponCat) == INDEX_NONE)
		return false;

	// incoming attack must not have a non-reflectable damage type
	for (Index = 0; Index < AbilityTemplate.AbilityTargetEffects.Length; Index++)
	{
		DamageEffect = X2Effect_ApplyWeaponDamage(AbilityTemplate.AbilityTargetEffects[Index]);
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
	{
		return false;
	}

	// target must not be affected by an effect that stops them from reflecting
	foreach default.IgnoreEffects(CurrentEffect)
	{
		if (TargetUnit.IsUnitAffectedByEffectName(CurrentEffect))
		{
			`LOG(default.class @ GetFuncName() @ "false, IgnoreEffects" @ CurrentEffect,, ,, 'JediClassRevised');
			return false;
		}
	}

	// target must not be in overwatch
	if (TargetUnit.ReserveActionPoints.Length > 0)
	{
		`LOG(default.class @ GetFuncName() @ "false, is in overwatch",, ,, 'JediClassRevised');
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

		// Do the hit roll
		TargetUnit.GetUnitValue(default.DeflectUsed, DeflectUsedValue);
		ReflectMalus = int(DeflectUsedValue.fValue * class'X2Ability_JediClassAbilities'.default.REPEATING_MALUS);

		TargetUnit.GetUnitValue(default.DeflectBonus, ReflectBonusValue);
		ReflectBonus = int(ReflectBonusValue.fValue);

		RandRoll = `SYNC_RAND_TYPED(100, ESyncRandType_Generic);

		ModifiedHitChance = default.BaseChance - ReflectMalus + bReflect ? ReflectBonus : 0;

		`LOG(default.class @ GetFuncName() @
			`ShowVar(RandRoll) @ "<" @ `ShowVar(ModifiedHitChance) @
			`ShowVar(bReflect) @
			`ShowVar(ReflectMalus) @
			`ShowVar(ReflectBonus) @
			`ShowVar(int(DeflectUsedValue.fValue))
		,, 'JediClassRevised');

		if (RandRoll < ModifiedHitChance)
		{
			NewHitResult = bReflect ? eHit_Reflect : eHit_Deflect;
			`LOG(default.class @ GetFuncName() @ NewHitResult @ bReflect,, 'JediClassRevised');
			return true;
		}
	}

	return false;
}

defaultproperties
{
	DeflectUsed="DeflectUsed"
	DeflectBonus="DeflectBonus"
	EffectName="LightsaberRedirect"
	DuplicateResponse=eDupe_Ignore
	bReflect=false
}