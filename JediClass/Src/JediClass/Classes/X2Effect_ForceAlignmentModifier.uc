class X2Effect_ForceAlignmentModifier extends X2Effect_Persistent;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	ModInfo.ModType = eHit_Success;
	ModInfo.Reason = class'JediClassHelper'.static.GetForceAlignmentModifierString();
	ModInfo.Value = class'JediClassHelper'.static.GetSuccessModifier(Attacker, AbilityState.GetMyTemplateName());

	//`LOG("X2Effect_ForceAlignmentModifier ForceAlignmentModifier" @ ModInfo.Value,, 'JediClass');

	ShotModifiers.AddItem(ModInfo);
}