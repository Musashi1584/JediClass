class X2Effect_FlecheBonusDamage extends X2Effect_Persistent config(VoidStrike);

var config float BonusDmgPerTile;
var array<name> AbilityNames;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{ 
	local XComWorldData WorldData;
	local XComGameState_Unit TargetUnit;
	local float BonusDmg;
	local vector StartLoc, TargetLoc;

	TargetUnit = XComGameState_Unit(TargetDamageable);
	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		if (TargetUnit != none && AbilityNames.Find(AbilityState.GetMyTemplate().DataName) != -1)
		{
			WorldData = `XWORLD;
			StartLoc = WorldData.GetPositionFromTileCoordinates(Attacker.TurnStartLocation);
			TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
			BonusDmg = BonusDmgPerTile * VSize(StartLoc - TargetLoc)/ WorldData.WORLD_StepSize;
			//`LOG("Fleche StartLoc" @ StartLoc @ "TargetLoc" @ TargetLoc @  "Dist" @ VSize(StartLoc - TargetLoc) @ "* BonusDmgPerTile" @ BonusDmgPerTile @ "BonusDmg" @ BonusDmg,, 'JediClass');
			return int(BonusDmg);
		}
	}
	return 0; 
}