class X2Item_SaberStaff extends X2Item config (JediClass);

var config WeaponDamageValue SABERSTAFF_CV_BASEDAMAGE;
var config int SABERSTAFF_CV_AIM;
var config int SABERSTAFF_CV_CRITCHANCE;
var config int SABERSTAFF_CV_ICLIPSIZE;
var config int SABERSTAFF_CV_ISOUNDRANGE;
var config int SABERSTAFF_CV_IENVIRONMENTDAMAGE;
var config int SABERSTAFF_CV_IPOINTS;

var config WeaponDamageValue SABERSTAFF_MAGNETIC_BASEDAMAGE;
var config int SABERSTAFF_MAGNETIC_AIM;
var config int SABERSTAFF_MAGNETIC_CRITCHANCE;
var config int SABERSTAFF_MAGNETIC_ICLIPSIZE;
var config int SABERSTAFF_MAGNETIC_ISOUNDRANGE;
var config int SABERSTAFF_MAGNETIC_IENVIRONMENTDAMAGE;
var config int SABERSTAFF_MAGNETIC_IPOINTS;

var config WeaponDamageValue SABERSTAFF_BEAM_BASEDAMAGE;
var config int SABERSTAFF_BEAM_AIM;
var config int SABERSTAFF_BEAM_CRITCHANCE;
var config int SABERSTAFF_BEAM_ICLIPSIZE;
var config int SABERSTAFF_BEAM_ISOUNDRANGE;
var config int SABERSTAFF_BEAM_IENVIRONMENTDAMAGE;
var config int SABERSTAFF_BEAM_IPOINTS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModWeapons;

	ModWeapons.AddItem(CreateTemplate_Saberstaff_CV());
	ModWeapons.AddItem(CreateTemplate_Saberstaff_MG());
	ModWeapons.AddItem(CreateTemplate_Saberstaff_BM());

	return ModWeapons;
}


static function X2DataTemplate CreateTemplate_Saberstaff_CV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Saberstaff_CV');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'saberstaff';
	Template.WeaponTech = 'conventional';
	//Template.strImage = "img:///WP_WOTC_LightSaber_CV.LightsaberIcon";
	Template.strImage = "img:///saberstaff.UI.SaberstaffUI";

	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "SaberStaff.Archetypes.WP_Saberstaff_CV";

	Template.Tier = 0;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.SABERSTAFF_CV_BASEDAMAGE;

	Template.Aim = default.SABERSTAFF_CV_AIM;
	Template.CritChance = default.SABERSTAFF_CV_CRITCHANCE;
	Template.iSoundRange = default.SABERSTAFF_CV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SABERSTAFF_CV_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';
	
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	
	Template.bInfiniteItem = true;
	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;

}

static function X2DataTemplate CreateTemplate_Saberstaff_MG()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Saberstaff_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'saberstaff';
	Template.WeaponTech = 'conventional';
	//Template.strImage = "img:///WP_WOTC_LightSaber_CV.LightsaberIcon";
	Template.strImage = "img:///saberstaff.UI.SaberstaffUI";

	Template.EquipSound = "Sword_Equip_Magnetic";

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "SaberStaff.Archetypes.WP_Saberstaff_CV";

	Template.Tier = 2;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.SABERSTAFF_MAGNETIC_BASEDAMAGE;

	Template.Aim = default.SABERSTAFF_MAGNETIC_AIM;
	Template.CritChance = default.SABERSTAFF_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = default.SABERSTAFF_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SABERSTAFF_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.CreatorTemplateName = 'WOTCSaberstaff_Magnetic_Schematic'; // The schematic which creates this item

	Template.BaseItem = 'Saberstaff_CV'; // Which item this will be upgraded from
		
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	//Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_STUNCHANCE));
		
	Template.bInfiniteItem = true;
	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;

}

static function X2DataTemplate CreateTemplate_Saberstaff_BM()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Saberstaff_BM');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'saberstaff';
	Template.WeaponTech = 'conventional';
	//Template.strImage = "img:///WP_WOTC_LightSaber_CV.LightsaberIcon";
	Template.strImage = "img:///saberstaff.UI.SaberstaffUI";

	Template.EquipSound = "Sword_Equip_Magnetic";
	//Template.InventorySlot = eInvSlot_SecondaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;

	Template.GameArchetype = "SaberStaff.Archetypes.WP_Saberstaff_CV";

	Template.Tier = 4;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.SABERSTAFF_BEAM_BASEDAMAGE;

	Template.Aim = default.SABERSTAFF_BEAM_AIM;
	Template.CritChance = default.SABERSTAFF_BEAM_CRITCHANCE;
	Template.iSoundRange = default.SABERSTAFF_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SABERSTAFF_BEAM_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.CreatorTemplateName = 'WOTCSaberstaff_Beam_Schematic'; // The schematic which creates this item

	Template.BaseItem = 'Saberstaff_MG'; // Which item this will be upgraded from
		
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	//Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, class'X2Item_DefaultWeapons'.default.RANGERSWORD_MAGNETIC_STUNCHANCE));
	//Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(3, 0));
		
	Template.bInfiniteItem = true;
	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;

}
