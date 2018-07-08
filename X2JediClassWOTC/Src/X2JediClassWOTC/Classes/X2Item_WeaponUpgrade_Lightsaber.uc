class X2Item_WeaponUpgrade_Lightsaber extends X2Item config(JediClass);

var config int BASIC_UPGRADE_VALUE, ADVANCED_UPGRADE_VALUE, SUPERIOR_UPGRADE_VALUE, ULTIMATE_UPGRADE_VALUE;
var config array<ArtifactCost> BASIC_COSTS, ADVANCED_COSTS, SUPERIOR_COSTS, ULTIMATE_COSTS;

var config WeaponDamageValue DIAMOND_DAMAGE;
var config WeaponDamageValue ADEGAN_CRYSTAL_DAMAGE;
var config WeaponDamageValue ANKARRES_SAPPHIRE_DAMAGE;
var config WeaponDamageValue BARAB_ORE_INGOT_DAMAGE;
var config WeaponDamageValue BONDAR_CRYSTAL_DAMAGE;
var config WeaponDamageValue DAMIND_CRYSTAL_DAMAGE;
var config WeaponDamageValue DRAGITE_CRYSTAL_DAMAGE;
var config WeaponDamageValue ERALAM_CRYSTAL_DAMAGE;
var config WeaponDamageValue FIRKRANN_CRYSTAL_DAMAGE;
var config WeaponDamageValue HURRIKAINE_CRYSTAL_DAMAGE;
var config WeaponDamageValue JENRUAX_CRYSTAL_DAMAGE;
var config WeaponDamageValue KAIBURR_CRYSTAL_DAMAGE;
var config WeaponDamageValue KASHA_CRYSTAL_DAMAGE;
var config WeaponDamageValue LORRDIAN_GEMSTONE_DAMAGE;
var config WeaponDamageValue NEXTOR_CRYSTAL_DAMAGE;
var config WeaponDamageValue OPILA_CRYSTAL_DAMAGE;
var config WeaponDamageValue PHOND_CRYSTAL_DAMAGE;
var config WeaponDamageValue PONTITE_CRYSTAL_DAMAGE;
var config WeaponDamageValue QIXONI_CRYSTAL_DAMAGE;
var config WeaponDamageValue RUBAT_CRYSTAL_DAMAGE;
var config WeaponDamageValue RUUSAN_CRYSTAL_DAMAGE;
var config WeaponDamageValue SAPITH_CRYSTAL_DAMAGE;
var config WeaponDamageValue SIGIL_CRYSTAL_DAMAGE;
var config WeaponDamageValue SOLARI_CRYSTAL_DAMAGE;
var config WeaponDamageValue STYGIUM_CRYSTAL_DAMAGE;
var config WeaponDamageValue ULTIMA_PEARL_DAMAGE;
var config WeaponDamageValue UPARI_CRYSTAL_DAMAGE;
var config WeaponDamageValue VELMORITE_CRYSTAL_DAMAGE;

var config WeaponDamageValue DIATIUM_CELL_BSC_DAMAGE;
var config WeaponDamageValue DIATIUM_CELL_ADV_DAMAGE;
var config WeaponDamageValue DIATIUM_CELL_SUP_DAMAGE;
var config WeaponDamageValue DIATIUM_CELL_ULT_DAMAGE;
var config WeaponDamageValue DISCHARGE_CELL_BSC_DAMAGE;
var config WeaponDamageValue DISCHARGE_CELL_ADV_DAMAGE;
var config WeaponDamageValue DISCHARGE_CELL_SUP_DAMAGE;
var config WeaponDamageValue ION_CELL_BSC_DAMAGE;
var config WeaponDamageValue ION_CELL_ADV_DAMAGE;
var config WeaponDamageValue ION_CELL_SUP_DAMAGE;
var config WeaponDamageValue JOLT_CELL_BSC_DAMAGE;
var config WeaponDamageValue JOLT_CELL_ADV_DAMAGE;
var config WeaponDamageValue JOLT_CELL_SUP_DAMAGE;

