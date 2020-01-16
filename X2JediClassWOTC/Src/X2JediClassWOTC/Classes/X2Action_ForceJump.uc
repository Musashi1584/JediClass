class X2Action_ForceJump extends X2Action_Fire;

var vector  DesiredLocation;

var private BoneAtom StartingAtom;
var private Rotator DesiredRotation;
var private CustomAnimParams Params;
var private vector StartingLocation;
var private float DistanceFromStartSquared;
var private bool ProjectileHit;
var private float StopDistanceSquared; // distance from the origin of the grapple past which we are done
var private AnimNodeSequence PlayingSequence;
var private bool bStartTraversalAlongPath, bArrivedAtLocation;
var float TraversalTime;
var XComPrecomputedPath Path;

function ProjectileNotifyHit(bool bMainImpactNotify, Vector HitLocation)
{
	ProjectileHit = true;
}

simulated function bool MoveAlongPath(float fTime, XComUnitPawn pActor)
{
	local XKeyframe KF;
	local float UnitTileZ;
	local vector TargetLocation, PathEndPosition;
	
	// Double speed
	fTime *= 1.5;

	KF = Path.ExtractInterpolatedKeyframe(fTime);
	TargetLocation = KF.vLoc;

	// Clamp to floor tile when landing
	if (fTime > Path.akKeyframes[Path.iNumKeyframes/2].fTime)
	{
		PathEndPosition = Path.GetEndPosition();
		UnitTileZ = `XWORLD.GetFloorZForPosition(PathEndPosition, true) + pActor.CollisionHeight + class'XComWorldData'.const.Cover_BufferDistance;
		TargetLocation.Z = Max(UnitTileZ, KF.vLoc.Z);
	}

	`LOG(GetFuncName() @ `ShowVar(UnitTileZ) @ `ShowVar(TargetLocation.Z) @ `ShowVar(KF.vLoc.Z),, 'X2JediClassWOTC');

	pActor.SetLocation(TargetLocation);
	//pActor.SetRotation(KF.rRot);

	if (fTime >= Path.akKeyframes[Path.iNumKeyframes-1].fTime)
		return true;
	else return false;
}

function InterpolatePath(float StartZ)
{
	local int Index;
	local float Diff, MaxDiff;

	Diff = Path.akKeyframes[0].vLoc.Z - StartZ;
	MaxDiff = Diff;

	for(Index = 0; Index < Path.iNumKeyframes; Index++)
	{
		if (Index >= Path.iNumKeyframes / 2)
		{
			Diff -= Max((MaxDiff / Path.iNumKeyframes) * 2, 0);
		}

		`LOG(GetFuncName() @ `ShowVar(Diff),, 'X2JediClassWOTC');

		Path.akKeyframes[Index].vLoc.Z -= Diff;
	}
}

function vector AdjustZPositionForPawn(vector Loc)
{
	Loc.Z = `XWORLD.GetFloorZForPosition(Loc, true); // + UnitPawn.CollisionHeight + class'XComWorldData'.const.Cover_BufferDistance;
	return Loc;
}

simulated state Executing
{
	function SendWindowBreakNotifies()
	{	
		local XComGameState_EnvironmentDamage EnvironmentDamage;
				
		foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamage)
		{
			`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamage, self);
		}
	}

	simulated event Tick(float fDelta)
	{
		if (bStartTraversalAlongPath)
		{
			TraversalTime += fDelta;

			if (MoveAlongPath(TraversalTime, UnitPawn))
			{
				bArrivedAtLocation = true;
			}
		}
	}

Begin:
	`LOG(GetFuncName() @ `ShowVar(UnitPawn.Location),, 'X2JediClassWOTC');
	
	Path = XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).GetPrecomputedPath();

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;

	Params.AnimName = 'HL_TeleportStart';
	UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

	sleep(0.1);

	Path.bUseOverrideTargetLocation = true;
	Path.bUseOverrideSourceLocation = true;
	Path.OverrideSourceLocation = UnitPawn.Location;
	Path.OverrideTargetLocation = AdjustZPositionForPawn(Path.GetEndPosition());
	Path.bNoSpinUntilBounce = true;
	Path.UpdateTrajectory();
	Path.bUseOverrideTargetLocation = false;
	Path.bUseOverrideSourceLocation = false;
	InterpolatePath(UnitPawn.Location.Z);

	`LOG(GetFuncName() @ `ShowVar(UnitPawn.Location),, 'X2JediClassWOTC');

	bStartTraversalAlongPath = true;

	while(!bArrivedAtLocation)
	{
		sleep(0);
	}

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.SnapToGround();

	Params = default.Params;
	Params.AnimName = 'HL_TeleportStop';
	Params.DesiredEndingAtoms.Add(1);
	Params.DesiredEndingAtoms[0].Scale = 1.0f;
	Params.DesiredEndingAtoms[0].Translation = DesiredLocation;
	DesiredRotation = UnitPawn.Rotation;
	DesiredRotation.Pitch = 0.0f;
	DesiredRotation.Roll = 0.0f;
	Params.DesiredEndingAtoms[0].Rotation = QuatFromRotator(DesiredRotation);
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));
	UnitPawn.bSkipIK = false;

	CompleteAction();
}

function CompleteAction()
{
	super.CompleteAction();

	// since we step out of and step into cover from different tiles, 
	// need to set the enter cover restore to the destination location
	Unit.RestoreLocation = DesiredLocation;
}

defaultproperties
{
	ProjectileHit = false;
}


	//while( ProjectileHit == false )
	//{
	//	Sleep(0.0f);
	//}

	// Have an emphasis on seeing the grapple tight
	//Sleep(0.1f);

	//Params.AnimName = 'NO_GrappleStart';
	//DesiredLocation.Z = Unit.GetDesiredZForLocation(DesiredLocation);
	//DesiredRotation = Rotator(Normal(DesiredLocation - UnitPawn.Location));
	//StartingAtom.Rotation = QuatFromRotator(DesiredRotation);
	//StartingAtom.Translation = UnitPawn.Location;
	//StartingAtom.Scale = 1.0f;
	//UnitPawn.GetAnimTreeController().GetDesiredEndingAtomFromStartingAtom(Params, StartingAtom);
	//PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	//
	//// hide the targeting icon
	//Unit.SetDiscState(eDS_None);
	//
	//StartingLocation = UnitPawn.Location;
	//StopDistanceSquared = Square(VSize(DesiredLocation - StartingLocation) - UnitPawn.fStrangleStopDistance);
	//
	//// to protect against overshoot, rather than check the distance to the target, we check the distance from the source.
	//// Otherwise it is possible to go from too far away in front of the target, to too far away on the other side
	//DistanceFromStartSquared = 0;
	//while( DistanceFromStartSquared < StopDistanceSquared )
	//{
	//	if( !PlayingSequence.bRelevant || !PlayingSequence.bPlaying || PlayingSequence.AnimSeq == None )
	//	{
	//		if( DistanceFromStartSquared < StopDistanceSquared )
	//		{
	//			`RedScreen("Grapple never made it to the destination");
	//		}
	//		break;
	//	}
	//
	//	Sleep(0.0f);
	//	DistanceFromStartSquared = VSizeSq(UnitPawn.Location - StartingLocation);
	//}

	// send messages to do the window break visualization
	//SendWindowBreakNotifies();
