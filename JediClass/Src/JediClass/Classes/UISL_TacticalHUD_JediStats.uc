class UISL_TacticalHUD_JediStats extends UIScreenListener;


event OnInit(UIScreen Screen)
{
	local UITacticalHUD HUDScreen;
	local X2EventManager EventManager;
	local Object ThisObj;
	local XComPlayerController PC;

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
	EventManager.RegisterForEvent(ThisObj, 'UnitEvacuated', OnUnitEvacuated, ELD_OnStateSubmitted);
	//EventManager.RegisterForEvent(ThisObj, 'AbilityActivated', OnAbilityActivated, ELD_Immediate);

	PC = Screen.PC;
	//class'WorldInfo'.static.GetWorldInfo().MyWatchVariableMgr.RegisterWatchVariable(XComTacticalController(PC), 'ControllingUnitVisualizer', self, class'UISL_TacticalHUD_JediStats'.static.OnActiveUnitChanged);
}

//static function OnActiveUnitChanged()
//{
//	local UITacticalHUD Screen;
//	local XGUnit ActiveUnit;
//	local XComGameState_Unit UnitState;
//
//	Screen = `PRES.GetTacticalHUD();
//
//	ActiveUnit = XComTacticalController(Screen.PC).GetActiveUnit();
//	UnitState = ActiveUnit.GetVisualizedGameState();
//
//	UpdateGameSpeed(UnitState);
//}

//function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
//{
//	local XComGameStateContext_Ability AbilityContext;
//	local XComGameState_Unit UnitState;
//
//	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
//	UnitState = XComGameState_Unit(AbilityContext.AssociatedState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
//
//	UpdateGameSpeed(UnitState);
//
//	return ELR_NoInterrupt;
//}
//
//static function UpdateGameSpeed(XComGameState_Unit UnitState)
//{
//	if (UnitState.IsUnitAffectedByEffectName('ForceSpeed'))
//	{
//		if (class'WorldInfo'.static.GetWorldInfo().Game.GameSpeed != class'X2Effect_ForceSpeed'.default.ForceSpeedGameSpeedMutliplier)
//		{
//			class'WorldInfo'.static.GetWorldInfo().Game.SetGameSpeed(class'X2Effect_ForceSpeed'.default.ForceSpeedGameSpeedMutliplier);
//			`LOG("UISL_TacticalHUD_JediStats UpdateGameSpeed" @ class'X2Effect_ForceSpeed'.default.ForceSpeedGameSpeedMutliplier @ "active ForceSpeed on" @ UnitState.GetFullName(),, 'JediClass');
//		}
//	}
//	else
//	{
//		if (class'WorldInfo'.static.GetWorldInfo().Game.GameSpeed != 1.0f)
//		{
//			class'WorldInfo'.static.GetWorldInfo().Game.SetGameSpeed(1.0f);
//			`LOG("UISL_TacticalHUD_JediStats UpdateGameSpeed 1" @ UnitState.GetFullName(),, 'JediClass');
//		}
//	}
//}

function EventListenerReturn OnKillMail(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	
	local XComGameState_Unit Killer, DeadUnit;
	local XComGameStateContext_Ability AbilityContext;
	local X2AbilityTemplate AbilityTemplate;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

	DeadUnit = XComGameState_Unit(EventData);
	Killer = XComGameState_Unit(EventSource);

	if (class'JediClassHelper'.default.DarkSideAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE && !DeadUnit.IsEnemyUnit(Killer))
	{
		`LOG("UISL_TacticalHUD_JediStats Innocent Killer" @ Killer.GetFullName(),, 'JediClass');
		class'JediClassHelper'.static.AddDarkSidePoint(Killer);
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OnUnitEvacuated(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameState_Unit UnitState, CarriedUnitState;
	local XComGameState_Effect CarryEffect;
	local XComGameStateHistory History;
	local bool bFoundCarry;

	UnitState = XComGameState_Unit(EventData);

	if (UnitState.GetSoldierClassTemplateName() != 'Jedi')
		return ELR_NoInterrupt;

	CarryEffect = UnitState.GetUnitAffectedByEffectState(class'X2Ability_CarryUnit'.default.CarryUnitEffectName);
	if (CarryEffect != none)
	{
		History = `XCOMHISTORY;
		foreach History.IterateByClassType(class'XComGameState_Unit', CarriedUnitState)
		{
			CarryEffect = CarriedUnitState.GetUnitAffectedByEffectState(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName);
			if (CarryEffect != none && CarryEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID == UnitState.ObjectID)
			{
				bFoundCarry = true;
				break;
			}
		}
		if (bFoundCarry)
		{
			`LOG("UISL_TacticalHUD_JediStats Savior" @ UnitState.GetFullName(),, 'JediClass');
			class'JediClassHelper'.static.AddLightSidePoint(UnitState);
		}
	}

	if (UnitState.GetNumKills() == 0)
	{
		`LOG("UISL_TacticalHUD_JediStats Pacifist" @ UnitState.GetFullName(),, 'JediClass');
		class'JediClassHelper'.static.AddLightSidePoint(UnitState);
	}

	return ELR_NoInterrupt;
}

defaultProperties
{
	ScreenClass = UITacticalHUD;
}