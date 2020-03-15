class X2Item_LightSaber extends X2Item config (JediClass) dependson(JediClassDataStructure);

var config WeaponDamageValue LIGHTSABER_CONVENTIONAL_BASEDAMAGE;
var config int  LIGHTSABER_CONVENTIONAL_AIM;
var config int  LIGHTSABER_CONVENTIONAL_CRITCHANCE;
var config int  LIGHTSABER_CONVENTIONAL_ICLIPSIZE;
var config int  LIGHTSABER_CONVENTIONAL_ISOUNDRANGE;
var config int  LIGHTSABER_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config array<name> LIGHTSABER_CONVENTIONAL_ABILITIES;

var config WeaponDamageValue LIGHTSABER_MAGNETIC_BASEDAMAGE;
var config int  LIGHTSABER_MAGNETIC_AIM;
var config int  LIGHTSABER_MAGNETIC_CRITCHANCE;
var config int  LIGHTSABER_MAGNETIC_ICLIPSIZE;
var config int  LIGHTSABER_MAGNETIC_ISOUNDRANGE;
var config int  LIGHTSABER_MAGNETIC_IENVIRONMENTDAMAGE;
var config array<name> LIGHTSABER_MAGNETIC_ABILITIES;

var config WeaponDamageValue LIGHTSABER_BEAM_BASEDAMAGE;
var config int  LIGHTSABER_BEAM_AIM;
var config int  LIGHTSABER_BEAM_CRITCHANCE;
var config int  LIGHTSABER_BEAM_ICLIPSIZE;
var config int  LIGHTSABER_BEAM_ISOUNDRANGE;
var config int  LIGHTSABER_BEAM_IENVIRONMENTDAMAGE;
var config array<name> LIGHTSABER_BEAM_ABILITIES;

var config name LIGHTSABER_DEFAULT_CRYSTAL;
var config name LIGHTSABER_DEFAULT_CELL;
var config name LIGHTSABER_DEFAULT_EMITTER;
var config name LIGHTSABER_DEFAULT_LENS;

var config array<name> LIGHTSABER_VALID_CRYSTALS;
var config array<name> LIGHTSABER_VALID_CELLS;
var config array<name> LIGHTSABER_VALID_EMITTERS;
var config array<name> LIGHTSABER_VALID_LENSES;

var config array<name> LIGHTSABER_TEMPLATE_NAMES;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	// Lightsabers
	Weapons.AddItem(CreateTemplate_LightSaber_Conventional());
	Weapons.AddItem(CreateTemplate_LightSaber_Magnetic());
	Weapons.AddItem(CreateTemplate_LightSaber_Beam());
	
	return Weapons;
}

