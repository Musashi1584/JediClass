class X2TargetingMethod_LeapStrike extends X2TargetingMethod_MeleePath;

var private X2Actor_InvalidTarget InvalidTileActor;
var protected XComPrecomputedPath GrenadePath;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local MaterialInterface InvisibleMaterial;
	local PrecomputedPathData PrecomputedPathData;

	super.Init(InAction, NewTargetIndex);

	// hide the pathing spline
	InvisibleMaterial = MaterialInterface(`CONTENT.RequestGameArchetype("JediClassUI.CursorSet.CursorRibbonInvisible"));
	PathingPawn.PathMaterialNormal = InvisibleMaterial;
	PathingPawn.PathMaterialDashing = InvisibleMaterial;
	PathingPawn.RenderablePath.SetMaterial(InvisibleMaterial);
	PathingPawn.RenderablePath.SetHidden(true);

	
	PrecomputedPathData.InitialPathTime = 0.8;
	PrecomputedPathData.MaxPathTime = 2.5;
	PrecomputedPathData.MaxNumberOfBounces = 0;

	if (UseGrenadePath())
	{
		GrenadePath = `PRECOMPUTEDPATH;
		GrenadePath.ClearOverrideTargetLocation(); // Clear this flag in case the grenade target location was locked.
		GrenadePath.ActivatePath(XGWeapon(UnitState.GetPrimaryWeapon().GetVisualizer()).GetEntity(), FiringUnit.GetTeam(), PrecomputedPathData);
	}
}

function bool BlockInvalidTiles()
{
	return true;
}

function SetTargetByObjectID(int ObjectID)
{
	local int CurrentTargetIndex;

	for(CurrentTargetIndex = 0; CurrentTargetIndex < Action.AvailableTargets.Length; CurrentTargetIndex++)
	{
		if (Action.AvailableTargets[CurrentTargetIndex].PrimaryTarget.ObjectID == ObjectID)
		{
			DirectSetTarget(CurrentTargetIndex);
		}
	}
}


function DirectSetTarget(int TargetIndex)
{
	local array<TTile> PathTiles;
	local TTile TargetTile;

	super.DirectSetTarget(TargetIndex);

	GetPreAbilityPath(PathTiles);
	TargetTile = PathTiles[PathTiles.Length - 1];
	UpdatePathComponents(TargetTile);
}

function TickUpdatedDestinationTile(TTile TargetTile)
{
	super.TickUpdatedDestinationTile(TargetTile);
	UpdatePathComponents(TargetTile);
}

function UpdatePathComponents(TTile Destination)
{
	GrenadePath.bUseOverrideTargetLocation = true;
	GrenadePath.OverrideTargetLocation = `XWORLD.GetPositionFromTileCoordinates(Destination);
	PathingPawn.RenderablePath.SetHidden(true);
}

protected function Vector GetPathDestination()
{
	local XComWorldData WorldData;
	local array<TTile> PathTiles;
	local TTile Tile;

	WorldData = `XWORLD;

	GetPreAbilityPath(PathTiles);
	Tile = PathTiles[PathTiles.Length - 1];
	
	return WorldData.GetPositionFromTileCoordinates(Tile);
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	TargetLocations.Length = 0;
	TargetLocations.AddItem(TargetUnit.GetPawn().Location);
}

function Update(float DeltaTime)
{
	local vector NewTargetLocation;
	local TTile NewTile;
	local array<vector> TargetLocations;

	super.Update(DeltaTime);
	
	NewTargetLocation = GetPathDestination();

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
			NewTile = `XWORLD.GetTileCoordinatesFromPosition(NewTargetLocation);
			if (BlockInvalidTiles())
			{
				UpdatePathingPawnTile(NewTile);
				DrawInvalidTile();
			}
		}
	}
}

function UpdatePathingPawnTile(TTile TargetTile)
{
	local vector GrenadePathLocation;
	local TTile Tile, GrenadePathTile;
	local int Index;

	for (Index = PathingPawn.PossibleTiles.Length - 1; Index >=0; Index--)
	{
		Tile = PathingPawn.PossibleTiles[Index];

		if (TargetTile != Tile)
		{
			continue;
		}

		GrenadePathLocation = GrenadePath.GetEndPosition();
		GrenadePathTile = `XWORLD.GetTileCoordinatesFromPosition(GrenadePathLocation);
		
		if (GrenadePathTile != TargetTile)
		{
			`LOG(default.class @ GetFuncName() @ "Removing Tile" @ Index @ "from PossibleTiles" @ Tile.X @ Tile.Y @ Tile.Z,, 'JediClassWOTCV2');
			PathingPawn.PossibleTiles.Remove(Index, 1);
			
		}
	}

	PathingPawn.UpdatePossibleTilesVisuals();
	PathingPawn.DoUpdatePuckVisuals(PathingPawn.PossibleTiles[0], TargetUnit, Ability.GetMyTemplate());
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local vector PathLocation, GrenadePathLocation;
	local TTile PathTile, GrenadePathTile;
	local XComWorldData WorldData;
	local array<TTile> PathTiles;
	
	WorldData = `XWORLD;

	if (TargetLocations.Length == 1)
	{
		GrenadePathLocation = GrenadePath.GetEndPosition();
		GrenadePathTile = WorldData.GetTileCoordinatesFromPosition(GrenadePathLocation);
		
		GetPreAbilityPath(PathTiles);
		PathTile = PathTiles[PathTiles.Length - 1];

		//`LOG(default.class @ GetFuncName() @ GrenadePathTile.X @ GrenadePathTile.Y @ GrenadePathTile.Z @ "/" @ PathTile.X @ PathTile.Y @ PathTile.Z,, 'JediClassWOTCV2');

		if (PathTile == GrenadePathTile)
		{
			//`LOG(default.class @ GetFuncName() @ "AA_Success",, 'JediClassWOTCV2');
			return 'AA_Success';
		}
	}

	//`LOG(default.class @ GetFuncName() @ "AA_NoTargets",, 'JediClassWOTCV2');

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
	PathingPawn.SlashingMeshComponent.SetHidden(false);
	PathingPawn.RebuildOnlySplinepathingInformation(GrenadePathTile);
}

simulated protected function DrawInvalidTile()
{
	local Vector Location;

	Location = GetPathDestination();

	InvalidTileActor.SetHidden(false);
	InvalidTileActor.SetLocation(Location);

	//IconManager.SetHidden(true);
	PathingPawn.SlashingMeshComponent.SetHidden(true);
	PathingPawn.Waypoints.Length = 0;
	PathingPawn.HazardMarkers.Length = 0;
	PathingPawn.NoiseMarkers.Length = 0;
	PathingPawn.ConcealmentMarkers.Length = 0;
	PathingPawn.LaserScopeMarkers.Length = 0;
	PathingPawn.KillZoneMarkers.Length = 0;
	PathingPawn.UpdatePathMarkers();
}


function Canceled()
{
	super.Canceled();

	// unlock the 3d cursor
	Cursor.m_fMaxChainedDistance = -1;
	
	if (UseGrenadePath())
	{
		GrenadePath.ClearPathGraphics();
	}
}


static function bool UseGrenadePath() { return true; }

static function name GetProjectileTimingStyle()
{
	if( UseGrenadePath() )
	{
		return default.ProjectileTimingStyle;
	}

	return '';
}

static function name GetOrdnanceType()
{
	if( UseGrenadePath() )
	{
		return default.OrdnanceTypeName;
	}

	return '';
}

defaultproperties
{
	ProjectileTimingStyle="Timing_Grenade"
	OrdnanceTypeName="Ordnance_Grenade"
}