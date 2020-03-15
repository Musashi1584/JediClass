class X2AbilityToHitCalc_LightsaberDeflect extends X2AbilityToHitCalc;

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
	if (kAbility.GetMyTemplateName() == 'LightsaberDeflectShot')
	{
		ResultContext.HitResult = eHit_Miss;
	}

	if (kAbility.GetMyTemplateName() == 'LightsaberReflectShot')
	{
		ResultContext.HitResult = eHit_Success;
	}
}