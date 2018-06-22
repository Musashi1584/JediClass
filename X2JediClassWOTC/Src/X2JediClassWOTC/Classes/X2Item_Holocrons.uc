class X2Item_Holocrons extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(Holocron_CV());

	return Items;
}

static function X2DataTemplate Holocron_CV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holocron_CV');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_X4";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'holocron';
	Template.WeaponTech = 'conventional';
	Template.iRange = 0;
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_LowerBack;
	//Template.Abilities.AddItem('Hack');
		
	Template.GameArchetype = "Holocrons.Archetypes.WP_Holocron_CV";

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	return Template;
}