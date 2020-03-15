class X2Action_ForceJump extends X2Action_Move;

const StartLandingAnimationTime = 0.5;
const MinPathTime = 0.1;
const JumpStartPlayRate = 3.0;
const JumpStopPlayRate = 3.0;
const JumpRateScale = 0.5;
const StartScaleFrom = 0.1;
const StartJumpLoopTransitionEarly = 0.2;

var vector  DesiredLocation;

var private BoneAtom StartingAtom;
var private Rotator DesiredRotation;
var private CustomAnimParams Params;
var private vector StartingLocation;
var private float DistanceFromStartSquared;
var private bool ProjectileHit, bSkipJump;
var private float StopDistanceSquared; // distance from the origin of the grapple past which we are done
var private AnimNodeSequence PlayingSequence;
var private bool bStartTraversalAlongPath, bStartLandingAnimation;
var float TraversalTime;
var XComPrecomputedPath Path;
var XComGameStateContext_Ability AbilityContext;
var bool bSkipLandingAnimation;
var float TriggerDistance; // Distance (in tiles) for tile entry to trigger window breaks (or other enviromental destruction)

var string ForceJumpSoundCuePath;
var SoundCue ForceJumpSoundCue;
var AudioComponent ForceJumpSoundComponent;

function Init()
{
	local vector EmptyVector;
	
	super.Init();

	AbilityContext = XComGameStateContext_Ability(StateChangeContext);

	if (DesiredLocation == EmptyVector)
	{
		if (AbilityContext.InputContext.MovementPaths[0].MovementData.Length > 1)
		{
			DesiredLocation = AbilityContext.InputContext.MovementPaths[0].MovementData[AbilityContext.InputContext.MovementPaths[0].MovementData.Length - 1].Position;
		}
		else
		{
			DesiredLocation = UnitPawn.Location;
			bSkipJump = true;
		}
	}

	ForceJumpSoundCue = SoundCue(`CONTENT.RequestGameArchetype(ForceJumpSoundCuePath));
	ForceJumpSoundComponent = CreateAudioComponent(ForceJumpSoundCue, false);

	`LOG(default.class @ GetFuncName() @ `ShowVar(AbilityContext) @ `ShowVar(DesiredLocation),, 'JediClassWOTC');
}

function NotifyEnvironmentDamage(int PreviousPathTileIndex, bool bFragileOnly = true, bool bCheckForDestructibleObject = false)
{
	local float DestroyTileDistance;
	local Vector HitLocation;
	local Vector TileLocation;
	local XComGameState_EnvironmentDamage EnvironmentDamage;		
	local XComWorldData WorldData;
	local TTile PathTile;
	local int Index;		

	WorldData = `XWORLD;
	//If the unit jumped more than one tile index, make sure it is caught
	for(Index = PreviousPathTileIndex; Index <= PathTileIndex; ++Index)
	{
		if (bCheckForDestructibleObject)
		{
			//Only trigger nearby environment damage if the traversal to the next tile has a destructible object
			if (AbilityContext.InputContext.MovementPaths[MovePathIndex].Destructibles.Length == 0 || 
				AbilityContext.InputContext.MovementPaths[MovePathIndex].Destructibles.Find(Index + 1) == INDEX_NONE)
			{
				continue;
			}
		}

		foreach LastInGameStateChain.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamage)
		{
			`log(default.class @ GetFuncName() @ `showvar(EnvironmentDamage),, 'JediClassWOTC');
			if (EnvironmentDamage.DamageCause.ObjectID != Unit.ObjectID)
				continue;
			
			HitLocation = WorldData.GetPositionFromTileCoordinates(EnvironmentDamage.HitLocationTile);			
			PathTile = AbilityContext.InputContext.MovementPaths[MovePathIndex].MovementTiles[Index];
			TileLocation = WorldData.GetPositionFromTileCoordinates(PathTile);
			
			DestroyTileDistance = VSize(HitLocation - TileLocation);

			`log(default.class @ GetFuncName() @ `showvar(TileLocation),, 'JediClassWOTC');
			`log(default.class @ GetFuncName() @ `showvar(HitLocation),, 'JediClassWOTC');
			`log(default.class @ GetFuncName() @ `showvar(DestroyTileDistance),, 'JediClassWOTC');

			if(DestroyTileDistance < (class'XComWorldData'.const.WORLD_StepSize * TriggerDistance)) /* for force jump purposes, don't care about the fragile flag */
			{				
				`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamage, self);				
				`log(default.class @ GetFuncName() @ "Shots fired!!",, 'JediClassWOTC');
			}
		}
	}
}

simulated function bool MoveAlongPath(float fTime, XComUnitPawn pActor)
{
	local XKeyframe KF;
	local float UnitTileZ, FinishTime;
	local vector TargetLocation, PathEndPosition;
	local TTile Tile;
	local Rotator PawnRotation;
	
	//fTime *= 1.8;

	KF = Path.ExtractInterpolatedKeyframe(fTime);
	TargetLocation = KF.vLoc;

	// Clamp to floor tile when landing
	if (fTime > Path.akKeyframes[Path.iNumKeyframes / 4].fTime)
	{
		PathEndPosition = Path.GetEndPosition();
		Tile = `XWORLD.GetTileCoordinatesFromPosition(PathEndPosition);
		PathEndPosition = `XWORLD.GetPositionFromTileCoordinates(Tile);
		Path.akKeyframes[Path.iNumKeyframes-1].vLoc = PathEndPosition;
		UnitTileZ = `XWORLD.GetFloorZForPosition(PathEndPosition, true) + pActor.CollisionHeight + class'XComWorldData'.const.Cover_BufferDistance;
		TargetLocation.Z = Max(UnitTileZ, KF.vLoc.Z);
	}

	//`LOG(GetFuncName() @ `ShowVar(TargetLocation.Z) @ `ShowVar(KF.vLoc.Z),, 'JediClassWOTC');

	pActor.SetLocation(TargetLocation);
	PawnRotation = pActor.Rotation;
	PawnRotation.Yaw = KF.rRot.Yaw;
	pActor.SetRotation(PawnRotation);

	FinishTime = Path.akKeyframes[Path.iNumKeyframes-1].fTime;
	if (FinishTime - StartLandingAnimationTime > MinPathTime)
	{
		FinishTime -= StartLandingAnimationTime;
	}
	else
	{
		FinishTime -= MinPathTime;
	}

	if (fTime >= FinishTime)
		return true;
	else return false;
}

function InterpolatePath(float StartZ)
{
	local int Index;
	local float Diff, MaxDiff, Decrement;

	`LOG(default.class @ GetFuncName() @
		"PathTime" @ Path.akKeyframes[Path.iNumKeyframes-1].fTime
	,, 'JediClassWOTC');

	Diff = Path.akKeyframes[0].vLoc.Z - StartZ;
	MaxDiff = Diff;

	for(Index = 0; Index < Path.iNumKeyframes; Index++)
	{
		if (Index >= (Path.iNumKeyframes / 2) - 2)
		{
			Decrement = int((MaxDiff / Path.iNumKeyframes) + 0.5) * 2;
			Diff -= Max(Decrement, 0);
		}

		//`LOG(GetFuncName() @ `ShowVar(Diff),, 'JediClassWOTC');

		Path.akKeyframes[Index].vLoc.Z -= Diff;
		
		if (Path.akKeyframes[Path.iNumKeyframes-1].fTime >= StartScaleFrom)
		{
			Path.akKeyframes[Index].fTime *= JumpRateScale;
		}
	}
}

simulated state Executing
{
	//function SendWindowBreakNotifies()
	//{	
	//	local XComGameState_EnvironmentDamage EnvironmentDamage;
	//			
	//	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamage)
	//	{
	//		`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamage, self);
	//	}
	//}

	simulated event Tick(float fDelta)
	{
		if (bStartTraversalAlongPath)
		{
			TraversalTime += fDelta;

			if (MoveAlongPath(TraversalTime, UnitPawn))
			{
				bStartLandingAnimation = true;
			}
		}
	}

Begin:
	Path = XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).GetPrecomputedPath();

	`LOG(default.class @ GetFuncName() @
		`ShowVar(bSkipJump) @
		`ShowVar(UnitPawn.Location) @
		`ShowVar(DesiredLocation)
	,, 'JediClassWOTC');

	if (bSkipJump)
	{
		CompleteAction();
	}
	
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.bSkipIK = true;

	Params.AnimName = 'HL_ForceJumpStart';
	Params.PlayRate = JumpStartPlayRate;
	PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);

	`LOG(default.class @ GetFuncName() @ `ShowVar(Params.AnimName),, 'JediClassWOTC');

	sleep(PlayingSequence.GetAnimPlaybackLength() - StartJumpLoopTransitionEarly);

	Path.bUseOverrideTargetLocation = true;
	Path.bUseOverrideSourceLocation = true;
	Path.OverrideSourceLocation = UnitPawn.Location;
	Path.OverrideTargetLocation = DesiredLocation;
	Path.OverrideTargetLocation.Z = Unit.GetDesiredZForLocation(DesiredLocation);
	Path.bNoSpinUntilBounce = true;
	Path.UpdateTrajectory();
	Path.bUseOverrideTargetLocation = false;
	Path.bUseOverrideSourceLocation = false;
	InterpolatePath(Unit.Location.Z);

	`LOG(default.class @ GetFuncName() @ `ShowVar(UnitPawn.Location),, 'JediClassWOTC');

	bStartTraversalAlongPath = true;

	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	Params = default.Params;
	Params.AnimName = 'HL_ForceJumpLoop';
	PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params);
	ForceJumpSoundComponent.Play();
	while(!bStartLandingAnimation)
	{
		//PlayingSequence.ReplayAnim();
		FinishAnim(PlayingSequence, true, 0.05);
		if (bStartLandingAnimation)
		{
			PlayingSequence.StopAnim();
		}
		sleep(0);
		`LOG(default.class @ GetFuncName() @ `ShowVar(Params.AnimName),, 'JediClassWOTC');
		
	}
	PlayingSequence.StopAnim();

	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	
	UnitPawn.SnapToGround();

	if (!bSkipLandingAnimation)
	{
		Params = default.Params;
		Params.AnimName = 'HL_ForceJumpStop';
		Params.PlayRate = JumpStopPlayRate;
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(Params));
		UnitPawn.bSkipIK = false;
	}
	ForceJumpSoundComponent.Stop();

	`LOG(default.class @ GetFuncName() @ `ShowVar(Params.AnimName),, 'JediClassWOTC');

	UnitPawn.SetLocation(Path.OverrideTargetLocation);
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);

	CompleteAction();
}

defaultproperties
{
	ForceJumpSoundCuePath="JediClassAbilities.SFX.Jumpbuild_Cue"
	ProjectileHit = false;
	TriggerDistance = 0.5
}