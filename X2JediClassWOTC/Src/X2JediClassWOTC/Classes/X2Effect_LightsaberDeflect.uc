class X2Effect_LightsaberDeflect extends X2Effect_Persistent config(JediClass);

var config array<name> IgnoreDamageTypes;       //  effects with the listed damage type will be allowed to hit the original target
var config array<name> IgnoreAbilities;         //  abilities listed here will be allowed to hit the original target
var config array<name> IgnoreEffects;           //  if the original target is affected by this effects allow to hit
var config array<name> UnlimitedUsesEffects;    //  if the original target is affected by this effects allow unlimited deflects/reflects

var config int REFLECT_HIT_DIFFICULTY;

var privatewrite name DeflectUsed;
var privatewrite name DeflectBonus;
var privatewrite name AttackHit;

var protected bool bReflect;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local X2AbilityToHitCalc_StandardAim AttackToHit;
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local name CurrentEffect, DamageType;
	local XComGameStateContext_Ability AbilityContext;
	local int i, AttackHitChance, DeflectModifier, DeflectRoll, DidDeflectHit;
	local UnitValue CurrentValue;
	//local XComGameState NewGameState;
	//local XComGameState_Unit NewTargetUnit;

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
		// Set the difficulty to deflect the attack - we cannot obtain context to the attacker's roll, so set difficulty to his chance instead
		foreach `XCOMHISTORY.IterateContextsByClassType(class'XComGameStateContext_Ability', AbilityContext)
		{
			if (AbilityContext.InputContext.AbilityRef.ObjectID == AbilityState.ObjectID)
			{
				AttackHitChance = AbilityContext.ResultContext.CalculatedHitChance;
				break;
			}
		}

		// Set bonus chance that the X2Effect_ExtraDeflectChance effects wrote in - the bonus chance from Reflect is included here
		TargetUnit.GetUnitValue(default.DeflectBonus, CurrentValue);
		DeflectModifier = CurrentValue.fValue;

		// Reduce chance to deflect by number of times deflected already this turn
		TargetUnit.GetUnitValue(default.DeflectUsed, CurrentValue);
		DeflectModifier -= (CurrentValue.fValue * class'X2Ability_JediClassAbilities'.default.REFLECT_REPEAT_MALUS);
		`log(default.class @ GetFuncName() @ "Deflect has been used" @ CurrentValue.fValue @ "times this round",, 'X2JediClassWOTC');

		// Roll, then add any modifiers
		DeflectRoll = `SYNC_RAND(100);
		DeflectRoll += DeflectModifier;

		// Check to see if we can reflect and our roll was high enough, so we can tell the reflect shot to hit
		if (bReflect && (DeflectRoll > (AttackHitChance + default.REFLECT_HIT_DIFFICULTY)))
		{
			DidDeflectHit = 1;
			//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(GetFuncName());
			//NewTargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', TargetUnit.ObjectID));
			//NewTargetUnit.SetUnitFloatValue(default.AttackHit, 1, eCleanup_BeginTurn);
			TargetUnit.SetUnitFloatValue(default.AttackHit, DidDeflectHit, eCleanup_BeginTurn);
			//`GAMERULES.SubmitGameState(NewGameState);
		}
		`log(default.class @ GetFuncName() @ "did deflect roll hit attacker:" @ DidDeflectHit,, 'X2JediClassWOTC');

		// Check for the auto-deflect condition - do this after the reflect check so we have the option of hitting with it
		foreach default.UnlimitedUsesEffects(CurrentEffect)
		{
			if (TargetUnit.IsUnitAffectedByEffectName(CurrentEffect))
			{
				NewHitResult = eHit_Reflect;
				return true;
			}
		}

		// Check to see if we exceeded their hit roll
		if (DeflectRoll > AttackHitChance)
		{
			NewHitResult = eHit_Reflect;
			return true;
		}
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