var config WeaponDamageValue FOCUS_EMITTER_BSC_DAMAGE;
var config WeaponDamageValue FOCUS_EMITTER_ADV_DAMAGE;
var config WeaponDamageValue FOCUS_EMITTER_SUP_DAMAGE;
var config WeaponDamageValue DISRUPT_EMITTER_BSC_DAMAGE;
var config WeaponDamageValue DISRUPT_EMITTER_ADV_DAMAGE;
var config WeaponDamageValue DISRUPT_EMITTER_SUP_DAMAGE;
var config WeaponDamageValue PHOBIUM_EMITTER_BSC_DAMAGE;
var config WeaponDamageValue PHOBIUM_EMITTER_ADV_DAMAGE;
var config WeaponDamageValue PHOBIUM_EMITTER_SUP_DAMAGE;
var config WeaponDamageValue PHOBIUM_EMITTER_ULT_DAMAGE;
var config WeaponDamageValue FENCING_EMITTER_BSC_DAMAGE;
var config WeaponDamageValue FENCING_EMITTER_ADV_DAMAGE;
var config WeaponDamageValue FENCING_EMITTER_SUP_DAMAGE;

var config WeaponDamageValue BEAM_GEM_LENS_BSC_DAMAGE;
var config WeaponDamageValue BEAM_GEM_LENS_ADV_DAMAGE;
var config WeaponDamageValue BEAM_GEM_LENS_SUP_DAMAGE;
var config WeaponDamageValue BYROTHSIS_LENS_BSC_DAMAGE;
var config WeaponDamageValue BYROTHSIS_LENS_ADV_DAMAGE;
var config WeaponDamageValue BYROTHSIS_LENS_SUP_DAMAGE;
var config WeaponDamageValue DUELING_LENS_BSC_DAMAGE;
var config WeaponDamageValue DUELING_LENS_ADV_DAMAGE;
var config WeaponDamageValue DUELING_LENS_SUP_DAMAGE;
var config WeaponDamageValue DUELING_LENS_ULT_DAMAGE;
var config WeaponDamageValue VIBRATION_LENS_BSC_DAMAGE;
var config WeaponDamageValue VIBRATION_LENS_ADV_DAMAGE;
var config WeaponDamageValue VIBRATION_LENS_SUP_DAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Lightsaber Crystals
	Templates.AddItem(CreateDiamond());
	Templates.AddItem(CreateAdeganCrystal());
	Templates.AddItem(CreateAnkarresSapphire());
	Templates.AddItem(CreateBarabOreIngot());
	Templates.AddItem(CreateBondarCrystal());
	Templates.AddItem(CreateDamindCrystal());
	Templates.AddItem(CreateDragiteCrystal());
	Templates.AddItem(CreateEralamCrystal());
	Templates.AddItem(CreateFirkrannCrystal());
	Templates.AddItem(CreateHurrikaineCrystal());
	Templates.AddItem(CreateJenruaxCrystal());
	Templates.AddItem(CreateKaiburrCrystal());
	Templates.AddItem(CreateKashaCrystal());
	Templates.AddItem(CreateLorrdianGemstone());
	Templates.AddItem(CreateNextorCrystal());
	Templates.AddItem(CreateOpilaCrystal());
	Templates.AddItem(CreatePhondCrystal());
	Templates.AddItem(CreatePontiteCrystal());
	Templates.AddItem(CreateQixoniCrystal());
	Templates.AddItem(CreateRubatCrystal());
	Templates.AddItem(CreateRuusanCrystal());
	Templates.AddItem(CreateSapithCrystal());
	Templates.AddItem(CreateSigilCrystal());
	Templates.AddItem(CreateSolariCrystal());
	Templates.AddItem(CreateStygiumCrystal());
	Templates.AddItem(CreateUltimaPearl());
	Templates.AddItem(CreateUpariCrystal());
	Templates.AddItem(CreateVelmoriteCrystal());

	// Lightsaber Power Cells
	Templates.AddItem(CreateDiatiumCell_Bsc());
	Templates.AddItem(CreateDiatiumCell_Adv());
	Templates.AddItem(CreateDiatiumCell_Sup());
	Templates.AddItem(CreateDiatiumCell_Ult());
	Templates.AddItem(CreateDischargeCell_Bsc());
	Templates.AddItem(CreateDischargeCell_Adv());
	Templates.AddItem(CreateDischargeCell_Sup());
	Templates.AddItem(CreateIonCell_Bsc());
	Templates.AddItem(CreateIonCell_Adv());
	Templates.AddItem(CreateIonCell_Sup());
	Templates.AddItem(CreateJoltCell_Bsc());
	Templates.AddItem(CreateJoltCell_Adv());
	Templates.AddItem(CreateJoltCell_Sup());

	// Lightsaber Emitters
	Templates.AddItem(CreateFocusEmitter_Bsc());
	Templates.AddItem(CreateFocusEmitter_Adv());
	Templates.AddItem(CreateFocusEmitter_Sup());
	Templates.AddItem(CreateDisruptEmitter_Bsc());
	Templates.AddItem(CreateDisruptEmitter_Adv());
	Templates.AddItem(CreateDisruptEmitter_Sup());
	Templates.AddItem(CreatePhobiumEmitter_Bsc());
	Templates.AddItem(CreatePhobiumEmitter_Adv());
	Templates.AddItem(CreatePhobiumEmitter_Sup());
	Templates.AddItem(CreatePhobiumEmitter_Ult());
	Templates.AddItem(CreateFencingEmitter_Bsc());
	Templates.AddItem(CreateFencingEmitter_Adv());
	Templates.AddItem(CreateFencingEmitter_Sup());

	// Lightsaber Lenses
	Templates.AddItem(CreateBeamGemLens_Bsc());
	Templates.AddItem(CreateBeamGemLens_Adv());
	Templates.AddItem(CreateBeamGemLens_Sup());
	Templates.AddItem(CreateByrothsisLens_Bsc());
	Templates.AddItem(CreateByrothsisLens_Adv());
	Templates.AddItem(CreateByrothsisLens_Sup());
	Templates.AddItem(CreateDuelingLens_Bsc());
	Templates.AddItem(CreateDuelingLens_Adv());
	Templates.AddItem(CreateDuelingLens_Sup());
	Templates.AddItem(CreateDuelingLens_Ult());
	Templates.AddItem(CreateVibrationLens_Bsc());
	Templates.AddItem(CreateVibrationLens_Adv());
	Templates.AddItem(CreateVibrationLens_Sup());

	return Templates;
}

