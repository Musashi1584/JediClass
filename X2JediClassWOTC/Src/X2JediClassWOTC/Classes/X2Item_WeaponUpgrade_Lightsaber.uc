class X2Item_WeaponUpgrade_Lightsaber extends X2Item config(JediUpgrades);

struct UpgradeSetup
{
	var name				UpgradeName;
	var string				ImagePath;
	var string				MeshPath;
	var string				IconPath;
	var int					Tier;
	var int					UpgradeValue;
	var int					AimBonus;
	var int					CritChanceBonus;
	var array<ArtifactCost>	ResourceCosts;
	var array<ArtifactCost>	ArtifactCosts;
	var array<name>			RequiredTechs;
	var WeaponDamageValue	DamageValue;
	var array<name>			BonusAbilities;
};

var config bool bLogUpgrades;
var config array<UpgradeSetup>	CRYSTAL_SETUPS, CELL_SETUPS, EMITTER_SETUPS, LENS_SETUPS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local UpgradeSetup			ThisUpgradeSetup;

	// Lightsaber Crystals
	foreach default.CRYSTAL_SETUPS(ThisUpgradeSetup)
		Templates.AddItem(CreateJediUpgrade('Crystal', ThisUpgradeSetup));

	// Lightsaber Power Cells
	foreach default.CELL_SETUPS(ThisUpgradeSetup)
		Templates.AddItem(CreateJediUpgrade('Cell', ThisUpgradeSetup));

	// Lightsaber Emitters
	foreach default.EMITTER_SETUPS(ThisUpgradeSetup)
		Templates.AddItem(CreateJediUpgrade('Emitter', ThisUpgradeSetup));

	// Lightsaber Lenses
	foreach default.LENS_SETUPS(ThisUpgradeSetup)
		Templates.AddItem(CreateJediUpgrade('Lens', ThisUpgradeSetup));

	return Templates;
}

