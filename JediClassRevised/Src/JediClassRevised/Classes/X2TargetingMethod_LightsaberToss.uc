class X2TargetingMethod_LightsaberToss extends X2TargetingMethod_OverTheShoulder;

var protected XComPrecomputedPath GrenadePath;
var protected transient XComEmitter ExplosionEmitter;
var protected XGWeapon WeaponVisualizer;

static function bool UseGrenadePath() { return true; }

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComGameState_Item WeaponItem;
	local X2WeaponTemplate WeaponTemplate;
	//local X2AbilityTemplate AbilityTemplate;

	super.Init(InAction, NewTargetIndex);

	// determine our targeting range
	WeaponItem = Ability.GetSourceWeapon();
	//AbilityTemplate = Ability.GetMyTemplate( );

	// show the grenade path
	WeaponTemplate = X2WeaponTemplate(WeaponItem.GetMyTemplate());
	WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());

	XComWeapon(WeaponVisualizer.m_kEntity).bPreviewAim = true;

	GrenadePath = XComTacticalGRI( class'Engine'.static.GetCurrentWorldInfo().GRI ).GetPrecomputedPath();	
	GrenadePath.SetupPath(WeaponVisualizer.GetEntity(), FiringUnit.GetTeam(), WeaponTemplate.WeaponPrecomputedPathData);
	GrenadePath.UpdateTrajectory();
}

static function name GetProjectileTimingStyle()
{
	if( UseGrenadePath() )
	{
		return default.ProjectileTimingStyle;
	}

	return '';
}

function Canceled()
{
	super.Canceled();

	ExplosionEmitter.Destroy();
	GrenadePath.ClearPathGraphics();
	XComWeapon(WeaponVisualizer.m_kEntity).bPreviewAim = false;
	ClearTargetedActors();
}

defaultproperties
{
	ProjectileTimingStyle="Timing_Grenade"
}