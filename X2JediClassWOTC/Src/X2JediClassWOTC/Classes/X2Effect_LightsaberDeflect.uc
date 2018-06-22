class X2Effect_LightsaberDeflect extends X2Effect_Persistent config(JediClass);

struct AbilityContextTarget {
	var String ContextName;
	var int TargetID;
};

var config array<name> IgnoreDamageTypes;       //  effects with the listed damage type will be allowed to hit the original target
var config array<name> IgnoreAbilities;         //  abilities listed here will be allowed to hit the original target
var config array<name> IgnoreEffects;           //  if the original target is affected by this effects allow to hit
var config array<name> UnlimitedUsesEffects;    //  if the original target is affected by this effects allow unlimited deflects/reflects

var config int NUM_OF_DEFLECTS;

var private array<AbilityContextTarget> AbilityContextTargets;

var privatewrite name DeflectUsed;

var public bool bReflect;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local UnitValue DeflectValue;
	local X2AbilityToHitCalc_StandardAim AttackToHit;

	//	don't respond to reaction fire
	AttackToHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (AttackToHit != none && AttackToHit.bReactionFire)
		return false;

	//	don't change a natural miss
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;

	if (!TargetUnit.IsAbleToAct())
		return false;
		
	//`log(Default.Class $ "::" $ GetFuncName(),, 'X2JediClassWOTC');
	//	Deflect cannot block melee abilities, so only check ranged single-target
	if (!AbilityState.IsMeleeAbility() && bIsPrimaryTarget)
	{
		TargetUnit.GetUnitValue(default.DeflectUsed, DeflectValue);
		//	check reflect first, and if the roll fails, don't attempt to deflect
		if (TargetUnit.HasSoldierAbility('LightsaberReflect') && int(DeflectValue.fValue) < default.NUM_OF_DEFLECTS)
		{
			NewHitResult = eHit_Reflect;
			return true;
		}
		//	if reflect couldn't happen, check for deflect
		else if (int(DeflectValue.fValue) < default.NUM_OF_DEFLECTS ||
				(TargetUnit.HasSoldierAbility('LightsaberReflect') && int(DeflectValue.fValue) < default.NUM_OF_DEFLECTS + 1))
		{
			//`log("Unit does not have LightsaberReflect", , 'X2JediClassWOTC');
			NewHitResult = eHit_Reflect;
			return true;
		}
		else
		{
			//`log("Unit has LightsaberDeflected the maximum number of times this turn.", , 'X2JediClassWOTC');
		}
	}
	else
	{
		//`log("Ability is a melee attack or an AOE attack - cannot be LightsaberReflected or LightsaberDeflected.", , 'X2JediClassWOTC');
	}

	return false;
}

defaultproperties
{
	DeflectUsed="DeflectUsed"
	EffectName="LightsaberRedirect"
	DuplicateResponse=eDupe_Ignore
	bReflect = false;
}