// #######################################################################################
// -------------------- TEMPLATE FUNCTION ------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateJediUpgrade(name SocketName, UpgradeSetup ThisUpgradeSetup)
{
	local X2WeaponUpgradeTemplate	Template;
	local name						AbilityName, SaberName;
	local UpgradeSetup				TypeSetup;
	
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, ThisUpgradeSetup.UpgradeName);
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.strImage = ThisUpgradeSetup.ImagePath;
	Template.TradingPostValue = ThisUpgradeSetup.UpgradeValue;
	Template.Tier = ThisUpgradeSetup.Tier;
	
	`log("-------------------------------------------------------------------------", default.bLogUpgrades, 'X2JediClassWOTC');
	`log(default.class @ GetFuncName() @ "setting up" @ ThisUpgradeSetup.UpgradeName, default.bLogUpgrades, 'X2JediClassWOTC');
	`log(default.class @ GetFuncName() @ "SocketName" @ SocketName, default.bLogUpgrades, 'X2JediClassWOTC');

	Template.CHBonusDamage = ThisUpgradeSetup.DamageValue;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	
	`log(default.class @ GetFuncName() @ "AimBonus" @ ThisUpgradeSetup.AimBonus, default.bLogUpgrades, 'X2JediClassWOTC');

	if (ThisUpgradeSetup.AimBonus > 0)
	{
		Template.AimBonus = ThisUpgradeSetup.AimBonus;
		Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	}
	
	`log(default.class @ GetFuncName() @ "CritBonus" @ ThisUpgradeSetup.CritChanceBonus, default.bLogUpgrades, 'X2JediClassWOTC');
	
	if (ThisUpgradeSetup.CritChanceBonus > 0)
	{
		Template.CritBonus = ThisUpgradeSetup.AimBonus;
		Template.AddCritChanceModifierFn = CritUpgradeModifier;
	}

	foreach ThisUpgradeSetup.BonusAbilities(AbilityName)
	{
		`log(default.class @ GetFuncName() @ "Bonus Ability" @ AbilityName, default.bLogUpgrades, 'X2JediClassWOTC');
		Template.BonusAbilities.AddItem(AbilityName);
	}

	switch (SocketName)
	{
		case 'Crystal':
			foreach default.CRYSTAL_SETUPS(TypeSetup)
			{
				Template.MutuallyExclusiveUpgrades.AddItem(TypeSetup.UpgradeName);
			}
			break;
		case 'Cell':
			foreach default.CELL_SETUPS(TypeSetup)
			{
				Template.MutuallyExclusiveUpgrades.AddItem(TypeSetup.UpgradeName);
			}
			break;
		case 'Emitter':
			foreach default.EMITTER_SETUPS(TypeSetup)
			{
				Template.MutuallyExclusiveUpgrades.AddItem(TypeSetup.UpgradeName);
			}
			break;
		case 'Lens':
			foreach default.LENS_SETUPS(TypeSetup)
			{
				Template.MutuallyExclusiveUpgrades.AddItem(TypeSetup.UpgradeName);
			}
	}

	foreach class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES(SaberName)
	{
		Template.AddUpgradeAttachment(SocketName, 'UIPawnLocation_WeaponUpgrade_Shotgun', ThisUpgradeSetup.MeshPath, "", SaberName, , "", ThisUpgradeSetup.ImagePath, ThisUpgradeSetup.IconPath);
	}
	
	`log(default.class @ GetFuncName() @ "ResourceCosts 0 index check" @ ThisUpgradeSetup.ResourceCosts[0].ItemTemplateName, default.bLogUpgrades, 'X2JediClassWOTC');
	`log(default.class @ GetFuncName() @ "ArtifactCosts 0 index check" @ ThisUpgradeSetup.ArtifactCosts[0].ItemTemplateName, default.bLogUpgrades, 'X2JediClassWOTC');
	`log(default.class @ GetFuncName() @ "RequiredTechs 0 index check" @ ThisUpgradeSetup.RequiredTechs[0], default.bLogUpgrades, 'X2JediClassWOTC');

	if (ThisUpgradeSetup.ResourceCosts[0].ItemTemplateName != '' || ThisUpgradeSetup.ArtifactCosts[0].ItemTemplateName != '')
	{
		Template.CanBeBuilt = true;
		Template.PointsToComplete = 0;
		Template.Cost.ResourceCosts = ThisUpgradeSetup.ResourceCosts;
		Template.Cost.ArtifactCosts = ThisUpgradeSetup.ArtifactCosts;

		if (ThisUpgradeSetup.RequiredTechs[0] != '')
		{
			Template.Requirements.RequiredTechs = ThisUpgradeSetup.RequiredTechs;
		}
	}
	
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponLightsaber;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;
	Template.UpgradeCats.AddItem('lightsaber');
	
	`log(default.class @ GetFuncName() @ "finished setting up" @ ThisUpgradeSetup.UpgradeName, default.bLogUpgrades, 'X2JediClassWOTC');

	return Template;
}

// #######################################################################################
// -------------------- UPGRADE FUNCTIONS ------------------------------------------------
// #######################################################################################

static function bool CanApplyUpgradeToWeaponLightsaber(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();

	if ( Weapon.GetWeaponCategory() != 'lightsaber' )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

static function bool DamageUpgradeModifier(X2WeaponUpgradeTemplate UpgradeTemplate, out int DamageMod, name StatType)
{
	switch (StatType)
	{
		case 'Damage':
			DamageMod = UpgradeTemplate.CHBonusDamage.Damage;
			return true;
		case 'Spread':
			DamageMod = UpgradeTemplate.CHBonusDamage.Spread;
			return true;
		case 'Crit':
			DamageMod = UpgradeTemplate.CHBonusDamage.Crit;
			return true;
		case 'Pierce':
			DamageMod = UpgradeTemplate.CHBonusDamage.Pierce;
			return true;
		case 'Rupture':
			DamageMod = UpgradeTemplate.CHBonusDamage.Rupture;
			return true;
		case 'Shred':
			DamageMod = UpgradeTemplate.CHBonusDamage.Shred;
			return true;
		default:
			return false;
	}
}

static function bool AimUpgradeHitModifier(X2WeaponUpgradeTemplate UpgradeTemplate, const GameRulesCache_VisibilityInfo VisInfo, out int HitChanceMod)
{
	HitChanceMod = UpgradeTemplate.AimBonus;
	return true;
}

static function bool CritUpgradeModifier(X2WeaponUpgradeTemplate UpgradeTemplate, out int CritChanceMod)
{
	CritChanceMod = UpgradeTemplate.CritBonus;
	return true;
}