// #######################################################################################
// -------------------- TEMPLATE FUNCTIONS -----------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateDiamond()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDiamond');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.DIAMOND_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateAdeganCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeAdeganCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.ADEGAN_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateAnkarresSapphire()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeAnkarresSapphire');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.ANKARRES_SAPPHIRE_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 3;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 10;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.BonusAbilities.AddItem('HealthRegenOne');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateBarabOreIngot()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeBarabOreIngot');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.BARAB_ORE_INGOT_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateBondarCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeBondarCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.BONDAR_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.BonusAbilities.AddItem('DeflectBonusTen');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateDamindCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDamindCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.DAMIND_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 15;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateDragiteCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDragiteCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.DRAGITE_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateEralamCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeEralamCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.ERALAM_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 10;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateFirkrannCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeFirkrannCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.FIRKRANN_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 10;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateHurrikaineCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeHurrikaineCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.HURRIKAINE_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateJenruaxCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeJenruaxCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.JENRUAX_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.BonusAbilities.AddItem('DeflectBonusTwentyfive');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateKaiburrCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeKaiburrCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.KAIBURR_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.BonusAbilities.AddItem('HealthRegenThree');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateKashaCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeKashaCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.KASHA_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateLorrdianGemstone()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeLorrdianGemstone');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.LORRDIAN_GEMSTONE_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.BonusAbilities.AddItem('DeflectBonusFifteen');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateNextorCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeNextorCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.NEXTOR_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.CritBonus = 10;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateOpilaCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeOpilaCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.OPILA_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreatePhondCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradePhondCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.PHOND_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreatePontiteCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradePontiteCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.PONTITE_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateQixoniCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeQixoniCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.QIXONI_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateRubatCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeRubatCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.RUBAT_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateRuusanCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeRuusanCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.RUUSAN_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateSapithCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeSapithCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.SAPITH_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 10;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateSigilCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeSigilCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.SIGIL_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateSolariCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeSolariCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.SOLARI_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 15;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateStygiumCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeStygiumCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.STYGIUM_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.CritBonus = 10;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateUltimaPearl()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeUltimaPearl');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.ULTIMA_PEARL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 15;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateUpariCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeUpariCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.UPARI_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 15;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateVelmoriteCrystal()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeVelmoriteCrystal');
	SetUpLightsaberUpgrade(Template, 'Crystal');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	
	Template.CHBonusDamage = default.VELMORITE_CRYSTAL_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.CritBonus = 13;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv";

	return Template;
}

