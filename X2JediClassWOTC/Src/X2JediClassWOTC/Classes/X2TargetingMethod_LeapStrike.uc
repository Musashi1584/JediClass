class X2TargetingMethod_LeapStrike extends X2TargetingMethod_MeleePath;

var private X2Actor_InvalidTarget InvalidTileActor;
var protected XComPrecomputedPath GrenadePath;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local PrecomputedPathData PrecomputedPathData;

	super.Init(InAction, NewTargetIndex);
	
	PrecomputedPathData.InitialPathTime = 1;
	PrecomputedPathData.MaxPathTime = 2.5;
	PrecomputedPathData.MaxNumberOfBounces = 0;

	if (UseGrenadePath())
	{
		GrenadePath = `PRECOMPUTEDPATH;
		GrenadePath.ClearOverrideTargetLocation(); // Clear this flag in case the grenade target location was locked.
		GrenadePath.ActivatePath(XGWeapon(UnitState.GetPrimaryWeapon().GetVisualizer()).GetEntity(), FiringUnit.GetTeam(), PrecomputedPathData);
	}

	PathingPawn.RenderablePath.SetHidden(true);
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

function TickUpdatedDestinationTile(TTile NewDestination)
{
	super.TickUpdatedDestinationTile(NewDestination);
	UpdatePathComponents(NewDestination);
}

function UpdatePathComponents(TTile Destination)
{
	GrenadePath.bUseOverrideTargetLocation = true;
	GrenadePath.OverrideTargetLocation = `XWORLD.GetPositionFromTileCoordinates(Destination);
	PathingPawn.RenderablePath.SetHidden(true);
}

function Canceled()
{
	super.Canceled();
	
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