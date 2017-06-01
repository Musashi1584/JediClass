class X2Action_ForcePush extends X2Action;

var float AnimationDelay;

var private Vector Destination, ImpulseDirection;
var private Rotator OldRotation;
var private XComGameState_Unit NewUnitState;
var private StateObjectReference DmgObjectRef;
var private CustomAnimParams AnimParams;
var private XComGameStateContext_Ability AbilityContext;
var private vector EndingLocation, Currentlocation;
var private float DistanceToTargetSquared, FattyMult, CloseEnoughDistance;
var private XComWorldData WorldData;	
var private int iTries, iFattyMult;
var private TTile UnitTileLocation;
var private XComGameStateHistory History;

function Init(const out VisualizationTrack InTrack)
{
	super.Init(InTrack);

	History = class'XComGameStateHistory'.static.GetGameStateHistory();
	WorldData = class'XComWorldData'.static.GetWorldData();

	NewUnitState = XComGameState_Unit(InTrack.StateObject_NewState);
	NewUnitState.GetKeystoneVisibilityLocation(UnitTileLocation);

	//Destination = WorldData.GetPositionFromTileCoordinates(UnitTileLocation);
	//
	//bNeedsPhysicsFixup = VSize2D(Destination - UnitPawn.Location) > 192.0f || (Destination.Z - UnitPawn.Location.Z > 192.0f);
	//PhysicsImpulse = Normal(Destination - UnitPawn.Location);
	//PhysicsImpulse.Z = 0.0f;
	//ShouldFaceVec = -PhysicsImpulse;
	//
	//PhysicsImpulse *= VSize2D(Destination - UnitPawn.Location) * 1.5f;
	//PhysicsImpulse += Vect(0, 0, 1) * 400.0f;
	//PhysicsImpulse.Z = WorldData.GetFloorZForPosition(Destination, true) + UnitPawn.CollisionHeight + class'XComWorldData'.const.Cover_BufferDistance;

	Destination = WorldData.GetPositionFromTileCoordinates(UnitTileLocation);
	Destination.Z = WorldData.GetFloorZForPosition(Destination, true) + UnitPawn.CollisionHeight + class'XComWorldData'.const.Cover_BufferDistance;	

	EndingLocation = Destination;
}

function bool CheckInterrupted()
{
	return false;
}

function ResumeFromInterrupt(int HistoryIndex)
{
	super.ResumeFromInterrupt(HistoryIndex);
}

function StartRagdoll()
{
	UnitPawn.StartRagDoll(false, , , false);
}


simulated state Executing
{
	simulated event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);

		`SHAPEMGR.DrawSphere(Destination, vect(5, 5, 80), MakeLinearColor(1, 0, 0, 1), true);
	}

	simulated event EndState(name NextStateName)
	{
		super.EndState(NextStateName);
		if (!IsTimedOut()) 
		{
			Currentlocation = UnitPawn.Location;
		}
	}
	
	function MaybeNotifyEnvironmentDamage()
	{
		local XComGameState_EnvironmentDamage EnvironmentDamage;		
		local TTile CurrentTile;

		CurrentTile = `XWORLD.GetTileCoordinatesFromPosition(Unit.Location);
		
		foreach StateChangeContext.AssociatedState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamage)
		{
			if(EnvironmentDamage.HitLocationTile == CurrentTile)
			{			
				DmgObjectRef = EnvironmentDamage.GetReference();				
				SetTimer(0.3f, false, nameof(DelayedNotify)); //Add a small delay since the is tile based 
			}
		}
	}

	function DelayedNotify()
	{
		VisualizationMgr.SendInterTrackMessage(DmgObjectRef);
	}

	function CopyPose()
	{
		AnimParams.AnimName = 'Pose';
		AnimParams.Looping = true;
		AnimParams.BlendTime = 0.0f;
		AnimParams.HasPoseOverride = true;
		AnimParams.Pose = UnitPawn.Mesh.LocalAtoms;
		UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);
	}

