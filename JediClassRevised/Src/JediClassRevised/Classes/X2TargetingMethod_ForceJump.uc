class X2TargetingMethod_ForceJump extends X2TargetingMethod_PathTarget;

var X2Actor_InvalidTarget InvalidTileActor;
var XComPrecomputedPath GrenadePath;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local PrecomputedPathData PrecomputedPathData;
	local float TargetingRange;
	local XGBattle Battle;
	local MaterialInterface InvisibleMaterial;
	
	super.Init(InAction, NewTargetIndex);

	Battle = `BATTLE;

	InvalidTileActor = Battle.Spawn(class'X2Actor_InvalidTarget');

	// determine our targeting range
	//AbilityTemplate = Ability.GetMyTemplate();
	TargetingRange = Ability.GetAbilityCursorRangeMeters();

	// lock the cursor to that range
	//Cursor = `Cursor;
	Cursor.m_fMaxChainedDistance = `METERSTOUNITS(TargetingRange);

	// hide the pathing spline
	PathingPawn.RenderablePath.SetHidden(true);
	
	InvisibleMaterial = MaterialInterface(`CONTENT.RequestGameArchetype("JediClassUI.CursorSet.CursorRibbonInvisible"));

	PathingPawn.PathMaterialNormal = InvisibleMaterial;
	PathingPawn.PathMaterialDashing = InvisibleMaterial;
	PathingPawn.RenderablePath.SetMaterial(InvisibleMaterial);
	// Always use blue puck
	PathingPawn.PuckMeshDashing = StaticMesh(DynamicLoadObject(PathingPawn.PuckMeshName, class'StaticMesh'));

	PrecomputedPathData.InitialPathTime = 0.8;
	PrecomputedPathData.MaxPathTime = 2.5;
	PrecomputedPathData.MaxNumberOfBounces = 0;
	GrenadePath = `PRECOMPUTEDPATH;
	GrenadePath.ClearOverrideTargetLocation(); // Clear this flag in case the grenade target location was locked.
	GrenadePath.ActivatePath(XGWeapon(UnitState.GetPrimaryWeapon().GetVisualizer()).GetEntity(), FiringUnit.GetTeam(), PrecomputedPathData);
	
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	TargetLocations.Length = 0;
	TargetLocations.AddItem(GrenadePath.GetEndPosition());
}

function Update(float DeltaTime)
{
	local vector NewTargetLocation;
	local array<vector> TargetLocations;

	PathingPawn.RenderablePath.SetHidden(true);

	super.Update(DeltaTime);
	
	NewTargetLocation = GetPathDestination();
	UpdatePathComponents(NewTargetLocation);

	if (NewTargetLocation != CachedTargetLocation)
	{
		TargetLocations.Length = 0;
		TargetLocations.AddItem(GrenadePath.GetEndPosition());

		if (ValidateTargetLocations(TargetLocations) == 'AA_Success')
		{
			DrawValidTile();
		}
		else
		{
			DrawInvalidTile();
		}
	}
}


function UpdatePathComponents(vector Destination)
{
	GrenadePath.bUseOverrideTargetLocation = true;
	GrenadePath.OverrideTargetLocation = Destination;

	//`LOG(GrenadePath.kRenderablePath.HiddenGame @ GrenadePath.TouchEvents.Length,, 'JediClassRevised');
}

static function bool UseGrenadePath() { return true; }

function Canceled()
{
	super.Canceled();

	// clean up the ui
	InvalidTileActor.Destroy();

	// unlock the 3d cursor
	Cursor.m_fMaxChainedDistance = -1;

	GrenadePath.ClearPathGraphics();
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local vector PathLocation, GrenadePathLocation;
	local TTile PathTile, GrenadePathTile;
	local XComWorldData WorldData;
	
	WorldData = `XWORLD;

	if (TargetLocations.Length == 1)
	{
		GrenadePathLocation = TargetLocations[0];
		PathLocation = GetPathDestination();

		GrenadePathTile = WorldData.GetTileCoordinatesFromPosition(GrenadePathLocation);
		PathTile = WorldData.GetTileCoordinatesFromPosition(PathLocation);

		`LOG(default.class @ GetFuncName() @ GrenadePathTile.X @ GrenadePathTile.Y @ GrenadePathTile.Z @ "/" @ PathTile.X @ PathTile.Y @ PathTile.Z,, 'JediClassRevised');

		if (PathTile == GrenadePathTile)
		{
			return 'AA_Success';
		}
	}
	return 'AA_NoTargets';
}

simulated protected function DrawValidTile()
{
	local vector GrenadePathLocation;
	local TTile GrenadePathTile;
	local XComWorldData WorldData;

	WorldData = `XWORLD;

	GrenadePathLocation = GrenadePath.GetEndPosition();
	GrenadePathTile = WorldData.GetTileCoordinatesFromPosition(GrenadePathLocation);

	InvalidTileActor.SetHidden(true);
	Cursor.SetHidden(false);
	PathingPawn.PuckMeshComponent.SetHidden(false);
	PathingPawn.RebuildOnlySplinepathingInformation(GrenadePathTile);
}

simulated protected function DrawInvalidTile()
{
	local Vector Location;

	Location = GetPathDestination();

	InvalidTileActor.SetHidden(false);
	InvalidTileActor.SetLocation(Location);

	Cursor.SetHidden(true);
	PathingPawn.PuckMeshComponent.SetHidden(true);
	PathingPawn.Waypoints.Length = 0;
	PathingPawn.HazardMarkers.Length = 0;
	PathingPawn.NoiseMarkers.Length = 0;
	PathingPawn.ConcealmentMarkers.Length = 0;
	PathingPawn.LaserScopeMarkers.Length = 0;
	PathingPawn.KillZoneMarkers.Length = 0;
	PathingPawn.UpdatePathMarkers();
}


//function name ValidateTargetLocations(const array<Vector> TargetLocations)
//{
//	local name AbilityAvailability;
//	local TTile TeleportTile;
//	local XComWorldData World;
//	local bool bFoundFloorTile;
//
//	AbilityAvailability = super.ValidateTargetLocations(TargetLocations);
//	if( AbilityAvailability == 'AA_Success' )
//	{
//		World = `XWORLD;
//		
//		bFoundFloorTile = World.GetFloorTileForPosition(TargetLocations[0], TeleportTile);
//		if( bFoundFloorTile && !World.CanUnitsEnterTile(TeleportTile) )
//		{
//			AbilityAvailability = 'AA_TileIsBlocked';
//		}
//	}
//
//	return AbilityAvailability;
//}