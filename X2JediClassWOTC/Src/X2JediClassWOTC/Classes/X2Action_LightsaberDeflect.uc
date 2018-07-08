class X2Action_LightsaberDeflect extends X2Action_Fire;

var	public	CustomAnimParams	Params;
var public bool bResetWeaponsToDefaultSockets, bHit; //If set, ResetWeaponsToDefaultSockets will be called on the unit before the animation is played.
var protected X2UnifiedProjectile ProjectileTemplate;
var protected XComGameState_Unit TargetUnitState, InstigatorUnitState;
var private bool bShouldContinueAnim, bProjectilesFired;
var private AnimNodeSequence PlayingSequence;
var private float ActionTimer, StartOffsetTimer, ProjectileTimer, NextProjectileTime;
var private int ReflectTargetID, CurrentVolleyIndex;
var private array<AnimNotify_FireWeaponVolley> FireVolleyNotifies;
var private array<float> OutNotifyTimes;
var private AnimNotify_FireWeaponVolley DummyNotify;
var private bool bSendProjectiles;

// The X2Action that triggered this action. The only way to get its projectile is to access it after its Init(), and the only place to do that is here.
// Unfortunately, this means either turning this action into the instigating action, or storing the instigating action inside this one. What a mess.
var private X2Action_Fire InstigatingAction;

function Init()
{
	//local XComGameState_Ability AbilityState;
	local Actor TargetVisualizer;
	local Object ThisObj;

	super.Init();

	//AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	ReflectTargetID = AbilityContext.InputContext.PrimaryTarget.ObjectID;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	
	TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ReflectTargetID));
	TargetVisualizer = TargetUnitState.GetVisualizer();
	TargetUnit = XGUnit(TargetVisualizer);
	PrimaryTarget = X2VisualizerInterface(TargetVisualizer);

	InstigatorUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	ProjectileTemplate = XComWeapon(XGWeapon(XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(InstigatingAction.AbilityContext.InputContext.AbilityRef.ObjectID)).GetSourceWeapon().GetVisualizer()).m_kEntity).DefaultProjectileTemplate;

	bHit = AbilityContext.ResultContext.HitResult == eHit_Success ? true : false;
	Params.AnimName = 'HL_LightsaberReflect';

	ThisObj = self;
	`XEVENTMGR.RegisterForEvent(ThisObj, 'Visualizer_AbilityHit', OnProjectileFromActionToWaitFor, , , InstigatingAction);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'Visualizer_ProjectileHit', OnProjectileFromActionToWaitFor, , , InstigatingAction);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'X2Action_Completed', OnCompleteFromActionToWaitFor, , , InstigatingAction);
}

function SendProjectile(AnimNotify_FireWeaponVolley FireVolleyNotify)
{
	local X2UnifiedProjectile NewProjectile;
	local X2VisualizerInterface TargetVisualizer;
	local vector Source, Target;
	//local UnitValue DeflectTarget;
	//local ProjectileSpread Spread;
	//local int ProjectileIndex;
	//local float Radian;
	local vector EmptyVector;
	
	if (ReflectTargetID == 0 || ProjectileTemplate == none)
	{
		return;
	}
	
	FireVolleyNotify.bCosmeticVolley = true;

	Source = UnitPawn.Location;

	//`log("X2Action_LightsaberDeflect DeflectTarget" @ SourceUnitState.ObjectID @ ReflectTargetID,, 'X2JediClassWOTC');
	if (TargetUnit.RestoreLocation != EmptyVector)
	{
		Target = TargetUnit.RestoreLocation;
	}
	else
	{
		TargetVisualizer = X2VisualizerInterface(`XCOMHISTORY.GetVisualizer(ReflectTargetID));
		Target = TargetVisualizer.GetShootAtLocation(eHit_Success, Metadata.StateObject_NewState.GetReference());
	}
	//`log("X2Action_LightsaberDeflect Target Unit" @ TargetUnitState.GetMyTemplateName() @ ReflectTargetID @ Target,, 'X2JediClassWOTC');
	if (!bHit)
	{
		//Radian = Pi / 2;
		//Target = Source - InstigatorUnitState.GetVisualizer().Location;
		//Target = Target + VRandCone2(Target, Radian, Radian) * VSize(Target) * Rand(10);
		Target = InstigatorUnitState.GetVisualizer().Location;
		if (Rand(2) == 0)
		{
			 Target += VRand() * Rand(1000);
		}
		else
		{
			Target -= VRand() * Rand(1000);
		}

		//`log("X2Action_LightsaberDeflect Randomize Target" @ Target,, 'X2JediClassWOTC');
	}
	
	NewProjectile = class'WorldInfo'.static.GetWorldInfo().Spawn(class'X2UnifiedProjectile', , , , , ProjectileTemplate);
	NewProjectile.ConfigureNewProjectileCosmetic(FireVolleyNotify, AbilityContext, , , , Source, Target, bHit);
	NewProjectile.GotoState('Executing');

	`log("X2Action_LightsaberDeflect SendProjectile" @ ProjectileTemplate @ bHit,, 'X2JediClassWOTC');
}

function GetAttackerWeaponVolleyNotify(out array<AnimNotify_FireWeaponVolley> OutNotifies, out array<float> LocalOutNotifyTimes)
{
	local XGUnit Attacker;

	Attacker = XGUnit(`XCOMHISTORY.GetGameStateForObjectID(InstigatorUnitState.ObjectID).GetVisualizer());
	Attacker.GetPawn().GetAnimTreeController().GetFireWeaponVolleyNotifies(OutNotifies, LocalOutNotifyTimes);
}