static function X2DataTemplate CreateTemplate_LightSaber_Conventional()
{
	local X2WeaponTemplate Template;
	local AltGameArchetypeUse DualWieldArchetype;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, default.LIGHTSABER_TEMPLATE_NAMES[0]);
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lightsaber';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LightSaber_CV.Archetypes.WP_LightSaber_CV";

	DualWieldArchetype.ArchetypeString = "LightSaber_CV.Archetypes.WP_LightSaber_CV_Dual";
	DualWieldArchetype.UseGameArchetypeFn = ShouldUseDualWieldArchetype;
	Template.AltGameArchetypeArray.AddItem(DualWieldArchetype);

	//Template.AddDefaultAttachment('Sheath', "ConvSword.Meshes.SM_ConvSword_Sheath", true);
	Template.Tier = 0;
	Template.OnAcquiredFn = OnLightsaberAcquired;
	Template.OnEquippedFn = DeleteMatchingWeaponFromOtherSlot;
	Template.OnUnequippedFn = ReplaceMatchingWeaponFromOtherSlot;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 4;
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

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	Template.bAlwaysUnique = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_LightSaber_Magnetic()
{
	local X2WeaponTemplate Template;
	local AltGameArchetypeUse DualWieldArchetype;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, default.LIGHTSABER_TEMPLATE_NAMES[1]);
	//Template.GameplayInstanceClass = class'XGLightSaber';
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lightsaber';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LightSaber_CV.Archetypes.WP_LightSaber_CV";

	DualWieldArchetype.ArchetypeString = "LightSaber_CV.Archetypes.WP_LightSaber_CV_Dual";
	DualWieldArchetype.UseGameArchetypeFn = ShouldUseDualWieldArchetype;
	Template.AltGameArchetypeArray.AddItem(DualWieldArchetype);

	Template.Tier = 1;
	Template.OnAcquiredFn = OnLightsaberAcquired;
	Template.OnEquippedFn = DeleteMatchingWeaponFromOtherSlot;
	Template.OnUnequippedFn = ReplaceMatchingWeaponFromOtherSlot;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 4;
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

	Template.BaseItem = 'Lightsaber_CV'; // Which item this will be upgraded from
	
	Template.DamageTypeTemplateName = 'Melee';
	Template.BaseDamage.DamageType = 'Melee';
	
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	Template.bAlwaysUnique = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_LightSaber_Beam()
{
	local X2WeaponTemplate Template;
	local AltGameArchetypeUse DualWieldArchetype;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, default.LIGHTSABER_TEMPLATE_NAMES[2]);
	//Template.GameplayInstanceClass = class'XGLightSaber';
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lightsaber';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LightSaber_CV.Archetypes.WP_LightSaber_CV";
	
	DualWieldArchetype.ArchetypeString = "LightSaber_CV.Archetypes.WP_LightSaber_CV_Dual";
	DualWieldArchetype.UseGameArchetypeFn = ShouldUseDualWieldArchetype;
	Template.AltGameArchetypeArray.AddItem(DualWieldArchetype);

	Template.Tier = 2;
	Template.OnAcquiredFn = OnLightsaberAcquired;
	Template.OnEquippedFn = DeleteMatchingWeaponFromOtherSlot;
	Template.OnUnequippedFn = ReplaceMatchingWeaponFromOtherSlot;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 4;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 0;

	Template.iRange = 0;
	Template.BaseDamage = default.LIGHTSABER_BEAM_BASEDAMAGE;
	
	Template.Aim = default.LIGHTSABER_BEAM_AIM;
	Template.CritChance = default.LIGHTSABER_BEAM_CRITCHANCE;
	Template.iSoundRange = default.LIGHTSABER_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LIGHTSABER_BEAM_IENVIRONMENTDAMAGE;
	
	AddConfigAbilities(Template, default.LIGHTSABER_BEAM_ABILITIES);

	Template.BaseItem = 'Lightsaber_MG'; // Which item this will be upgraded from
	
	Template.BaseDamage.DamageType='Melee';
	Template.DamageTypeTemplateName = 'Melee';
	
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	Template.bAlwaysUnique = true;
	
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