static function X2DataTemplate CreateDiatiumCell_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDiatiumCell_Bsc');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DIATIUM_CELL_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_diatiumcell";

	return Template;
}

static function X2DataTemplate CreateDiatiumCell_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDiatiumCell_Adv');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DIATIUM_CELL_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_diatiumcell";

	return Template;
}

static function X2DataTemplate CreateDiatiumCell_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDiatiumCell_Sup');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DIATIUM_CELL_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_diatiumcell";

	return Template;
}

static function X2DataTemplate CreateDiatiumCell_Ult()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDiatiumCell_Ult');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ULTIMATE_UPGRADE_VALUE;
	Template.Tier = 3;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ULTIMATE_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyGatekeeper');
	Template.Requirements.RequiredEngineeringScore = 30;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DIATIUM_CELL_ULT_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_diatiumcell";

	return Template;
}

static function X2DataTemplate CreateDischargeCell_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDischargeCell_Bsc');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DISCHARGE_CELL_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_dischargecell";

	return Template;
}

static function X2DataTemplate CreateDischargeCell_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDischargeCell_Adv');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DISCHARGE_CELL_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_dischargecell";

	return Template;
}

static function X2DataTemplate CreateDischargeCell_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDischargeCell_Sup');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DISCHARGE_CELL_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_dischargecell";

	return Template;
}

static function X2DataTemplate CreateIonCell_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeIonCell_Bsc');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.ION_CELL_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_ioncell";

	return Template;
}

static function X2DataTemplate CreateIonCell_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeIonCell_Adv');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.ION_CELL_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_ioncell";

	return Template;
}

static function X2DataTemplate CreateIonCell_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeIonCell_Sup');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.ION_CELL_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_ioncell";

	return Template;
}

static function X2DataTemplate CreateJoltCell_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeJoltCell_Bsc');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.JOLT_CELL_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.CritBonus = 10;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_joltcell";

	return Template;
}

static function X2DataTemplate CreateJoltCell_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeJoltCell_Adv');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.JOLT_CELL_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.CritBonus = 15;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_joltcell";

	return Template;
}

static function X2DataTemplate CreateJoltCell_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeJoltCell_Sup');
	SetUpLightsaberUpgrade(Template, 'Cell');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.JOLT_CELL_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.CritBonus = 20;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Cell.upgrade_joltcell";

	return Template;
}

static function X2DataTemplate CreateFocusEmitter_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeFocusEmitter_Bsc');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.FOCUS_EMITTER_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_focusemitter";

	return Template;
}

static function X2DataTemplate CreateFocusEmitter_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeFocusEmitter_Adv');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.FOCUS_EMITTER_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_focusemitter";

	return Template;
}

