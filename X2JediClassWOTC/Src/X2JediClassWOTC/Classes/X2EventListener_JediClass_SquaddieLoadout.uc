class X2EventListener_JediClass_SquaddieLoadout extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListenerTemplate_OnSquaddieItemStateApplied());

	return Templates;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnSquaddieItemStateApplied()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'JediClassSquaddieItemStateApplied');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('SquaddieItemStateApplied', OnSquaddieItemStateApplied, ELD_Immediate);
	`log("Register Event SquaddieItemStateApplied",, 'X2JediClassWOTC');

	return Template;
}

static function EventListenerReturn OnSquaddieItemStateApplied(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Item ItemState;
	local X2WeaponTemplate Template;

	ItemState = XComGameState_Item(EventData);

	if (class'X2Item_Lightsaber'.default.LIGHTSABER_TEMPLATE_NAMES.Find(ItemState.GetMyTemplateName()) != INDEX_NONE)
	{
		Template = X2WeaponTemplate(ItemState.GetMyTemplate());

		Template.OnAcquiredFn(GameState, ItemState);
	}

	return ELR_NoInterrupt;
}