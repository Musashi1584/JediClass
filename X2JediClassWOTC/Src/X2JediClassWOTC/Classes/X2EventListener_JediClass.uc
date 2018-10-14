class X2EventListener_JediClass extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListenerTemplate_OnSquaddieItemStateApplied());
	Templates.AddItem(CreateListenerTemplate_OnOverrideUnitFocusUI());
	Templates.AddItem(CreateListenerTemplate_OnSoldierInfo());

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

static function CHEventListenerTemplate CreateListenerTemplate_OnOverrideUnitFocusUI()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'JediClassOverrideUnitFocusUI');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = false;

	Template.AddCHEvent('OverrideUnitFocusUI', OnOverrideUnitFocusUI, ELD_Immediate);
	`log("Register Event OverrideUnitFocusUI",, 'X2JediClassWOTC');

	return Template;
}

static function EventListenerReturn OnOverrideUnitFocusUI(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Unit UnitState;
	local UnitValue CurrentForce, MaxForce;
	local int Alignment, ColorInt;
	local string BarColor;

	Tuple = XComLWTuple(EventData);
	UnitState = XComGameState_Unit(EventSource);

	if (UnitState == none)
	{
		Tuple.Data[0].b = false; // if no unit state, don't display Jedi Force Pool
		return ELR_NoInterrupt;
	}

	if (!UnitState.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.MaxForceName, MaxForce)) // GetUnitValue returns false if the unit did not already have the value
	{
		Tuple.Data[0].b = false; // if unit state doesn't have a MaxForce amount, don't display Jedi Force Pool
		return ELR_NoInterrupt;
	}
	
	UnitState.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, CurrentForce);

	// GetLightSideModifier returns max(LightSidePoints, 0) so I can't use one number to set both colors
	// GetDarkSideModifier returns dark side as a positive number, so make sure to abs(Alignment) before multiplying for blue
	// 0x000000 is black, so we need to start with 0xFFFFFF and then subtract from the colors we don't want
	// Start at full white and reduce by an amount equal to Alignment * 10
	Alignment = class'JediClassHelper'.static.GetDarkSideModifier(UnitState);
	ColorInt = Min(int(Abs(float(Alignment)) * 10), 255);
	BarColor = Right(ToHex(255 - ColorInt), 2);

	if (Alignment > 0)
		BarColor = "0xFF" $ BarColor $ BarColor; // if Alignment is positive, it's dark side points, so reduce non-red colors
	else
		BarColor = "0x" $ BarColor $ "FFFF"; // if Alignment is negative, it's light side points, so reduce red

	Tuple.Data[0].b = true; // bVisible
	Tuple.Data[1].i = int(CurrentForce.fValue); // currentFocus
	Tuple.Data[2].i = int(MaxForce.fValue); // maxFocus
	Tuple.Data[3].s = BarColor; // color
	Tuple.Data[4].s = "img:///JediClassUI.UIJediClass"; // iconPath
	Tuple.Data[5].s = class'X2Effect_JediForcePool_ByRank'.default.ForceDescription; // tooltipText
	Tuple.Data[6].s = class'X2Effect_JediForcePool_ByRank'.default.ForceLabel; // focusLabel

	return ELR_NoInterrupt;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnSoldierInfo()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'JediClassSoldierInfo');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('SoldierClassIcon', OnSoldierInfo, ELD_Immediate);
	`LOG("Register Event SoldierClassIcon",, 'X2JediClassWOTC');

	Template.AddCHEvent('SoldierClassDisplayName', OnSoldierInfo, ELD_Immediate);
	`LOG("Register Event SoldierClassDisplayName",, 'X2JediClassWOTC');

	Template.AddCHEvent('SoldierClassSummary', OnSoldierInfo, ELD_Immediate);
	`LOG("Register Event SoldierClassSummary",, 'X2JediClassWOTC');

	return Template;
}

static function EventListenerReturn OnSoldierInfo(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Unit UnitState;
	local string Info;

	Tuple = XComLWTuple(EventData);
	UnitState = XComGameState_Unit(EventSource);

	//`LOG(GetFuncName() @ XComGameState_Unit(EventSource).GetFullName(),, 'X2JediClassWOTC');

	if (UnitState.GetSoldierClassTemplate().DataName != 'UniversalSoldier')
	{
		//`LOG(GetFuncName() @ "bailing" @ UnitState.GetSoldierClassTemplate().DisplayName @ UnitState.GetSoldierClassTemplate().DataName,, 'X2JediClassWOTC');
		return ELR_NoInterrupt;
	}

	switch (Event)
	{
		case 'SoldierClassIcon':
			Info = UnitState.GetSoldierClassTemplate().IconImage;
			break;
		case 'SoldierClassDisplayName':
			`LOG(GetFuncName() @ Event @ class'JediClassHelper'.static.GetDarkSideModifier(UnitState),, 'X2JediClassWOTC');
			if (class'JediClassHelper'.static.GetDarkSideModifier(UnitState) > 0)
			{
				Info = "Sith";
			}
			else
			{
				Info = "Jedi";
			}
			break;
		case 'SoldierClassSummary':
			Info = UnitState.GetSoldierClassTemplate().ClassSummary;
			break;
	}

	//`LOG(GetFuncName() @ Event @ Info,, 'X2JediClassWOTC');

	Tuple.Data[0].s = Info;
	EventData = Tuple;

	return ELR_NoInterrupt;
}
