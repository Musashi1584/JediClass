class X2TargetingMethod_ForceJump extends X2TargetingMethod_Grenade;

var private X2Actor_InvalidTarget InvalidTileActor;
var private XComActionIconManager IconManager;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComGameStateHistory History;
	local PrecomputedPathData PrecomputedPathData;
	local float TargetingRange;
	local X2AbilityTarget_Cursor CursorTarget;
	//local X2AbilityTemplate AbilityTemplate;
	local XGBattle Battle;
	
	super(X2TargetingMethod).Init(InAction, NewTargetIndex);
	
	Battle = `BATTLE;
	History = `XCOMHISTORY;

	InvalidTileActor = Battle.Spawn(class'X2Actor_InvalidTarget');
	ExplosionEmitter.SetHidden(true);

	IconManager = `PRES.GetActionIconMgr();
	IconManager.UpdateCursorLocation(true);

	AssociatedPlayerState = XComGameState_Player(History.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));
	`assert(AssociatedPlayerState != none);

	// determine our targeting range
	//AbilityTemplate = Ability.GetMyTemplate();
	TargetingRange = Ability.GetAbilityCursorRangeMeters();

	// lock the cursor to that range
	Cursor = `Cursor;
	Cursor.m_fMaxChainedDistance = `METERSTOUNITS(TargetingRange);

	// set the cursor location to itself to make sure the chain distance updates
	Cursor.CursorSetLocation(Cursor.GetCursorFeetLocation(), false, true); 

	CursorTarget = X2AbilityTarget_Cursor(Ability.GetMyTemplate().AbilityTargetStyle);
	if (CursorTarget != none)
		bRestrictToSquadsightRange = CursorTarget.bRestrictToSquadsightRange;

	PrecomputedPathData.InitialPathTime = 0.8;
	PrecomputedPathData.MaxPathTime = 2.5;
	PrecomputedPathData.MaxNumberOfBounces = 0;

	if (UseGrenadePath())
	{
		GrenadePath = `PRECOMPUTEDPATH;
		GrenadePath.ClearOverrideTargetLocation(); // Clear this flag in case the grenade target location was locked.
		GrenadePath.ActivatePath(XGWeapon(UnitState.GetPrimaryWeapon().GetVisualizer()).GetEntity(), FiringUnit.GetTeam(), PrecomputedPathData);
	}

	//ExplosionEmitter.SetHidden(true);
}

function Update(float DeltaTime)
{
	local vector NewTargetLocation;
	local array<vector> TargetLocations;
	local array<TTile> Tiles;
	local XComWorldData World;

	NewTargetLocation = GetSplashRadiusCenter();

	if( NewTargetLocation != CachedTargetLocation )
	{
		// The target location has moved, check to see if the new tile
		// is a valid location for the mimic beacon
		TargetLocations.AddItem(Cursor.GetCursorFeetLocation());
		if( ValidateTargetLocations(TargetLocations) == 'AA_Success' )
		{
			// The current tile the cursor is on is a valid tile
			// Show the ExplosionEmitter
			ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
			InvalidTileActor.SetHidden(true);

			World = `XWORLD;

			Tiles.AddItem(World.GetTileCoordinatesFromPosition(TargetLocations[0]));
			DrawAOETiles(Tiles);
			IconManager.UpdateCursorLocation(, true);
		}
		else
		{
			DrawInvalidTile();
		}
	}

	UpdateTargetLocation(DeltaTime);
}

simulated protected function DrawInvalidTile()
{
	local Vector Center;

	Center = GetSplashRadiusCenter();

	// Hide the ExplosionEmitter
	ExplosionEmitter.ParticleSystemComponent.DeactivateSystem();
	
	InvalidTileActor.SetHidden(false);
	InvalidTileActor.SetLocation(Center);
}


function Canceled()
{
	super.Canceled();

	// clean up the ui
	InvalidTileActor.Destroy();

	// unlock the 3d cursor
	Cursor.m_fMaxChainedDistance = -1;
	
	if (UseGrenadePath())
	{
		GrenadePath.ClearPathGraphics();
	}
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local name AbilityAvailability;
	local TTile TeleportTile;
	local XComWorldData World;
	local bool bFoundFloorTile;

	AbilityAvailability = super.ValidateTargetLocations(TargetLocations);
	if( AbilityAvailability == 'AA_Success' )
	{
		World = `XWORLD;
		
		bFoundFloorTile = World.GetFloorTileForPosition(TargetLocations[0], TeleportTile);
		if( bFoundFloorTile && !World.CanUnitsEnterTile(TeleportTile) )
		{
			AbilityAvailability = 'AA_TileIsBlocked';
		}
	}

	return AbilityAvailability;
}