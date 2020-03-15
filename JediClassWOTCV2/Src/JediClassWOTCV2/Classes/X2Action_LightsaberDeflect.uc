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
	local XComGameState_Ability InstigatorAbilityState;
	local XGWeapon Weapon;
	local XComWeapon XComWeapon;

	super.Init();

	//AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	ReflectTargetID = AbilityContext.InputContext.PrimaryTarget.ObjectID;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	
	TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ReflectTargetID));
	TargetVisualizer = TargetUnitState.GetVisualizer();
	TargetUnit = XGUnit(TargetVisualizer);
	PrimaryTarget = X2VisualizerInterface(TargetVisualizer);

	InstigatorUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ReflectTargetID));

	InstigatingAction = X2Action_Fire(`XCOMVISUALIZATIONMGR.GetCurrentActionForVisualizer(TargetVisualizer));
	
	if (InstigatingAction.ProjectileVolleys.Length > 0)
	{
		ProjectileTemplate = InstigatingAction.ProjectileVolleys[0];
	}
	else
	{
		InstigatorAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(InstigatingAction.AbilityContext.InputContext.AbilityRef.ObjectID));
		if (InstigatorAbilityState != none)
		{
			Weapon = XGWeapon(InstigatorAbilityState.GetSourceWeapon().GetVisualizer());
			XComWeapon = XComWeapon(Weapon.m_kEntity);
			ProjectileTemplate = XComWeapon.DefaultProjectileTemplate;
		}
	}

	bHit = AbilityContext.ResultContext.HitResult == eHit_Success ? true : false;
	`LOG(default.class @ AbilityContext.ResultContext.HitResult @ bHit,, 'JediClassWOTCV2');

	ThisObj = self;
	`XEVENTMGR.RegisterForEvent(ThisObj, 'Visualizer_AbilityHit', OnProjectileFromActionToWaitFor, , , InstigatingAction);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'Visualizer_ProjectileHit', OnProjectileFromActionToWaitFor, , , InstigatingAction);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'X2Action_Completed', OnCompleteFromActionToWaitFor, , , InstigatingAction);
}

function SendProjectile(AnimNotify_FireWeaponVolley FireVolleyNotify)
{
	local X2VisualizerInterface TargetVisualizer;
	local vector Source, Target;
	local vector EmptyVector;
	local XComWorldData World;
	local TTile Tile;

	World = `XWORLD;
	
	if (ReflectTargetID == 0)
	{
		return;
	}

	if (ProjectileTemplate == none)
	{
		InstigatingAction = X2Action_Fire(`XCOMVISUALIZATIONMGR.GetCurrentActionForVisualizer(TargetUnitState.GetVisualizer()));
		ProjectileTemplate = InstigatingAction.ProjectileVolleys[0];
	}
	
	FireVolleyNotify.bCosmeticVolley = true;

	Source = UnitPawn.Location;

	//`log("X2Action_LightsaberDeflect DeflectTarget" @ SourceUnitState.ObjectID @ ReflectTargetID,, 'JediClassWOTCV2');
	if (TargetUnit.RestoreLocation != EmptyVector)
	{
		Target = TargetUnit.RestoreLocation;
	}
	else
	{
		TargetVisualizer = X2VisualizerInterface(`XCOMHISTORY.GetVisualizer(ReflectTargetID));
		Target = TargetVisualizer.GetShootAtLocation(eHit_Success, Metadata.StateObject_NewState.GetReference());
	}
	//`log("X2Action_LightsaberDeflect Target Unit" @ TargetUnitState.GetMyTemplateName() @ ReflectTargetID @ Target,, 'JediClassWOTCV2');
	if (bHit)
	{
		SpawnAndConfigureNewProjectile(ProjectileTemplate, FireVolleyNotify, AbilityContext, XComWeapon(WeaponVisualizer.m_kEntity));
	}
	else
	{
		Tile = World.GetTileCoordinatesFromPosition(Target);
		Tile.X += `SYNC_RAND(10) + 1 * `SYNC_RAND(1) == 0 ? 1 : -1;
		Tile.Y += `SYNC_RAND(10) + 1 * `SYNC_RAND(1) == 0 ? 1 : -1;
		Tile.Z += `SYNC_RAND(3);
		Target = World.GetPositionFromTileCoordinates(Tile);

		`log("X2Action_LightsaberDeflect Randomize Target" @ `ShowVar(Target),, 'JediClassWOTCV2');
		SpawnAndConfigureNewCosmeticProjectile(ProjectileTemplate, FireVolleyNotify, AbilityContext, Source, Target);
	}

	`log("X2Action_LightsaberDeflect SendProjectile" @ bHit @ ProjectileTemplate.ObjectArchetype,, 'JediClassWOTCV2');
}

private function SpawnAndConfigureNewCosmeticProjectile(Actor ProjectileTemplateIn,
												AnimNotify_FireWeaponVolley FireVolleyNotify,
												XComGameStateContext_Ability AbilityContext,
												vector Source,
												vector Target)
{
	local X2UnifiedProjectile NewProjectile;
	
	NewProjectile = class'WorldInfo'.static.GetWorldInfo().Spawn(class'X2UnifiedProjectile', , , , , ProjectileTemplateIn);
	NewProjectile.ConfigureNewProjectileCosmetic(FireVolleyNotify, AbilityContext, , , , Source, Target, false);
	NewProjectile.GotoState('Executing');

}

private function SpawnAndConfigureNewProjectile(Actor ProjectileTemplateIn,
												AnimNotify_FireWeaponVolley InVolleyNotify,
												XComGameStateContext_Ability AbilityContext,
												XComWeapon InSourceWeapon)
{
	local X2UnifiedProjectile NewProjectile;

	NewProjectile = Spawn(class'X2UnifiedProjectile', self, , , , ProjectileTemplateIn);
	NewProjectile.ConfigureNewProjectile(self, InVolleyNotify, AbilityContext, InSourceWeapon);
	NewProjectile.GotoState('Executing');
	AddProjectileVolley(NewProjectile);
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
		`log(default.Class @ GetFuncName() @ "sending projectiles",, 'JediClassWOTCV2');
		bSendProjectiles = true;
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn OnCompleteFromActionToWaitFor(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	`log(default.Class @ GetFuncName() @ "stopping anim",, 'JediClassWOTCV2');
	bShouldContinueAnim = false;
	return ELR_NoInterrupt;
}

function CompleteAction()
{
	local XComGameState_Ability AbilityState;
	local X2UnifiedProjectile LocalProjectileTemplate;
	local int ProjectileIndex;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(InstigatingAction.AbilityContext.InputContext.AbilityRef.ObjectID));
	
	`LOG("X2Action_LightsaberDeflect.CompleteAction",, 'JediClassWOTCV2');

	if (AbilityContext.ResultContext.EffectRedirects.Length > 0)
	{
		`LOG("X2Action_LightsaberDeflect Reseting bCanDamageNonFragile for " @ AbilityContext.InputContext.SourceObject.ObjectID,, 'JediClassWOTCV2');
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

		//`log(default.Class @ GetFuncName() @ "bSendProjectiles" @ bSendProjectiles,, 'JediClassWOTCV2');
		if (bSendProjectiles && !bProjectilesFired)
		{
			if (FireVolleyNotifies.Length == 0)
			{
				GetAttackerWeaponVolleyNotify(FireVolleyNotifies, OutNotifyTimes);
				`log("X2Action_LightsaberDeflect FireVolleyNotify" @ InstigatorUnitState.GetMyTemplateName() @ InstigatorUnitState @ FireVolleyNotifies.Length @ ProjectileTemplate,, 'JediClassWOTCV2');
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
					`log("X2Action_LightsaberDeflect Sending Volley" @ CurrentVolleyIndex @ NextProjectileTime @ ProjectileTimer,, 'JediClassWOTCV2');
					SendProjectile(FireVolleyNotifies[CurrentVolleyIndex]);
					ProjectileTimer = 0;
					CurrentVolleyIndex++;
				}
			}
			else if (OutNotifyTimes.Length > 0 && CurrentVolleyIndex == OutNotifyTimes.Length)
			{
				`log("X2Action_LightsaberDeflect End anim",, 'JediClassWOTCV2');
				bProjectilesFired = true;
			}
			else if (DummyNotify != none)
			{
				`log("X2Action_LightsaberDeflect Send dummy projectile",, 'JediClassWOTCV2');
				SendProjectile(DummyNotify);
				bProjectilesFired = true;
			}
		}
	}
Begin:
	Params.AnimName = 'HL_LightsaberReflectStart';
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	if (UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName))
	{
		PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	}
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(false); // Prevent Idle from kick in

	while(ActionTimer < StartOffsetTimer)
	{
		Sleep(0.0f);
	}

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	Params.AnimName = 'HL_LightsaberReflect';
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
				`log("X2Action_LightsaberDeflect PlayingSequence " @ bShouldContinueAnim,, 'JediClassWOTCV2');
				PlayingSequence.ReplayAnim();
				FinishAnim(PlayingSequence);
				Sleep(0.0f);
			}
			Sleep(0.0f);
			//if (FireVolleyNotifies.Length > 1)
			//{
			//	PlayingSequence.ReplayAnim();
			//	FinishAnim(PlayingSequence);
			//}
			`log("X2Action_LightsaberDeflect FinishAnim",, 'JediClassWOTCV2');
			`LOG("*******************************************************************************************************",, 'JediClassWOTCV2');
		}
	}
	else
	{
		`log("X2Action_LightsaberDeflect Failed to play animation" @ Params.AnimName @ "on" @ UnitPawn @ "as part of" @ self,, 'JediClassWOTCV2');
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

DefaultProperties
{
	NotifyTargetTimer = 4
	StartOffsetTimer = 0.7f
	TimeoutSeconds = 10.0f
	bResetWeaponsToDefaultSockets=false
	bShouldContinueAnim=true
}
