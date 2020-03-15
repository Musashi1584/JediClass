class X2Effect_ForceMeditate extends X2Effect_Persistent;

var float RegenAmount;
var name EventToTriggerOnRegen;

var localized string RegenMessage;

function ForceRegenAdded(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit OldTargetState, NewTargetState;
	local UnitValue CurrentForce, MaxForce;
	local int AmountToRegen;
	
	OldTargetState = XComGameState_Unit(kNewTargetState);
	OldTargetState.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, CurrentForce);
	OldTargetState.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.MaxForceName, MaxForce);

	AmountToRegen = MaxForce.fValue - CurrentForce.fValue;

	if (AmountToRegen > Round(RegenAmount * MaxForce.fValue))
		AmountToRegen = Round(RegenAmount * MaxForce.fValue);

	NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
	NewTargetState.SetUnitFloatValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, CurrentForce.fValue + AmountToRegen, eCleanup_BeginTactical);
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local UnitValue OldForce, NewForce;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Regen;
	local string Msg;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	OldUnit.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, OldForce);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	NewUnit.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, NewForce);

	Regen = NewForce.fValue - OldForce.fValue;
	
	if( Regen > 0 )
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		Msg = Repl(default.RegenMessage, "<Regen/>", Regen);
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	`LOG(default.class @ GetFuncName(),, 'JediClassWOTC');
	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);
	class'X2Action_ForceMeditateEnd'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{

}

defaultproperties
{
	EffectName="ForceMeditation"
	EffectAddedFn=ForceRegenAdded
}