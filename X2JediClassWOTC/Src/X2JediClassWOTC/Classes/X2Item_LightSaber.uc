class X2Item_LightSaber extends X2Item config (JediClass);

var config WeaponDamageValue LIGHTSABER_CONVENTIONAL_BASEDAMAGE;
var config int  LIGHTSABER_CONVENTIONAL_AIM;
var config int  LIGHTSABER_CONVENTIONAL_CRITCHANCE;
var config int  LIGHTSABER_CONVENTIONAL_ICLIPSIZE;
var config int  LIGHTSABER_CONVENTIONAL_ISOUNDRANGE;
var config int  LIGHTSABER_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int  LIGHTSABER_CONVENTIONAL_UPGRADESLOTS;
var config array<name> LIGHTSABER_CONVENTIONAL_ABILITIES;

var config WeaponDamageValue LIGHTSABER_MAGNETIC_BASEDAMAGE;
var config int  LIGHTSABER_MAGNETIC_AIM;
var config int  LIGHTSABER_MAGNETIC_CRITCHANCE;
var config int  LIGHTSABER_MAGNETIC_ICLIPSIZE;
var config int  LIGHTSABER_MAGNETIC_ISOUNDRANGE;
var config int  LIGHTSABER_MAGNETIC_IENVIRONMENTDAMAGE;
var config int  LIGHTSABER_MAGNETIC_UPGRADESLOTS;
var config array<name> LIGHTSABER_MAGNETIC_ABILITIES;

var config WeaponDamageValue LIGHTSABER_BEAM_BASEDAMAGE;
var config int  LIGHTSABER_BEAM_AIM;
var config int  LIGHTSABER_BEAM_CRITCHANCE;
var config int  LIGHTSABER_BEAM_ICLIPSIZE;
var config int  LIGHTSABER_BEAM_ISOUNDRANGE;
var config int  LIGHTSABER_BEAM_IENVIRONMENTDAMAGE;
var config int  LIGHTSABER_BEAM_UPGRADESLOTS;
var config array<name> LIGHTSABER_BEAM_ABILITIES;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	// Lightsabers
	Weapons.AddItem(CreateTemplate_LightSaber_ConventionalPrimary());
	Weapons.AddItem(CreateTemplate_LightSaber_MagneticPrimary());
	Weapons.AddItem(CreateTemplate_LightSaber_BeamPrimary());

	//Schematics
	Weapons.AddItem(CreateTemplate_LightSaber_Magnetic_Schematic());
	Weapons.AddItem(CreateTemplate_LightSaber_Beam_Schematic());
	
	return Weapons;
}
static function X2DataTemplate CreateTemplate_LightSaber_ConventionalPrimary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LightSaber_CV_Primary');
	Template.GameplayInstanceClass = class'XGLightSaber';
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lightsaber';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LightSaber_CV.Archetypes.WP_LightSaber_CV";
	//Template.AddDefaultAttachment('Sheath', "ConvSword.Meshes.SM_ConvSword_Sheath", true);
	Template.Tier = 0;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = default.LIGHTSABER_CONVENTIONAL_UPGRADESLOTS;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 0;

	Template.iRange = 0;
	Template.BaseDamage = default.LIGHTSABER_CONVENTIONAL_BASEDAMAGE;
	
	Template.Aim = default.LIGHTSABER_CONVENTIONAL_AIM;
	Template.CritChance = default.LIGHTSABER_CONVENTIONAL_CRITCHANCE;
	Template.iSoundRange = default.LIGHTSABER_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LIGHTSABER_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	AddConfigAbilities(Template, default.LIGHTSABER_CONVENTIONAL_ABILITIES);

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_LightSaber_MagneticPrimary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LightSaber_MG_Primary');
	Template.GameplayInstanceClass = class'XGLightSaber';
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lightsaber';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LightSaber_CV.Archetypes.WP_LightSaber_CV";
	//Template.AddDefaultAttachment('R_Back', "MagSword.Meshes.SM_MagSword_Sheath", false);
	Template.Tier = 1;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = default.LIGHTSABER_MAGNETIC_UPGRADESLOTS;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 0;

	Template.iRange = 0;
	Template.BaseDamage = default.LIGHTSABER_MAGNETIC_BASEDAMAGE;
	
	Template.Aim = default.LIGHTSABER_MAGNETIC_AIM;
	Template.CritChance = default.LIGHTSABER_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = default.LIGHTSABER_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LIGHTSABER_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType='Melee';
	Template.DamageTypeTemplateName = 'Melee';
	
	AddConfigAbilities(Template, default.LIGHTSABER_MAGNETIC_ABILITIES);

	Template.BaseItem = 'LightSaber_CV_Primary'; // Which item this will be upgraded from
	
	Template.DamageTypeTemplateName = 'Melee';
	Template.BaseDamage.DamageType = 'Melee';

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_LightSaber_Magnetic_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'LightSaber_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'LightSaber_MG_Primary';
	Template.HideIfPurchased = 'LightSaber_CV_Primary';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Artifacts.ItemTemplateName = 'CorpseAdventStunLancer';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_LightSaber_BeamPrimary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LightSaber_BM_Primary');
	Template.GameplayInstanceClass = class'XGLightSaber';
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lightsaber';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LightSaber_CV.Archetypes.WP_LightSaber_CV";
	//Template.AddDefaultAttachment('R_Back', "BeamSword.Meshes.SM_BeamSword_Sheath", false);
	Template.Tier = 2;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = default.LIGHTSABER_BEAM_UPGRADESLOTS;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 0;

	Template.iRange = 0;
	Template.BaseDamage = default.LIGHTSABER_BEAM_BASEDAMAGE;
	
	Template.Aim = default.LIGHTSABER_BEAM_AIM;
	Template.CritChance = default.LIGHTSABER_BEAM_CRITCHANCE;
	Template.iSoundRange = default.LIGHTSABER_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LIGHTSABER_BEAM_IENVIRONMENTDAMAGE;
	
	AddConfigAbilities(Template, default.LIGHTSABER_BEAM_ABILITIES);

	Template.BaseItem = 'LightSaber_MG_Primary'; // Which item this will be upgraded from
	
	Template.BaseDamage.DamageType='Melee';
	Template.DamageTypeTemplateName = 'Melee';

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	return Template;
}

static function X2DataTemplate CreateTemplate_LightSaber_Beam_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'LightSaber_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'LightSaber_BM_Primary';
	Template.HideIfPurchased = 'LightSaber_MG_Primary';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Artifacts.ItemTemplateName = 'CorpseArchon';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 150;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function AddConfigAbilities(out X2WeaponTemplate Template, array<name> Abilities)
{
	local name Ability;
	foreach Abilities (Ability)
	{
		Template.Abilities.AddItem(Ability);
	}
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