static function bool OnLightsaberAcquired(XComGameState NewGameState, XComGameState_Item ItemState)
{
	local X2ItemTemplateManager ItemTemplateMgr;
	local array<name> WeaponUpgradeNames;
	local X2WeaponUpgradeTemplate CrystalUpgrade, EmitterUpgrade, LensUpgrade, CellUpgrade;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	WeaponUpgradeNames = ItemState.GetMyWeaponUpgradeTemplateNames();

	CrystalUpgrade = X2WeaponUpgradeTemplate(ItemTemplateMgr.FindItemTemplate(
		GetRandomUpgrade(X2WeaponTemplate(
			ItemState.GetMyTemplate()).WeaponTech,
			class'X2Item_WeaponUpgrade_Lightsaber'.default.CRYSTAL_SETUPS
		)
	));

	EmitterUpgrade = X2WeaponUpgradeTemplate(ItemTemplateMgr.FindItemTemplate(
		GetRandomUpgrade(X2WeaponTemplate(
			ItemState.GetMyTemplate()).WeaponTech,
			class'X2Item_WeaponUpgrade_Lightsaber'.default.EMITTER_SETUPS
		)
	));

	LensUpgrade = X2WeaponUpgradeTemplate(ItemTemplateMgr.FindItemTemplate(
		GetRandomUpgrade(X2WeaponTemplate(
			ItemState.GetMyTemplate()).WeaponTech,
			class'X2Item_WeaponUpgrade_Lightsaber'.default.LENS_SETUPS
		)
	));

	CellUpgrade = X2WeaponUpgradeTemplate(ItemTemplateMgr.FindItemTemplate(
		GetRandomUpgrade(X2WeaponTemplate(
			ItemState.GetMyTemplate()).WeaponTech,
			class'X2Item_WeaponUpgrade_Lightsaber'.default.CELL_SETUPS
		)
	));

	if (WeaponUpgradeNames.Length != 4)
	{
		ItemState.WipeUpgradeTemplates();
		ItemState.ApplyWeaponUpgradeTemplate(CrystalUpgrade, 0);
		ItemState.ApplyWeaponUpgradeTemplate(EmitterUpgrade, 1);
		ItemState.ApplyWeaponUpgradeTemplate(LensUpgrade, 2);
		ItemState.ApplyWeaponUpgradeTemplate(CellUpgrade, 3);
		return true;
	}
	if (class'X2Item_WeaponUpgrade_Lightsaber'.default.CRYSTAL_SETUPS.Find('UpgradeName', WeaponUpgradeNames[0]) == INDEX_NONE)
	{
		ItemState.ApplyWeaponUpgradeTemplate(CrystalUpgrade, 0);
	}
	if (class'X2Item_WeaponUpgrade_Lightsaber'.default.EMITTER_SETUPS.Find('UpgradeName', WeaponUpgradeNames[1]) == INDEX_NONE)
	{
		ItemState.ApplyWeaponUpgradeTemplate(EmitterUpgrade, 1);
	}
	if (class'X2Item_WeaponUpgrade_Lightsaber'.default.LENS_SETUPS.Find('UpgradeName', WeaponUpgradeNames[2]) == INDEX_NONE)
	{
		ItemState.ApplyWeaponUpgradeTemplate(LensUpgrade, 2);
	}
	if (class'X2Item_WeaponUpgrade_Lightsaber'.default.CELL_SETUPS.Find('UpgradeName', WeaponUpgradeNames[3]) == INDEX_NONE)
	{
		ItemState.ApplyWeaponUpgradeTemplate(CellUpgrade, 3);
	}

	return true;
}

