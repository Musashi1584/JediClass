class X2Item_Holocrons extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(Holocron_CV());
	Items.AddItem(Holocron_MG());
	Items.AddItem(Holocron_BM());

	Items.AddItem(CreateTemplate_Holocron_MG_Schematic());
	Items.AddItem(CreateTemplate_Holocron_BM_Schematic());

	return Items;
}

static function X2DataTemplate Holocron_CV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holocron_CV');

	Template.strImage = "img:///Holocrons.UI.HolocronCV";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'holocron';
	Template.WeaponTech = 'conventional';
	Template.iRange = 1;
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_LowerBack;
	//Template.Abilities.AddItem('Hack');
		
	Template.GameArchetype = "Holocrons.Archetypes.WP_Holocron_CV";

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.Abilities.AddItem('HolocronPool_CV');

	return Template;
}

static function X2DataTemplate Holocron_MG()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holocron_MG');

	Template.strImage = "img:///Holocrons.UI.HolocronMG";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'holocron';
	Template.WeaponTech = 'magnetic';
	Template.iRange = 1;
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_LowerBack;
	//Template.Abilities.AddItem('Hack');
		
	Template.GameArchetype = "Holocrons.Archetypes.WP_Holocron_MG";

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.Abilities.AddItem('HolocronPool_MG');

	Template.CreatorTemplateName = 'Holocron_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Holocron_CV'; // Which item this will be upgraded from

	return Template;
}

static function X2DataTemplate CreateTemplate_Holocron_MG_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Holocron_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///Holocrons.UI.HolocronMG";
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Holocron_MG';
	Template.HideIfPurchased = 'Holocron_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('Psionics');
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 70;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseSectoid';
	Artifacts.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate Holocron_BM()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holocron_BM');

	Template.strImage = "img:///Holocrons.UI.HolocronBM";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'holocron';
	Template.WeaponTech = 'beam';
	Template.iRange = 1;
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_LowerBack;
	//Template.Abilities.AddItem('Hack');
		
	Template.GameArchetype = "Holocrons.Archetypes.WP_Holocron_BM";

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.Abilities.AddItem('HolocronPool_BM');

	Template.CreatorTemplateName = 'Holocron_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Holocron_MG'; // Which item this will be upgraded from

	return Template;
}

static function X2DataTemplate CreateTemplate_Holocron_BM_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Holocron_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///Holocrons.UI.HolocronBM";
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Holocron_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyGatekeeper');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 200;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseGatekeeper';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}