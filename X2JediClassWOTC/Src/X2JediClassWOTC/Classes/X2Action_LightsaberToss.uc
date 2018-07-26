class X2Action_LightsaberToss extends X2Action_Fire;

var protected bool bWaitingToFire, bCanComplete, bReturnedToSource, bSnap;

// the index of the next target in AbilityContext.InputContext.MultiTargets
var protected array<StateObjectReference> Targets;

var protected int iNextNotifyIndex, iProjectileNotifyHitIndex;

var protected float fTimeSinceLastSnap, fSnapInterval, ActionTimout;

var protected vector LastLocation;

var string LightsaberSound_Cue_Path;
var protected SoundCue LightsaberSound_Cue;
var protected AudioComponent LightsaberSoundComponent;

var CustomAnimParams Params;

function AddProjectileVolley(X2UnifiedProjectile NewProjectile)
{
	bWaitingToFire = false;
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
	
	SetProjectileColor();

	bWaitingToFire = true;
	bCanComplete = false;
	bReturnedToSource = false;
	bSnap = true;
}

function SetProjectileColor()
{
	local MaterialInterface Mat;
	local MaterialInstanceConstant MIC;
	local MeshComponent MeshComp;
	local int i;

	MeshComp = XComWeapon(WeaponVisualizer.m_kEntity).Mesh;
	if (MeshComp != none)
	{
		for (i = 0; i < MeshComp.GetNumElements(); ++i)
		{
			Mat = MeshComp.GetMaterial(i);
			MIC = MaterialInstanceConstant(Mat);
			if (InStr(MIC.Parent, "MAT_Lightsaber_Blade") != INDEX_NONE)
				XComWeapon(WeaponVisualizer.m_kEntity).DefaultProjectileTemplate.ProjectileElements[0].DefaultParticleSystemInstanceParameterSet.InstanceParameters[0].Material = MIC;
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

function NotifyTargetsProjectileHit()
{
	// Just leave here to overwrite the super function
	//super.NotifyTargetsProjectileHit();
}

function ProjectileNotifyHit(bool bMainImpactNotify, Vector HitLocation)
{
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_InteractiveObject InteractiveObject;
	local XComInteractiveLevelActor InteractiveLevelActor;
	local XComGameState_Unit PrimaryTargetState;
	local vector RightHandLocation;

	`log("X2Action_LightsaberToss ProjectileNotifyHit" @ bMainImpactNotify @ iProjectileNotifyHitIndex @ "/" @ Targets.Length @ HitLocation @ UnitPawn.Location,, 'X2JediClassWOTC');

	//`log("X2Action_LightsaberToss vector comparison" @ HitLocation.X ~= UnitPawn.Location.X @ HitLocation.Y ~= UnitPawn.Location.Y @ HitLocation.Z ~= UnitPawn.Location.Z @ "/" @ class'Helpers'.static.AreVectorsDifferent(HitLocation, UnitPawn.Location, 1),, 'X2JediClassWotc');

	if (iProjectileNotifyHitIndex < Targets.Length && bMainImpactNotify)
	{
		// Notify target
		AbilityContext.InputContext.MultiTargetsNotified[iProjectileNotifyHitIndex] = true;
		iProjectileNotifyHitIndex++;

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
		PrimaryTargetState = XComGameState_Unit(History.GetGameStateForObjectID(PrimaryTargetID));
		`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', PrimaryTargetState, self);
		`XEVENTMGR.TriggerEvent('Visualizer_AbilityHit', self, self);
		ProjectileHitLocation = HitLocation;
		NotifyTargetsAbilityApplied();
	}

	//if (HitLocation.X ~= UnitPawn.Location.X && HitLocation.Y ~= UnitPawn.Location.Y && HitLocation.Z ~= UnitPawn.Location.Z)
	
	UnitPawn.Mesh.GetSocketWorldLocationAndRotation('R_Hand', RightHandLocation);
	if (!class'Helpers'.static.AreVectorsDifferent(HitLocation, RightHandLocation, 0.1))
	{
		//`log("X2Action_LightsaberToss ReturnToSource" @ iProjectileNotifyHitIndex @ Targets.Length,, 'X2JediClassWotc');
		LightsaberReturned();
		bReturnedToSource = true;
		bSnap = true;
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
	}

	simulated function UpdateSnaps(float fDeltaT)
	{
		if (!bWaitingToFire)
		{
			fTimeSinceLastSnap += fDeltaT;
		}

		//`log(bSnap,, 'X2JediClassWotc');
		if (bSnap && !bCanComplete)
		{
			//`log("iNextNotifyIndex" @ iNextNotifyIndex @ "Targets.Length" @ Targets.Length,, 'X2JediClassWotc');
			DoSnap();
			fTimeSinceLastSnap = 0.0f;
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
		//local StateObjectReference TargetRef;

		`log(default.Class @ GetFuncName() @ iNextNotifyIndex @Targets.Length,, 'X2JediClassWotc');

		if (iNextNotifyIndex >= Targets.Length)
		{
			`log("X2Action_LightsaberToss Return Lightsaber to unit location" @ UnitPawn.Location,, 'X2JediClassWotc');
			UnitPawn.Mesh.GetSocketWorldLocationAndRotation('R_Hand', NextTargetLocation);
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
	
	while (!bCanComplete || !bReturnedToSource)
	{
		Sleep(0.0f);
		if (ActionTimout <= 0)
		{
			bCanComplete = true;
			bReturnedToSource = true;
			LightsaberReturned();
			break;
		}
	}

	if (bCanComplete && bReturnedToSource)
	{
		//UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
		Params = default.Params;
		Params.AnimName = 'FF_LightsaberTossStopA';
		Params.Looping = false;
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));
		//UnitPawn.GetAnimTreeController().SetAllowNewAnimations(false);
	}
	
	Sleep(0.5f);
	//`LOG("*******************************************************************************************************",, 'X2JediClassWOTC');
	CompleteAction();
}

defaultproperties
{
	LightsaberSound_Cue_Path="LightSaber_CV.SFX.LightsaberSwingLoop_Cue"
	fSnapInterval = 0.4f
	bNotifyMultiTargetsAtOnce = false
	ActionTimout = 10
}