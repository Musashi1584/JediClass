//---------------------------------------------------------------------------------------
//  FILE:    Based on XMBEffect_RevealUnit.uc
//  AUTHOR:  xylthixlm
//---------------------------------------------------------------------------------------
class X2Effect_RevealUnit extends X2Effect_Persistent;


///////////////////////
// Effect properties //
///////////////////////

var float LookAtDuration;					// The duration the camera will look at the flyover.
var bool bRevealConcealed;					// If true, reveal hidden Faceless and burrowed Chryssalids.


////////////////////
// Implementation //
////////////////////

function EffectAddedCallback(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local X2EventManager EventMan;
	local XComGameState_Unit UnitState;

	if (!bRevealConcealed)
		return;

	EventMan = `XEVENTMGR;
	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		if (UnitState.AffectedByEffectNames.Find(class'X2AbilityTemplateManager'.default.BurrowedName) != INDEX_NONE)
		{
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.UnburrowActionPoint);
		}
		EventMan.TriggerEvent(class'X2Ability_Chryssalid'.default.UnburrowTriggerEventName, kNewTargetState, kNewTargetState, NewGameState);
		EventMan.TriggerEvent(class'X2Ability_Faceless'.default.ChangeFormTriggerEventName, kNewTargetState, kNewTargetState, NewGameState);
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_ForceVisibility OutlineAction;
	local X2Action_PlaySoundAndFlyOver FlyOver;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (EffectApplyResult == 'AA_Success' && UnitState != none)
	{
		OutlineAction = X2Action_ForceVisibility(class'X2Action_ForceVisibility'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		OutlineAction.bEnableOutline = true;

		if (UnitState.GetTeam() == eTeam_Alien && !class'X2TacticalVisibilityHelpers'.static.CanSquadSeeTarget(`TACTICALRULES.GetLocalClientPlayerObjectID(), UnitState.ObjectID))
		{
			AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(XComGameStateContext_Ability(VisualizeGameState.GetContext()).InputContext.AbilityTemplateName);
			FlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			FlyOver.SetSoundAndFlyOverParameters(none, AbilityTemplate.LocFlyOverText, '', eColor_Bad, AbilityTemplate.IconImage, default.LookAtDuration, true);
		}
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		class'X2Action_ForceVisibility'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
	}
}

simulated function AddX2ActionsForVisualization_Sync( XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local X2Action_ForceVisibility OutlineAction;

	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		OutlineAction = X2Action_ForceVisibility( class'X2Action_ForceVisibility'.static.AddToVisualizationTree( ActionMetadata, VisualizeGameState.GetContext( ), false, ActionMetadata.LastActionAdded ) );
		OutlineAction.bEnableOutline = true;
	}
}

DefaultProperties
{
	EffectName="Tracking"
	DuplicateResponse=eDupe_Ignore
	EffectAddedFn=EffectAddedCallback
	LookAtDuration=1.0f
	bRevealConcealed=false
}