Begin:	
	sleep(AnimationDelay);

	UnitPawn.DeathRestingLocation = EndingLocation;
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(false);
	UnitPawn.SetFinalRagdoll(false);

	OldRotation = UnitPawn.Rotation;
	Unit.SetDiscState(eDS_None);
	StartRagdoll();
	UnitPawn.SetPhysics(PHYS_RigidBody);
	UnitPawn.Mesh.bSyncActorLocationToRootRigidBody = true;

	//Some units need a little extra nudge
	FattyMult = 1.0f;
	if (string(UnitPawn.Mesh.PhysicsAsset) == "PHYS_AdventMecII") FattyMult = 3.0f;
	if (string(UnitPawn.Mesh.PhysicsAsset) == "PHYS_Berserker") FattyMult = 3.0f;
	if (string(UnitPawn.Mesh.PhysicsAsset) == "PHYS_Andromedon") FattyMult = 1.5f;
	if (string(UnitPawn.Mesh.PhysicsAsset) == "PHYS_AndromedonRobot") FattyMult = 1.5f;
	if (string(UnitPawn.Mesh.PhysicsAsset) == "SM_AdventDrone_Physics") FattyMult = 0.3f;
	

	//do a little launch to allow for sucking over cover
	ImpulseDirection = vect(0,0,1000);
	UnitPawn.Mesh.AddImpulse(ImpulseDirection * FattyMult);
	Sleep( 0.2f );

	DistanceToTargetSquared = VSizeSq2D(EndingLocation - UnitPawn.Location);
	If (DistanceToTargetSquared > CloseEnoughDistance/2)
	{
		ImpulseDirection = EndingLocation - UnitPawn.Location;
		If (ImpulseDirection.Z >= -10) ImpulseDirection.Z += 150; //give a slight launching impulse if the targetlocation isnt beneath us
		ImpulseDirection = ImpulseDirection * 0.2;
		UnitPawn.SetRagdollLinearDriveToDestination(EndingLocation, ImpulseDirection, 0.5f, 2.0f);
		DistanceToTargetSquared = VSizeSq2D(EndingLocation - UnitPawn.Location);
	}
	sleep(0.5f);
	

	//Do additional impulses to get our target near the intended position
	iTries = 0;
	DistanceToTargetSquared = VSizeSq2D(EndingLocation - UnitPawn.Location);
	While (DistanceToTargetSquared > CloseEnoughDistance && iTries < 50)
	{
		iTries += 1;
		ImpulseDirection = EndingLocation - UnitPawn.Location;
		If (ImpulseDirection.Z >= -50) ImpulseDirection.Z += 150; //give a slight launching impulse if the targetlocation isnt beneath us
		ImpulseDirection = ImpulseDirection * 0.4;

		UnitPawn.Mesh.AddImpulse(ImpulseDirection);
		sleep (0.01f);
		DistanceToTargetSquared = VSizeSq2D(EndingLocation - UnitPawn.Location);
	}

	if(!NewUnitState.IsDead() && !NewUnitState.IsIncapacitated())
	{		
		//Reset visualizers for primary weapon, in case it was dropped
		Unit.GetInventory().GetPrimaryWeapon().Destroy(); //Aggressively get rid of the primary weapon, because dropping it can really screw things up
		Unit.ApplyLoadoutFromGameState(NewUnitState, None);

		UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);

		// Copy all the bone transforms so we match his pose
		CopyPose();

		UnitPawn.EndRagDoll();

		UnitPawn.EnableRMA(true, true);
		UnitPawn.EnableRMAInteractPhysics(true);
		UnitPawn.EnableFootIK(false);

		//Get Up!
		AnimParams = default.AnimParams;
		AnimParams.AnimName = 'HL_GetUp';
		AnimParams.BlendTime = 0.5f;
		AnimParams.HasDesiredEndingAtom = true;
		AnimParams.DesiredEndingAtom.Translation = Destination;
		AnimParams.DesiredEndingAtom.Translation.Z = UnitPawn.GetGameUnit().GetDesiredZForLocation(AnimParams.DesiredEndingAtom.Translation);
		AnimParams.DesiredEndingAtom.Rotation = QuatFromRotator(OldRotation);
		AnimParams.DesiredEndingAtom.Scale = 1.0f;
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

		UnitPawn.EnableFootIK(true);
		UnitPawn.EnableRMA(false, false);
		UnitPawn.EnableRMAInteractPhysics(false);

		Unit.ProcessNewPosition();
		Unit.IdleStateMachine.CheckForStanceUpdate();
		//UnitPawn.m_fDistanceMovedAlongPath = KnockbackDistance;
	}
	
	CompleteAction();	
}

function CompleteAction()
{	
	super.CompleteAction();
}

DefaultProperties
{
	CloseEnoughDistance = 2500.0f
}
