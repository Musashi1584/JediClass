class X2Action_SyncedAnimationDeath extends X2Action_Death config (JediClass);

var config array<SyncedAnimation> SyncedAnimations;
var SyncedAnimation ActiveSyncedAnimation;
var AnimNodeSequence AttackSequence;
var name AnimationToPlay;

function Init()
{
	local int Index;

	super.Init();

	AttackSequence = XGUnit(DamageDealer).GetPawn().GetAnimTreeController().FullBodyDynamicNode.GetTerminalSequence();
	Index = default.SyncedAnimations.Find('AttackAnimSequence', AttackSequence.AnimSeqName);

	if (Index != INDEX_NONE)
	{
		ActiveSyncedAnimation = default.SyncedAnimations[Index];
		UnitPawn.bUseDesiredEndingAtomOnDeath = false;
		AnimationToPlay = default.SyncedAnimations[Index].DeathAnimSequence;
		bWaitUntilNotified = true;

		`LOG(default.class @ GetFuncName() @
			`ShowVar(AttackSequence.AnimSeqName) @ 
			`ShowVar(AttackSequence.GetTimeLeft()) @
			`ShowVar(AnimationToPlay)
		,, 'X2JediClassWOTC');
	}
}

static function bool AllowOverrideActionDeath(VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	local XComGameState_Ability AbilityState;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(XComGameStateContext_Ability(Context).InputContext.AbilityRef.ObjectID, eReturnType_Reference));
	if (AbilityState != none && AbilityState.GetMyTemplate().ActionFireClass == class'X2Action_Fire_SyncedAnimation')
	{
		return true;
	}
	return false;
}

function bool ShouldRunDeathHandler()
{
	if (AnimationToPlay != '')
	{
		return false;
	}
	return super.ShouldRunDeathHandler();
}

function bool ShouldPlayDamageContainerDeathEffect()
{
	if (AnimationToPlay != '')
	{
		return false;
	}
	return super.ShouldPlayDamageContainerDeathEffect();
}

function bool DamageContainerDeathSound()
{
	if (AnimationToPlay != '')
	{
		return false;
	}
	return super.DamageContainerDeathSound();
}

event OnAnimNotify(AnimNotify ReceiveNotify)
{
	super.OnAnimNotify(ReceiveNotify);

	if((XComAnimNotify_NotifyTarget(ReceiveNotify) != none) && (AbilityContext != none))
	{
		bWaitUntilNotified = false;
	}
}

simulated function Name ComputeAnimationToPlay()
{
	if (AnimationToPlay != '')
	{
		// Always allow new animations to play.
		UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);

		return AnimationToPlay;
	}

	return super.ComputeAnimationToPlay();
}