function bool CheckInterrupted()
{
	return false;
}

function EventListenerReturn OnProjectileFromActionToWaitFor(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	if (!bSendProjectiles)
	{
		`log(default.Class @ GetFuncName() @ "sending projectiles",, 'X2JediClassWOTC');
		bSendProjectiles = true;
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn OnCompleteFromActionToWaitFor(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	`log(default.Class @ GetFuncName() @ "stopping anim",, 'X2JediClassWOTC');
	bShouldContinueAnim = false;
	return ELR_NoInterrupt;
}

function CompleteAction()
{
	local XComGameState_Ability AbilityState;
	local X2UnifiedProjectile LocalProjectileTemplate;
	local int ProjectileIndex;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(InstigatingAction.AbilityContext.InputContext.AbilityRef.ObjectID));
	
	`LOG("X2Action_LightsaberDeflect.CompleteAction",, 'X2JediClassWOTC');

	if (AbilityContext.ResultContext.EffectRedirects.Length > 0)
	{
		`LOG("X2Action_LightsaberDeflect Reseting bCanDamageNonFragile for " @ AbilityContext.InputContext.SourceObject.ObjectID,, 'X2JediClassWOTC');
		LocalProjectileTemplate = XComWeapon(XGWeapon(AbilityState.GetSourceWeapon().GetVisualizer()).m_kEntity).DefaultProjectileTemplate;

		// Reset bCanDamageNonFragile on ProjectileTemplate
		for (ProjectileIndex = 0;ProjectileIndex < LocalProjectileTemplate.ProjectileElements.Length; ProjectileIndex++)
		{
			LocalProjectileTemplate.ProjectileElements[ProjectileIndex].bTriggerPawnHitEffects = true; // Probably wrong, according to the description, but X2UnifiedProjectile uses it the same as bCanDamageNonFragile
		}
	}

	super.CompleteAction();
}

