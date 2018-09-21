class X2Action_LightsaberToss extends X2Action_Fire;

var protected bool bWaitingToFire, bCanComplete, bReturnedToSource, bSnap;

// the index of the next target in AbilityContext.InputContext.MultiTargets
var protected array<StateObjectReference> Targets;

var protected int iNextNotifyIndex, iProjectileNotifyHitIndex;

var protected float ActionTimout;

var protected vector LastLocation;

var string LightsaberSound_Cue_Path;
var protected SoundCue LightsaberSound_Cue;
var protected AudioComponent LightsaberSoundComponent;

var CustomAnimParams Params;
var AnimNodeSequence IdleAnim;
var name IdleAnimationName, StopAnimationName;

function AddProjectileVolley(X2UnifiedProjectile NewProjectile)
{
	`log(default.Class @ GetFuncName() @ "AddProjectileVolley",, 'X2JediClassWOTC');
	super.AddProjectileVolley(NewProjectile);
}

function Init()
{
	local XComGameState_Item WeaponItem;
	//local X2WeaponTemplate WeaponTemplate;
	local XComGameState_Ability AbilityState;
	local StateObjectReference Target;

	super.Init();

	Targets.AddItem(AbilityContext.InputContext.PrimaryTarget);
	foreach AbilityContext.InputContext.MultiTargets(Target)
	{
		Targets.AddItem(Target);
	}

	UnitPawn.Mesh.GetSocketWorldLocationAndRotation('R_Hand', LastLocation);
	`log(default.Class @ GetFuncName() @ LastLocation.X @ LastLocation.Y @ LastLocation.Z,, 'X2JediClassWOTC');

	LightsaberSound_Cue = SoundCue(`CONTENT.RequestGameArchetype(LightsaberSound_Cue_Path));
	LightsaberSoundComponent = CreateAudioComponent(LightsaberSound_Cue, false);
	
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	WeaponItem = AbilityState.GetSourceWeapon();
	WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());
	
	if(AbilityTemplate.bHideWeaponDuringFire)
	{
		WeaponVisualizer.GetEntity().Mesh.SetHidden(false);
	}

	SetProjectileColor();

	//bWaitingToFire = true;
	//bCanComplete = false;
	//bReturnedToSource = false;
	//bSnap = true;
}

function SetProjectileColor()
{
	local MaterialInterface Mat;
	local MaterialInstanceConstant MIC;
	local MaterialInstanceTimeVarying MITV;
	local MeshComponent MeshComp;
	local int i;

	MeshComp = XComWeapon(WeaponVisualizer.m_kEntity).Mesh;
	if (MeshComp != none)
	{
		for (i = 0; i < MeshComp.GetNumElements(); ++i)
		{
			Mat = MeshComp.GetMaterial(i);
			MIC = MaterialInstanceConstant(Mat);
			`log(default.class @ GetFuncName() @ "MIC" @ i @ MIC @ MIC.Parent,, 'X2JediClassWOTC');
			if (InStr(MIC.Parent, "MAT_Lightsaber_Blade") != INDEX_NONE)
			{
				`log(default.class @ GetFuncName() @ "MIC" @ "applying",, 'X2JediClassWOTC');
				XComWeapon(WeaponVisualizer.m_kEntity).DefaultProjectileTemplate.ProjectileElements[0].DefaultParticleSystemInstanceParameterSet.InstanceParameters[0].Material = MIC;
			}
			
			MITV = MaterialInstanceTimeVarying(Mat);
			`log(default.class @ GetFuncName() @ "MITV" @ i @ MITV @ MITV.Parent,, 'X2JediClassWOTC');
			if (InStr(MITV.Parent, "MAT_Lightsaber_Blade") != INDEX_NONE)
			{
				`log(default.class @ GetFuncName() @ "MITV" @ "applying",, 'X2JediClassWOTC');
				XComWeapon(WeaponVisualizer.m_kEntity).DefaultProjectileTemplate.ProjectileElements[0].DefaultParticleSystemInstanceParameterSet.InstanceParameters[0].Material = MITV;
			}
		}
	}
}

function SendProjectile(vector Source, vector Target, bool bReturnToSource = false)
{
	local XComWeapon WeaponEntity;
	local X2UnifiedProjectile NewProjectile;
	local AnimNotify_FireWeaponVolley FireVolleyNotify;
	
	WeaponEntity = WeaponVisualizer.GetEntity();

	FireVolleyNotify = new class'AnimNotify_FireWeaponVolley';
	FireVolleyNotify.NumShots = 1;
	FireVolleyNotify.ShotInterval = 0.3f;
	FireVolleyNotify.bCosmeticVolley = true;

	NewProjectile = class'WorldInfo'.static.GetWorldInfo().Spawn(class'X2UnifiedProjectile', , , , , WeaponEntity.DefaultProjectileTemplate);
	NewProjectile.ConfigureNewProjectileCosmetic(FireVolleyNotify, AbilityContext, , , self, Source, Target, true);
	NewProjectile.ProjectileElements[0].ReturnsToSource = bReturnToSource;
	NewProjectile.GotoState('Executing');

	//PlaySound(LightsaberSound_Cue);
	`log("X2Action_LightsaberToss SendProjectile to" @ Target,, 'X2JediClassWOTC');
}

function NotifyTargetsAbilityApplied()
{
	`log("X2Action_LightsaberToss" @ GetFuncName() @ "was called",, 'X2JediClassWOTC');
}

function DoNotifyTargetsAbilityAppliedWithMultipleHitLocations(XComGameState NotifyVisualizeGameState, XComGameStateContext_Ability NotifyAbilityContext,
									   int HistoryIndex, Vector HitLocation, array<Vector> allHitLocations, int PrimaryTargetID = 0, bool bNotifyMultiTargetsAtOnce = true )
{
	`log("X2Action_LightsaberToss" @ GetFuncName() @ "was called",, 'X2JediClassWOTC');
}

function ProjectileNotifyHit(bool bMainImpactNotify, Vector HitLocation)
{
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_InteractiveObject InteractiveObject;
	local XComInteractiveLevelActor InteractiveLevelActor;
	local XComGameState_Unit TargetState;
	local vector RightHandLocation;
	local float HandProximity;
	local bool bReturn;

	if (bReturnedToSource)
	{
		return;
	}

	`log("X2Action_LightsaberToss ProjectileNotifyHit" @ bMainImpactNotify @ iProjectileNotifyHitIndex @ "/" @ Targets.Length @ HitLocation @ UnitPawn.Location,, 'X2JediClassWOTC');

	bReturn = Targets.Length == iProjectileNotifyHitIndex;

	if (iProjectileNotifyHitIndex < Targets.Length && bMainImpactNotify)
	{
		// Notify target
		AbilityContext.InputContext.MultiTargetsNotified[iProjectileNotifyHitIndex] = true;

		foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
		{		
			if(EnvironmentDamageEvent.HitLocation == HitLocation)
			{
				`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamageEvent, self);
			}
		}

		foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
		{
			InteractiveLevelActor = XComInteractiveLevelActor(History.GetVisualizer(InteractiveObject.ObjectID));
			if (VSize2D(InteractiveLevelActor.Location - HitLocation) < (class'XComWorldData'.const.WORLD_StepSize))
			{
				`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', InteractiveObject, self);
			}
		}

		bSnap = true;
		TargetState = XComGameState_Unit(History.GetGameStateForObjectID(Targets[iProjectileNotifyHitIndex].ObjectID));
		`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', TargetState, self);
		//
		ProjectileHitLocation = HitLocation;
		iProjectileNotifyHitIndex++;
		//NotifyTargetsAbilityApplied();
	}

	UnitPawn.Mesh.GetSocketWorldLocationAndRotation('R_Hand', RightHandLocation);

	if (bReturn)
	{
		`XEVENTMGR.TriggerEvent('Visualizer_AbilityHit', self, self);
		`log("X2Action_LightsaberToss bMainImpactNotify" @ bMainImpactNotify @ "/" @ iProjectileNotifyHitIndex @ "/" @ Targets.Length,, 'X2JediClassWotc');
		`log("X2Action_LightsaberToss HitLocation" @ HitLocation,, 'X2JediClassWotc');
		`log("X2Action_LightsaberToss RightHandLocation" @ RightHandLocation,, 'X2JediClassWotc');

		for (HandProximity = 0.0; HandProximity <= 50.0;  HandProximity+=0.1)
		{
			if (!class'Helpers'.static.AreVectorsDifferent(HitLocation, RightHandLocation, HandProximity))
			{
				`log("X2Action_LightsaberToss AreVectorsDifferent" @ HandProximity @ class'Helpers'.static.AreVectorsDifferent(HitLocation, RightHandLocation, HandProximity),, 'X2JediClassWotc');
				`log("X2Action_LightsaberToss returned to source" @ iProjectileNotifyHitIndex @ Targets.Length,, 'X2JediClassWotc');
				bReturnedToSource = true;
				bSnap = true;
				break;
			}
		}
	}
}

function LightsaberReturned()
{
	if(AbilityTemplate.bHideWeaponDuringFire)
	{
		WeaponVisualizer.GetEntity().Mesh.SetHidden(false);
	}
	LightsaberSoundComponent.Stop();
}

simulated state Executing
{
	simulated event Tick(float fDeltaT)
	{
		ActionTimout -= fDeltaT;
		UpdateSnaps(fDeltaT);
		SetProjectileColor();
	}

	simulated function UpdateSnaps(float fDeltaT)
	{
		//`log(bSnap,, 'X2JediClassWotc');
		if (bSnap && !bCanComplete)
		{
			//`log("iNextNotifyIndex" @ iNextNotifyIndex @ "Targets.Length" @ Targets.Length,, 'X2JediClassWotc');
			DoSnap();
			if (iNextNotifyIndex >= Targets.Length + 1)
			{
				bCanComplete = true;
			}
		}
	}

	simulated function DoSnap()
	{
		local vector NextTargetLocation;
		local X2VisualizerInterface Target;

		`log(default.Class @ GetFuncName() @ iNextNotifyIndex @Targets.Length,, 'X2JediClassWotc');

		if (iNextNotifyIndex >= Targets.Length)
		{
			UnitPawn.Mesh.GetSocketWorldLocationAndRotation('R_Hand', NextTargetLocation);
			`log("X2Action_LightsaberToss Return Lightsaber to location" @ NextTargetLocation,, 'X2JediClassWotc');
			SendProjectile(LastLocation, NextTargetLocation, false);
		}
		else if (iNextNotifyIndex < Targets.Length)
		{
			Target = X2VisualizerInterface(`XCOMHISTORY.GetVisualizer(Targets[iNextNotifyIndex].ObjectID));
		
			NextTargetLocation = Target.GetShootAtLocation(eHit_Success, Metadata.StateObject_NewState.GetReference());
						
			if (iNextNotifyIndex > 0)
			{
				`log("X2Action_LightsaberToss Shooting Lightsaber at target" @ NextTargetLocation @ Targets.Length @ iNextNotifyIndex,, 'X2JediClassWotc');

				SendProjectile(LastLocation, NextTargetLocation, false);
			}

			LastLocation = NextTargetLocation;
		}
		iNextNotifyIndex++;
		bSnap = false;
	}


Begin:
	//`LOG("*******************************************************************************************************",, 'X2JediClassWOTC');
	Unit.CurrentFireAction = self;
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

	LightsaberSoundComponent.Play();

	if(AbilityTemplate.bHideWeaponDuringFire)
	{
		WeaponVisualizer.GetEntity().Mesh.SetHidden(true);
	}

	if (!bCanComplete)
	{
		`LOG("Start" @ IdleAnimationName,, 'X2JediClassWotc');
		Params = default.Params;
		Params.AnimName = IdleAnimationName;
		Params.Looping = true;
		if(UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName))
		{
			IdleAnim = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
		}
	}
	
	while (!bCanComplete || !bReturnedToSource)
	{
		Sleep(0.0f);

		if (ActionTimout <= 0)
		{
			bCanComplete = true;
			bReturnedToSource = true;
			`LOG("Timeout",, 'X2JediClassWotc');
			break;
		}
	}

	if (bCanComplete && bReturnedToSource)
	{
		IdleAnim.StopAnim();
		UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
		`LOG(default.class @ "Start" @ StopAnimationName,, 'X2JediClassWotc');
		LightsaberReturned();
		Params = default.Params;
		Params.AnimName = StopAnimationName;
		Params.Looping = false;
		if (UnitPawn.GetAnimTreeController().CanPlayAnimation(Params.AnimName))
		{
			FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));
		}
		
		//UnitPawn.GetAnimTreeController().SetAllowNewAnimations(false);
		CompleteAction();
	}
	
	//Sleep(0.5f);
	//`LOG("*******************************************************************************************************",, 'X2JediClassWOTC');
	CompleteAction();
}

defaultproperties
{
	LightsaberSound_Cue_Path="LightSaber_CV.SFX.LightsaberSwingLoop_Cue"
	bNotifyMultiTargetsAtOnce = false
	ActionTimout = 10
	bWaitingToFire = true
	bCanComplete = false
	bReturnedToSource = false
	bSnap = true
	IdleAnimationName = "NO_IdleGunUp"
	StopAnimationName = "FF_LightsaberTossStopA"
}