class X2Ability_LightsaberComponent extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(HealthRegenAbility('One', 1));
	Templates.AddItem(HealthRegenAbility('Two', 2));
	Templates.AddItem(HealthRegenAbility('Three', 3));

	Templates.AddItem(DeflectBonusAbility('Five', 5));
	Templates.AddItem(DeflectBonusAbility('Ten', 10));
	Templates.AddItem(DeflectBonusAbility('Fifteen', 15));
	Templates.AddItem(DeflectBonusAbility('Twenty', 20));
	Templates.AddItem(DeflectBonusAbility('Twentyfive', 25));

	return Templates;
}

static function X2DataTemplate HealthRegenAbility(name Append, int Bonus)
{
	local X2AbilityTemplate			Template;
	local X2Effect_Regeneration		RegenEffect;

	Template = PurePassive(name("HealthRegen" $ Append),,,,false);

	RegenEffect = new class'X2Effect_Regeneration';
	RegenEffect.BuildPersistentEffect(1, true, false);
	RegenEffect.HealAmount = Bonus;
	RegenEffect.MaxHealAmount = 1000; // In terms of HP/mission, effectively infinite
	RegenEffect.HealthRegeneratedName = 'CrystalRegen';
	Template.AddTargetEffect(RegenEffect);

	return Template;
}

static function X2DataTemplate DeflectBonusAbility(name Append, int Bonus)
{
	local X2AbilityTemplate				Template;
	local X2Effect_ExtraDeflectChance	DeflectChanceEffect;
	
	Template = PurePassive(name("DeflectBonus" $ Append),,,,false);

	DeflectChanceEffect = new class'X2Effect_ExtraDeflectChance';
	DeflectChanceEffect.BuildPersistentEffect(1);
	DeflectChanceEffect.DeflectBonus = Bonus;
	Template.AddTargetEffect(DeflectChanceEffect);

	return Template;
}