class UISL_TacticalHUD_JediStats extends UIScreenListener config (JediClass);

var config array<name> LightSideAbilities;
var config array<name> DarkSideAbilities;

event OnInit(UIScreen Screen)
{
	local UITacticalHUD HUDScreen;
	local X2EventManager EventManager;
	local Object ThisObj;

	if(Screen == none)
	{
		return;
	}

	HUDScreen = UITacticalHUD(Screen);
	if(HUDScreen == none)
	{
		return;
	}

	EventManager = `XEVENTMGR;
	ThisObj = self;
	EventManager.RegisterForEvent(ThisObj, 'KillMail', OnKillMail, ELD_OnStateSubmitted);

}

function EventListenerReturn OnKillMail(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameState NewGameState;
	local XComGameState_Unit Killer, DeadUnit, NewSourceUnit;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local UnitValue DarkSidePoints;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

	DeadUnit = XComGameState_Unit(EventData);
	Killer = XComGameState_Unit(EventSource);

	//`LOG("UISL_TacticalHUD_JediStats Dead" @ DeadUnit.GetMyTemplateName(),, 'JediClass');
	//`LOG("UISL_TacticalHUD_JediStats Killer" @ Killer.GetMyTemplateName(),, 'JediClass');
	if (default.DarkSideAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE && !DeadUnit.IsEnemyUnit(Killer))
	{
		`LOG("UISL_TacticalHUD_JediStats Naughty Boy " @ Killer.GetFullName(),, 'JediClass');
		Killer.GetUnitValue('DarkSidePoints', DarkSidePoints);

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
		NewSourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(Killer.ObjectID));
		if (NewSourceUnit != none)
		{
			//  Submit a game state that saves the Force Drained value on the source unit
			NewSourceUnit = XComGameState_Unit(NewGameState.CreateStateObject(NewSourceUnit.Class, NewSourceUnit.ObjectID));
			NewSourceUnit.SetUnitFloatValue('DarkSidePoints', DarkSidePoints.fValue + 1, eCleanup_Never);
			NewGameState.AddStateObject(NewSourceUnit);
			`TACTICALRULES.SubmitGameState(NewGameState);

			`LOG("UISL_TacticalHUD_JediStats DarkSidePoints for" @ NewSourceUnit.GetFullName() @ DarkSidePoints.fValue + 1,, 'JediClass');
		}
	}

	return ELR_NoInterrupt;
}

defaultProperties
{
	ScreenClass = UITacticalHUD;
}