static function X2DataTemplate CreateFocusEmitter_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeFocusEmitter_Sup');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.FOCUS_EMITTER_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_focusemitter";

	return Template;
}

static function X2DataTemplate CreateDisruptEmitter_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDisruptEmitter_Bsc');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DISRUPT_EMITTER_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_disruptemitter";

	return Template;
}

static function X2DataTemplate CreateDisruptEmitter_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDisruptEmitter_Adv');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DISRUPT_EMITTER_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_disruptemitter";

	return Template;
}

static function X2DataTemplate CreateDisruptEmitter_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDisruptEmitter_Sup');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DISRUPT_EMITTER_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_disruptemitter";

	return Template;
}

static function X2DataTemplate CreatePhobiumEmitter_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradePhobiumEmitter_Bsc');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.PHOBIUM_EMITTER_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_phobiumemitter";

	return Template;
}

static function X2DataTemplate CreatePhobiumEmitter_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradePhobiumEmitter_Adv');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.PHOBIUM_EMITTER_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 10;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 10;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_phobiumemitter";

	return Template;
}

static function X2DataTemplate CreatePhobiumEmitter_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradePhobiumEmitter_Sup');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.PHOBIUM_EMITTER_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 10;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 15;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_phobiumemitter";

	return Template;
}

static function X2DataTemplate CreatePhobiumEmitter_Ult()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradePhobiumEmitter_Ult');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ULTIMATE_UPGRADE_VALUE;
	Template.Tier = 3;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ULTIMATE_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyGatekeeper');
	Template.Requirements.RequiredEngineeringScore = 30;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.PHOBIUM_EMITTER_ULT_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 15;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 20;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_phobiumemitter";

	return Template;
}

static function X2DataTemplate CreateFencingEmitter_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeFencingEmitter_Bsc');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.FENCING_EMITTER_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_fencingemitter";

	return Template;
}

static function X2DataTemplate CreateFencingEmitter_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeFencingEmitter_Adv');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.FENCING_EMITTER_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 10;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_fencingemitter";

	return Template;
}

static function X2DataTemplate CreateFencingEmitter_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeFencingEmitter_Sup');
	SetUpLightsaberUpgrade(Template, 'Emitter');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.FENCING_EMITTER_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 15;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Emitter.upgrade_fencingemitter";

	return Template;
}

static function X2DataTemplate CreateBeamGemLens_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeBeamGemLens_Bsc');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.BEAM_GEM_LENS_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 10;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_beamgemlens";

	return Template;
}

static function X2DataTemplate CreateBeamGemLens_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeBeamGemLens_Adv');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.BEAM_GEM_LENS_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 15;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_beamgemlens";

	return Template;
}

static function X2DataTemplate CreateBeamGemLens_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeBeamGemLens_Sup');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.BEAM_GEM_LENS_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 20;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_beamgemlens";

	return Template;
}

static function X2DataTemplate CreateByrothsisLens_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeByrothsisLens_Bsc');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.SUPERIOR_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.BYROTHSIS_LENS_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 10;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_byrothsislens";

	return Template;
}

static function X2DataTemplate CreateByrothsisLens_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeByrothsisLens_Adv');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.BYROTHSIS_LENS_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 15;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_byrothsislens";

	return Template;
}

static function X2DataTemplate CreateByrothsisLens_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeByrothsisLens_Sup');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.BYROTHSIS_LENS_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 20;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_byrothsislens";

	return Template;
}

static function X2DataTemplate CreateDuelingLens_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDuelingLens_Bsc');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DUELING_LENS_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 10;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_duelinglens";

	return Template;
}

static function X2DataTemplate CreateDuelingLens_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDuelingLens_Adv');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DUELING_LENS_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 15;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_duelinglens";

	return Template;
}

static function X2DataTemplate CreateDuelingLens_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDuelingLens_Sup');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DUELING_LENS_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 20;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_duelinglens";

	return Template;
}

