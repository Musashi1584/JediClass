class X2Effect_PrimaryTargetGuaranteedHit extends X2Effect_Persistent;

var name Ability;

var private XComGameStateContext_Ability AbilityContext;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
}

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local XComGameState_Item		SourceWeapon;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if(SourceWeapon == none)
		return false;

	//  change any miss into a hit, if we haven't already done that this turn
	if (AbilityState.GetMyTemplateName() == Ability &&
		!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult) &&
		AbilityContext.InputContext.PrimaryTarget.ObjectID == TargetUnit.ObjectID)
	{
		`LOG("X2Effect_PrimaryTargetGuaranteedHit Convert miss to hit",, 'PrimaryMeleeWeapons');
		NewHitResult = eHit_Success;
		return true;
	}

	return false;
}


defaultproperties
{
	iHitBonus = 50
}