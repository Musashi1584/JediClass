class JediClassHelper extends Object config (JediClass);

var localized string ForceAlignmentModifier;
var localized string DarkSidePoints;
var localized string LightSidePoints;
var localized string m_strCategoryRestricted;

var config array<name> LightSideAbilities;
var config array<name> DarkSideAbilities;

static function string GetForceAlignmentModifierString()
{
	return default.ForceAlignmentModifier;
}

static function AddDarkSidePointToGameState(XComGameState_Unit Unit, out XComGameState NewGameState, int DarkSidePointsToAdd = 1)
{
	local XComGameState_Unit NewSourceUnit;
	local UnitValue DarkSidePoints;

	if (Unit.GetSoldierClassTemplateName() != 'Jedi')
		return;

	Unit.GetUnitValue('DarkSidePoints', DarkSidePoints);
	NewSourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Unit.ObjectID));
	if (NewSourceUnit != none)
	{
		NewSourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(NewSourceUnit.Class, NewSourceUnit.ObjectID));
		NewSourceUnit.SetUnitFloatValue('DarkSidePoints', DarkSidePoints.fValue + DarkSidePointsToAdd, eCleanup_Never);
		`LOG("JediClassHelper AddDarkSidePointToGameState for" @ NewSourceUnit.GetFullName() @ DarkSidePointsToAdd @ "(" @ DarkSidePoints.fValue + DarkSidePointsToAdd @ ")",, 'X2JediClassWOTC');
	}
}

static function AddDarkSidePoint(XComGameState_Unit Unit, int DarkSidePointsToAdd = 1)
{
	local XComGameState_Unit NewSourceUnit;
	local XComGameState NewGameState;
	local UnitValue DarkSidePoints;

	if (Unit.GetSoldierClassTemplateName() != 'Jedi')
		return;

	Unit.GetUnitValue('DarkSidePoints', DarkSidePoints);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	NewSourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Unit.ObjectID));
	if (NewSourceUnit != none)
	{
		NewSourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(NewSourceUnit.Class, NewSourceUnit.ObjectID));
		NewSourceUnit.SetUnitFloatValue('DarkSidePoints', DarkSidePoints.fValue + DarkSidePointsToAdd, eCleanup_Never);
		`TACTICALRULES.SubmitGameState(NewGameState);
		`LOG("JediClassHelper AddDarkSidePoints for" @ NewSourceUnit.GetFullName() @ DarkSidePointsToAdd @ "(" @ DarkSidePoints.fValue + DarkSidePointsToAdd @ ")",, 'X2JediClassWOTC');
	}
}

static function AddLightSidePointToGameState(XComGameState_Unit Unit, out XComGameState NewGameState, int LightSidePointsToAdd = 1)
{
	local XComGameState_Unit NewSourceUnit;
	local UnitValue LightSidePoints;

	if (Unit.GetSoldierClassTemplateName() != 'Jedi')
		return;

	Unit.GetUnitValue('LightSidePoints', LightSidePoints);
	NewSourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Unit.ObjectID));
	if (NewSourceUnit != none)
	{
		NewSourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(NewSourceUnit.Class, NewSourceUnit.ObjectID));
		NewSourceUnit.SetUnitFloatValue('LightSidePoints', LightSidePoints.fValue + LightSidePointsToAdd, eCleanup_Never);
		`LOG("JediClassHelper AddLightSidePointToGameState for" @ NewSourceUnit.GetFullName() @ LightSidePointsToAdd @ "(" @ LightSidePoints.fValue + LightSidePointsToAdd @ ")",, 'X2JediClassWOTC');
	}
}

static function AddLightSidePoint(XComGameState_Unit Unit, int LightSidePointsToAdd = 1)
{
	local XComGameState_Unit NewSourceUnit;
	local XComGameState NewGameState;
	local UnitValue LightSidePoints;

	if (Unit.GetSoldierClassTemplateName() != 'Jedi')
		return;

	Unit.GetUnitValue('LightSidePoints', LightSidePoints);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	NewSourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Unit.ObjectID));
	if (NewSourceUnit != none)
	{
		NewSourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(NewSourceUnit.Class, NewSourceUnit.ObjectID));
		NewSourceUnit.SetUnitFloatValue('LightSidePoints', LightSidePoints.fValue + LightSidePointsToAdd, eCleanup_Never);
		`TACTICALRULES.SubmitGameState(NewGameState);
		`LOG("JediClassHelper AddLightSidePoints for" @ NewSourceUnit.GetFullName() @ LightSidePointsToAdd @ "(" @ LightSidePoints.fValue + LightSidePointsToAdd @ ")",, 'X2JediClassWOTC');
	}
}

static function int GetDarkSideModifier(XComGameState_Unit Unit)
{
	local UnitValue LightSidePoints, DarkSidePoints;

	Unit.GetUnitValue('LightSidePoints', LightSidePoints);
	Unit.GetUnitValue('DarkSidePoints', DarkSidePoints);

	return int(DarkSidePoints.fValue - LightSidePoints.fValue);
}

static function int GetLightSideModifier(XComGameState_Unit Unit)
{
	local UnitValue LightSidePoints, DarkSidePoints;
	local int NetPoints;

	Unit.GetUnitValue('LightSidePoints', LightSidePoints);
	Unit.GetUnitValue('DarkSidePoints', DarkSidePoints);

	NetPoints = int(LightSidePoints.fValue - DarkSidePoints.fValue);

	NetPoints = NetPoints < 0 ? 0 : NetPoints;

	return NetPoints;
}

static function int GetSuccessModifier(XComGameState_Unit Unit, name Ability)
{
	if (default.LightSideAbilities.Find(Ability) != INDEX_NONE)
	{
		return GetLightSideModifier(Unit);
	}

	if (default.DarkSideAbilities.Find(Ability) != INDEX_NONE)
	{
		return GetDarkSideModifier(Unit);
	}

	return 0;
}