static function X2DataTemplate CreateDuelingLens_Ult()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeDuelingLens_Ult');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ULTIMATE_UPGRADE_VALUE;
	Template.Tier = 3;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ULTIMATE_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyGatekeeper');
	Template.Requirements.RequiredEngineeringScore = 30;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.DUELING_LENS_ULT_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 25;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_duelinglens";

	return Template;
}

static function X2DataTemplate CreateVibrationLens_Bsc()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeVibrationLens_Bsc');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 0;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.BASIC_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.VIBRATION_LENS_BSC_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_vibrationlens";

	return Template;
}

static function X2DataTemplate CreateVibrationLens_Adv()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeVibrationLens_Adv');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.ADVANCED_UPGRADE_VALUE;
	Template.Tier = 1;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.ADVANCED_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.VIBRATION_LENS_ADV_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_vibrationlens";

	return Template;
}

static function X2DataTemplate CreateVibrationLens_Sup()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'UpgradeVibrationLens_Sup');
	SetUpLightsaberUpgrade(Template, 'Lens');

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';
	Template.TradingPostValue = default.BASIC_UPGRADE_VALUE;
	Template.Tier = 2;
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	foreach default.SUPERIOR_COSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	Template.CHBonusDamage = default.VIBRATION_LENS_SUP_DAMAGE;
	Template.AddCHDamageModifierFn = DamageUpgradeModifier;
	Template.AimBonus = 5;
	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.CritBonus = 5;
	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.strImage = "img:///JediClassWeaponUpgrades.Lens.upgrade_vibrationlens";

	return Template;
}

// #######################################################################################
// -------------------- UPGRADE FUNCTIONS ------------------------------------------------
// #######################################################################################

static function SetUpLightsaberUpgrade(out X2WeaponUpgradeTemplate Template, name UpgradeName)
{
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponLightsaber;

	Template.CanBeBuilt = false;
	Template.MaxQuantity = 1;

	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	switch (UpgradeName) {
		case 'Crystal': // 26 upgrades
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeAdeganCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeAnkarresSapphire');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeBarabOreIngot');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeBondarCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDamindCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDragiteCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeEralamCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeFirkrannCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeJenrauxCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeKaiburrCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeKashaCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeLorrdianGemstone');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeNextorCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeOpilaCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradePhondCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradePontiteCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeQixoniCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeRubatCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeRuusanCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeSapithCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeSigilCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeSolariCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeStygiumCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeUltimaPearl');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeUpariCrystal');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeVelmoriteCrystal');

			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[0], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[1], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[2], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");

			break;
		case 'Cell': // 13 upgrades
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDiatiumCell_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDiatiumCell_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDiatiumCell_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDiatiumCell_Ult');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDischargeCell_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDischargeCell_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDischargeCell_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeIonCell_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeIonCell_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeIonCell_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeJoltCell_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeJoltCell_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeJoltCell_Sup');

			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[0], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[1], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[2], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");

			break;
		case 'Emitter': // 13 upgrades
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeFocusEmitter_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeFocusEmitter_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeFocusEmitter_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDisruptEmitter_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDisruptEmitter_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDisruptEmitter_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradePhobiumEmitter_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradePhobiumEmitter_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradePhobiumEmitter_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradePhobiumEmitter_Ult');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeFencingEmitter_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeFencingEmitter_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeFencingEmitter_Sup');

			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[0], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[1], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[2], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");

			break;
		case 'Lens': // 13 upgrades
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeBeamGemLens_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeBeamGemLens_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeBeamGemLens_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeByrothsisLens_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeByrothsisLens_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeByrothsisLens_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDuelingLens_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDuelingLens_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDuelingLens_Sup');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeDuelingLens_Ult');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeVibrationLens_Bsc');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeVibrationLens_Adv');
			Template.MutuallyExclusiveUpgrades.AddItem('UpgradeVibrationLens_Sup');

			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[0], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[1], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
			Template.AddUpgradeAttachment(UpgradeName, '', "", "", class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES[2], , "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");

			break;
		default:
	}
}

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