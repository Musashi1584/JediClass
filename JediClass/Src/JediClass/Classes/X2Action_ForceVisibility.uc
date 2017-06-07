//---------------------------------------------------------------------------------------
//  FILE:    Based on XMBAction_ForceVisibility.uc
//  AUTHOR:  xylthixlm
//  None.
//---------------------------------------------------------------------------------------
class X2Action_ForceVisibility extends X2Action;

var bool bEnableOutline;

simulated state Executing
{
Begin:
	Unit.SetForceVisibility(bEnableOutline ? eForceVisible : eForceNone);
	UnitPawn.UpdatePawnVisibility();

	CompleteAction();
}