simulated state Executing
{
	simulated event Tick(float fDeltaT)
	{
		ActionTimer += fDeltaT;

		//`log(default.Class @ GetFuncName() @ "bSendProjectiles" @ bSendProjectiles,, 'X2JediClassWOTC');
		if (bSendProjectiles && !bProjectilesFired)
		{
			if (FireVolleyNotifies.Length == 0)
			{
				GetAttackerWeaponVolleyNotify(FireVolleyNotifies, OutNotifyTimes);
				`log("X2Action_LightsaberDeflect FireVolleyNotify" @ InstigatorUnitState.GetMyTemplateName() @ InstigatorUnitState @ FireVolleyNotifies.Length @ ProjectileTemplate,, 'X2JediClassWOTC');
			}
				if (FireVolleyNotifies.Length == 0)
			{	
				DummyNotify = new class'AnimNotify_FireWeaponVolley';
				DummyNotify.NumShots = 3;
				DummyNotify.ShotInterval = 0.15f;
			}

			ProjectileTimer += fDeltaT;
			if (OutNotifyTimes.Length > 0 && CurrentVolleyIndex < OutNotifyTimes.Length)
			{
				NextProjectileTime = OutNotifyTimes[CurrentVolleyIndex] - OutNotifyTimes[0] - 0.4f;
				if (ProjectileTimer >= NextProjectileTime)
				{
					`log("X2Action_LightsaberDeflect Sending Volley" @ CurrentVolleyIndex @ NextProjectileTime @ ProjectileTimer,, 'X2JediClassWOTC');
					SendProjectile(FireVolleyNotifies[CurrentVolleyIndex]);
					ProjectileTimer = 0;
					CurrentVolleyIndex++;
				}
			}
			else if (OutNotifyTimes.Length > 0 && CurrentVolleyIndex == OutNotifyTimes.Length)
			{
				`log("X2Action_LightsaberDeflect End anim",, 'X2JediClassWOTC');
				bProjectilesFired = true;
			}
			else if (DummyNotify != none)
			{
				`log("X2Action_LightsaberDeflect Send dummy projectile",, 'X2JediClassWOTC');
				SendProjectile(DummyNotify);
				bProjectilesFired = true;
			}
		}
	}
Begin:
	while(ActionTimer < StartOffsetTimer)
	{
		Sleep(0.0f);
	}

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	if (UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName))
	{
		//The current use-case for this is when a unit becomes stunned; they may get stunned by a counter-attack while they have a secondary weapon out, for example.
		if (bResetWeaponsToDefaultSockets)
			Unit.ResetWeaponsToDefaultSockets();

		if (Params.Additive)
		{
			UnitPawn.GetAnimTreeController().PlayAdditiveDynamicAnim(Params);
		}
		else
		{
			PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
			while(bShouldContinueAnim && !bProjectilesFired)
			{
				`log("X2Action_LightsaberDeflect PlayingSequence " @ bShouldContinueAnim,, 'X2JediClassWOTC');
				PlayingSequence.ReplayAnim();
				FinishAnim(PlayingSequence);
				Sleep(0.0f);
			}
			Sleep(0.0f);
			if (FireVolleyNotifies.Length > 1)
			{
				PlayingSequence.ReplayAnim();
				FinishAnim(PlayingSequence);
			}
			`log("X2Action_LightsaberDeflect FinishAnim",, 'X2JediClassWOTC');
			`LOG("*******************************************************************************************************",, 'X2JediClassWOTC');
		}
	}
	else
	{
		`log("X2Action_LightsaberDeflect Failed to play animation" @ Params.AnimName @ "on" @ UnitPawn @ "as part of" @ self,, 'X2JediClassWOTC');
	}

	//bShouldContinueAnim = false;
	//if (!bShouldContinueAnim && ActionTimer >= TimeoutSeconds)
	Sleep(0.5);
	CompleteAction();
}

event bool BlocksAbilityActivation()
{
	return true;
}

function SetInstigatingAction(X2Action_Fire _InstigatingAction)
{
	InstigatingAction = _InstigatingAction;
}

DefaultProperties
{
	NotifyTargetTimer = 4
	StartOffsetTimer = 0.7f
	TimeoutSeconds = 10.0f
	bResetWeaponsToDefaultSockets=false
	bShouldContinueAnim=true
}