static function name GetRandomUpgrade(name WeaponTech, array<UpgradeSetup> WeaponUpgrades)
{
	local array<int> AvailableTiers;
	local UpgradeSetup Upgrade;

	switch (WeaponTech)
	{
		case 'conventional':
			AvailableTiers.AddItem(0);
			break;
		case 'magnetic':
			AvailableTiers.AddItem(0);
			AvailableTiers.AddItem(1);
			break;
		case 'beam':
			AvailableTiers.AddItem(1);
			AvailableTiers.AddItem(2);
			break;
	}

	Upgrade = WeaponUpgrades[`SYNC_RAND_STATIC(WeaponUpgrades.Length - 1)];

	while (AvailableTiers.Find(Upgrade.Tier) == INDEX_NONE)
	{
		Upgrade = WeaponUpgrades[`SYNC_RAND_STATIC(WeaponUpgrades.Length - 1)];
	}

	`LOG(GetFuncName() @ WeaponTech @ Upgrade.UpgradeName,, 'X2JediClassWOTC');

	return Upgrade.UpgradeName;
}

function bool ShouldUseDualWieldArchetype(XComGameState_Item ItemState, XComGameState_Unit UnitState, string ConsiderArchetype)
{
	return (class'X2DownloadableContentInfo_JediClass'.static.HasDualLightsaberEquipped(UnitState) &&
		ConsiderArchetype == "LightSaber_CV.Archetypes.WP_LightSaber_CV_Dual");
}

function DeleteMatchingWeaponFromOtherSlot(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<StateObjectReference> InventoryItemRefs;
	local array<name> ItemUpgradeNames, InventoryItemUpgradeNames;
	local StateObjectReference MatchingItemRef;
	local XComGameState_Item InventoryItemState;
	local int idx, jdx;

	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	}

	InventoryItemRefs = XComHQ.Inventory;
	for (idx = 0; idx < InventoryItemRefs.Length; idx++)
	{
		InventoryItemState = XComGameState_Item(History.GetGameStateForObjectID(InventoryItemRefs[idx].ObjectID));

		if (InventoryItemState.WeaponAppearance.iWeaponTint == ItemState.WeaponAppearance.iWeaponTint &&
			InventoryItemState.WeaponAppearance.iWeaponDeco == ItemState.WeaponAppearance.iWeaponDeco &&
			InventoryItemState.WeaponAppearance.nmWeaponPattern == ItemState.WeaponAppearance.nmWeaponPattern &&
			InventoryItemState.Nickname == ItemState.Nickname)
		{
			ItemUpgradeNames = ItemState.GetMyWeaponUpgradeTemplateNames();
			InventoryItemUpgradeNames = InventoryItemState.GetMyWeaponUpgradeTemplateNames();

			if (ItemUpgradeNames.Length == InventoryItemUpgradeNames.Length)
			{
				for (jdx = 0; jdx < ItemUpgradeNames.Length; jdx++)
				{
					if (ItemUpgradeNames[jdx] != InventoryItemUpgradeNames[jdx])
					{
						break;
					}
				}

				if (jdx == ItemUpgradeNames.Length)
				{
					if (ItemState.GetMyTemplateName() != InventoryItemState.GetMyTemplateName())
					{
						MatchingItemRef = InventoryItemRefs[idx];
					}
				}
			}
		}
	}

	if (MatchingItemRef.ObjectID > 0)
	{
		NewGameState.RemoveStateObject(MatchingItemRef.ObjectID);
		XComHQ.Inventory.RemoveItem(MatchingItemRef);
	}
	else
	{
		`Redscreen(ItemState.ObjectID @ "has no matching ItemState to remove!");
	}
}

function ReplaceMatchingWeaponFromOtherSlot(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local name TemplateName;
	local int PrimaryIndex;
	local X2ItemTemplateManager ItemMgr;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item NewItemState;
	local array<X2WeaponUpgradeTemplate> OldStateUpgrades;
	local X2WeaponUpgradeTemplate UpgradeTemplate;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	TemplateName = ItemState.GetMyTemplateName();
	PrimaryIndex = InStr(TemplateName, "_Primary");

	if (PrimaryIndex == INDEX_NONE)
	{
		TemplateName = name(string(TemplateName) $ "_Primary");
	}
	else
	{
		TemplateName = name(Left(TemplateName, PrimaryIndex));
	}

	ItemTemplate = ItemMgr.FindItemTemplate(TemplateName);

	if (ItemTemplate == none)
	{
		`Redscreen(TemplateName @ "does not exist! Cannot add saber mirror to other slot!");
		return;
	}

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	}

	NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	NewItemState.WipeUpgradeTemplates();
	OldStateUpgrades = ItemState.GetMyWeaponUpgradeTemplates();
	foreach OldStateUpgrades(UpgradeTemplate)
	{
		NewItemState.ApplyWeaponUpgradeTemplate(UpgradeTemplate);
	}
	NewItemState.WeaponAppearance.iWeaponTint = ItemState.WeaponAppearance.iWeaponTint;
	NewItemState.WeaponAppearance.iWeaponDeco = ItemState.WeaponAppearance.iWeaponDeco;
	NewItemState.WeaponAppearance.nmWeaponPattern = ItemState.WeaponAppearance.nmWeaponPattern;
	NewItemState.Nickname = ItemState.Nickname;

	XComHQ.AddItemToHQInventory(NewItemState);
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
