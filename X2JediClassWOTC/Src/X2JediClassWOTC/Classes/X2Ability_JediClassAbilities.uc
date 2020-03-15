class X2Ability_JediClassAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(JediClass);


var config int FORCE_JUMP_COST;
//var config int FORCE_MEDITATE_CHARGES;
var config int FORCE_MEDITATE_COOLDOWN;
var config float FORCE_MEDITATE_REGEN_PERCENT;

var config int FORCE_DRAIN_RADIUS;
var config int FORCE_DRAIN_CHARGES;
var config int FORCE_DRAIN_COOLDOWN;
var config int FORCE_DRAIN_COST;

var config int FORCE_SENSE_RADIUS;

var config int BATTLE_MEDITATION_COOLDOWN;
var config int BATTLE_MEDITATION_COST;

var config int ENERGY_ABSORPTION_SHIELD_POINTS;

var config int FORCE_FEAR_COOLDOWN;
var config int FORCE_FEAR_COST;
var config int FORCE_FEAR_CONE_LENGTH_TILES;
var config int FORCE_FEAR_CONE_END_DIAMETER_TILES;
var config int FORCE_FEAR_TURNS;

var config int FORCE_SPEED_COOLDOWN;
var config int FORCE_SPEED_COST;

var config int MIND_CONTROL_CHARGES;
var config int MIND_CONTROL_COOLDOWN;
var config int MIND_CONTROL_COST;

var config int FORCE_HEAL_CHARGES;
var config int FORCE_HEAL_COOLDOWN;
var config int FORCE_HEAL_COST;
var config int FORCE_HEAL_PERUSEHP;

var config int MIND_TRICKS_COOLDOWN;
var config int MIND_TRICKS_COST;
var config int MIND_TRICKS_RANGE;
var config int MIND_TRICKS_RADIUS;
var config int MIND_TRICKS_TURNS;

var config int FORCE_PUSH_COOLDOWN;
var config int FORCE_PUSH_COST;
var config int FORCE_PUSH_KNOCKBACK_DISTANCE;

var config int FORCE_WIND_COOLDOWN;
var config int FORCE_WIND_COST;
var config int FORCE_WIND_KNOCKBACK_DISTANCE;
var config int FORCE_WIND_CONE_LENGTH_TILES;
var config int FORCE_WIND_CONE_END_DIAMETER_TILES;
var config int FORCE_WIND_ENVIRONMENTAL_DAMAGE;

var config int FORCE_LIGHTNING_STUNNED_ACTIONS;
var config int FORCE_LIGHTNING_STUN_CHANCE;
var config int FORCE_LIGHTNING_COOLDOWN;
var config int FORCE_LIGHTNING_COST;

var config int FORCE_CHAIN_LIGHTNING_STUNNED_ACTIONS;
var config int FORCE_CHAIN_LIGHTNING_STUN_CHANCE;
var config int FORCE_CHAIN_LIGHTNING_COOLDOWN;
var config int FORCE_CHAIN_LIGHTNING_COST;

var config WeaponDamageValue FORCE_LIGHTNING_BASEDAMAGE;
var config WeaponDamageValue FORCE_CHAIN_LIGHTNING_BASEDAMAGE;
var config WeaponDamageValue FORCE_CHOKE_BASEDAMAGE;
var config WeaponDamageValue FORCE_PUSH_BASEDAMAGE;
var config WeaponDamageValue FORCE_WIND_BASEDAMAGE;
var config WeaponDamageValue FORCE_DRAIN_BASEDAMAGE;

var config int LIGHTSABER_MULTI_TOSS_COOLDOWN;
var config int LIGHTSABER_MULTI_TOSS_COST;
var config int LIGHTSABER_MULTI_TOSS_MAX_TARGETS;
var config float LIGHTSABER_MULTI_TOSS_NEXT_TARGET_MAXLENGTH;

var config int LIGHTSABER_TOSS_COOLDOWN;
var config int LIGHTSABER_TOSS_COST;

var config int LEAP_STRIKE_COST;

var config int REFLECT_BONUS;
var config int REPEATING_MALUS;
var config int REFLECT_HIT_DIFFICULTY;

var privatewrite name ForceDrainEventName;
var privatewrite name ForceDrainUnitValue;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> AbilityTemplates;

	AbilityTemplates.AddItem(BattlePrecognition());
	AbilityTemplates.AddItem(BattlePrecognitionLeapStrike());
	AbilityTemplates.AddItem(LeapStrike());
	AbilityTemplates.AddItem(ForceJump());
	AbilityTemplates.AddItem(ForcePowerPool());
	AbilityTemplates.AddItem(Holocron('HolocronPool_CV',3));
	AbilityTemplates.AddItem(Holocron('HolocronPool_MG',2));
	AbilityTemplates.AddItem(Holocron('HolocronPool_BM',1));
	AbilityTemplates.AddItem(ForceMeditate());
	AbilityTemplates.AddItem(ForceDrain());
	AbilityTemplates.AddItem(ForceProtection());
	AbilityTemplates.AddItem(ForceSense());
	AbilityTemplates.AddItem(BattleMeditation());
	AbilityTemplates.AddItem(EnergyAbsorption());
	AbilityTemplates.AddItem(ForceFear());
	AbilityTemplates.AddItem(ForceSpeed());
	AbilityTemplates.AddItem(MindControl());
	AbilityTemplates.AddItem(ForceHeal());
	AbilityTemplates.AddItem(MindTricks());
	AbilityTemplates.AddItem(ForceWind());
	AbilityTemplates.AddItem(ForcePush());
	AbilityTemplates.AddItem(ForceChoke());
	AbilityTemplates.AddItem(ForceLightning());
	AbilityTemplates.AddItem(ForceChainLightning());

	AbilityTemplates.AddItem(LightsaberSlash());
	AbilityTemplates.AddItem(LightsaberTelekinesis());
	AbilityTemplates.AddItem(LightsaberToss());
	AbilityTemplates.AddItem(LightsaberDeflect());
	AbilityTemplates.AddItem(LightsaberDeflectShot('LightsaberDeflectShot'));
	AbilityTemplates.AddItem(LightsaberReflect());
	AbilityTemplates.AddItem(LightsaberDeflectShot('LightsaberReflectShot'));

	// Helper abilities, should not be assigned directly
	AbilityTemplates.AddItem(ForceJumpTraversal());
	AbilityTemplates.AddItem(LeapStrikeFleche());
	AbilityTemplates.AddItem(ForceDrainTriggered());
	AbilityTemplates.AddItem(ForceSenseTrigger());
	AbilityTemplates.AddItem(ForceSenseSpawnTrigger());
	AbilityTemplates.AddItem(ForceLightningAnimSets());
	AbilityTemplates.AddItem(ForceAbilitiesAnimSet());
	AbilityTemplates.AddItem(ForceAlignmentModifier());
	AbilityTemplates.AddItem(ForcePoolBonusDamage());
	AbilityTemplates.AddItem(AddSyncedAnimationDeathOverride());

	return AbilityTemplates;
}

static function X2AbilityTemplate LightsaberSlash()
{
	local X2AbilityTemplate				Template;
	local X2Effect_OverrideDeathAction	DeathActionEffect;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('LightsaberSlash');
	Template.ActionFireClass = class'X2Action_Fire_SyncedAnimation';

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_SyncedAnimationDeath';
	Template.AddTargetEffect(DeathActionEffect);

	Template.OverrideAbilities.AddItem(class'X2Ability_RangerAbilitySet'.default.SwordSliceName);

	return Template;
}

static function X2AbilityTemplate BattlePrecognition()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_TriggerAbilityReaction   CoveringFireEffect;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BattlePrecognition');
	
	Template.bDontDisplayInAbilitySummary = false;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	ActionPointCost.DoNotConsumeAllEffects.Length = 0;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
	ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_SkirmisherInterrupt'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	Template.AddTargetEffect(ReserveActionPointsEffect);
	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_Y;

	CoveringFireEffect = new class'X2Effect_TriggerAbilityReaction';
	CoveringFireEffect.GrantActionPoint = 'Move';
	CoveringFireEffect.MaxActionPointsPerTurn = 1;
	CoveringFireEffect.bPreEmptiveFire = true;
	CoveringFireEffect.bDirectAttackOnly = false;
	CoveringFireEffect.bUseMultiTargets = false;
	CoveringFireEffect.AbilityToActivate = 'BattlePrecognitionLeapStrike'; //'SwordSlice';
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('LongWatch');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	Template.AdditionalAbilities.AddItem('BattlePrecognitionLeapStrike');

	return Template;	
}

static function X2AbilityTemplate BattlePrecognitionLeapStrike()
{
	local X2AbilityTemplate									Template;
	local X2AbilityToHitCalc_StandardMelee					StandardMelee;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local array<name>										SkipExclusions;
	local X2AbilityCost_ReserveActionPoints					ReserveActionPointCost;
	local X2AbilityCost_ForcePoints							FPCost;
	local X2Effect_Persistent								ShadowStepEffect;
	local X2Condition_Visibility							VisibilityCondition;
	local X2Effect_OverrideDeathAction						DeathActionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BattlePrecognitionLeapStrike');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///JediClassUI.UIPerk_LeapStrike";
	Template.bHideOnClassUnlock = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.LEAP_STRIKE_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
	
	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_BattlePregognition';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireBasicVisibility = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Do not trigger overwatch
	ShadowStepEffect = new class'X2Effect_Persistent';
	ShadowStepEffect.EffectName = 'Shadowstep';
	ShadowStepEffect.DuplicateResponse = eDupe_Ignore;
	ShadowStepEffect.BuildPersistentEffect(1, false, false);
	Template.AddShooterEffect(ShadowStepEffect);

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_SyncedAnimationDeath';
	Template.AddTargetEffect(DeathActionEffect);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	
	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.ActionFireClass = class'X2Action_Fire_SyncedAnimation';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = LeapStrike_BuildVisualization;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');
	//Template.AdditionalAbilities.AddItem('LeapStrikeFleche');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}


static function X2AbilityTemplate LeapStrike()
{
	local X2AbilityTemplate									Template;
	local X2AbilityToHitCalc_StandardMelee					StandardMelee;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local array<name>										SkipExclusions;
	local X2AbilityCost_ActionPoints						ActionPointCost;
	local X2AbilityCost_ForcePoints							FPCost;
	local X2Effect_Persistent								ShadowStepEffect;
	local X2Condition_Visibility							VisibilityCondition;
	local X2Effect_OverrideDeathAction						DeathActionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LeapStrike');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///JediClassUI.UIPerk_LeapStrike";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 1;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.LEAP_STRIKE_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
	
	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_LeapStrike';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireBasicVisibility = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Do not trigger overwatch
	ShadowStepEffect = new class'X2Effect_Persistent';
	ShadowStepEffect.EffectName = 'Shadowstep';
	ShadowStepEffect.DuplicateResponse = eDupe_Ignore;
	ShadowStepEffect.BuildPersistentEffect(1, false, false);
	Template.AddShooterEffect(ShadowStepEffect);

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_SyncedAnimationDeath';
	Template.AddTargetEffect(DeathActionEffect);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	
	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	Template.SourceMissSpeech = 'SwordMiss';
	//Template.CustomFireKillAnim = 'MV_MeleeKill';

	Template.ModifyNewContextFn = PrecomputedPathMovement_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = LeapStrike_BuildVisualization;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');
	//Template.AdditionalAbilities.AddItem('LeapStrikeFleche');

	Template.ActionFireClass = class'X2Action_Fire_SyncedAnimation';

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	return Template;
}

static simulated function XComGameState LeapStrike_BuildGameState_UNUSED(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local vector NewLocation;
	local TTile NewTileLocation;
	local XComWorldData World;
	local X2EventManager EventManager;
	local int LastElementIndex;

	World = `XWORLD;
	EventManager = `XEVENTMGR;

	//Build the new game state frame
	NewGameState = TypicalAbility_BuildGameState(Context);

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());	
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));

	LastElementIndex = AbilityContext.InputContext.MovementPaths[0].MovementData.Length - 1;

	// Set the unit's new location
	// The last position in MovementData will be the end location
	//`assert(LastElementIndex > 0);
	`LOG(GetFuncName() @ LastElementIndex,, 'X2JediClassWOTC');
	if (LastElementIndex > 0)
	{
		NewLocation = AbilityContext.InputContext.MovementPaths[0].MovementData[LastElementIndex].Position;
		NewTileLocation = World.GetTileCoordinatesFromPosition(NewLocation);
		UnitState.SetVisibilityLocation(NewTileLocation);
		`LOG(GetFuncName() @ NewTileLocation.X @ NewTileLocation.Y @ NewTileLocation.Z,, 'X2JediClassWOTC');
	}
	

	AbilityContext.ResultContext.bPathCausesDestruction = MoveAbility_StepCausesDestruction(UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
	MoveAbility_AddTileStateObjects(NewGameState, UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);

	EventManager.TriggerEvent('ObjectMoved', UnitState, UnitState, NewGameState);
	EventManager.TriggerEvent('UnitMoveFinished', UnitState, UnitState, NewGameState);

	return NewGameState;
}

// Copy of TypicalAbility_BuildVisualization for the most part
function LeapStrike_BuildVisualization(XComGameState VisualizeGameState)
{
	//general
	local XComGameStateHistory	History;
	local XComGameStateVisualizationMgr VisualizationMgr;

	//visualizers
	local Actor	TargetVisualizer, ShooterVisualizer;

	//actions
	local X2Action							AddedAction;
	local X2Action							FireAction;
	local X2Action_MoveTurn					MoveTurnAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover;
	local X2Action_ExitCover				ExitCoverAction;
	//local X2Action_MoveTeleport				TeleportMoveAction;
	//local X2Action_Delay					MoveDelay;
	//local X2Action_MoveEnd					MoveEnd;
	local X2Action_MarkerNamed				JoinActions;
	local array<X2Action>					LeafNodes;
	local X2Action_WaitForAnotherAction		WaitForFireAction;

	//state objects
	local XComGameState_Ability				AbilityState;
	local XComGameState_EnvironmentDamage	EnvironmentDamageEvent;
	local XComGameState_WorldEffectTileData WorldDataUpdate;
	local XComGameState_InteractiveObject	InteractiveObject;
	local XComGameState_BaseObject			TargetStateObject;
	local XComGameState_Item				SourceWeapon;
	local StateObjectReference				ShootingUnitRef;

	//interfaces
	local X2VisualizerInterface			TargetVisualizerInterface, ShooterVisualizerInterface;

	//contexts
	local XComGameStateContext_Ability	Context;
	local AbilityInputContext			AbilityContext;

	//templates
	local X2AbilityTemplate	AbilityTemplate;
	local X2AmmoTemplate	AmmoTemplate;
	local X2WeaponTemplate	WeaponTemplate;
	local array<X2Effect>	MultiTargetEffects;

	//Tree metadata
	local VisualizationActionMetadata   InitData;
	local VisualizationActionMetadata   BuildData;
	local VisualizationActionMetadata   SourceData, InterruptTrack;

	local XComGameState_Unit TargetUnitState;	
	local name         ApplyResult;

	//indices
	local int	EffectIndex, TargetIndex;
	//local int	TrackIndex;
	local int	WindowBreakTouchIndex;

	//flags
	local bool	bSourceIsAlsoTarget;
	local bool	bMultiSourceIsAlsoTarget;
	local bool  bPlayedAttackResultNarrative;
			
	// good/bad determination
	local bool bGoodAbility;

	// LeapStrike Additions
	local X2Action_ForceJump ForceJumpAction;
	local X2Action_CameraFollowUnit CameraFollowAction;
	local PathingInputData PathInputData;
	local PathingResultData PathResultData;

	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.AbilityRef.ObjectID));
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	ShootingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter, part I. We split this into two parts since
	//in some situations the shooter can also be a target
	//****************************************************************************************
	ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);
	ShooterVisualizerInterface = X2VisualizerInterface(ShooterVisualizer);

	SourceData = InitData;
	SourceData.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceData.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	if (SourceData.StateObject_NewState == none)
		SourceData.StateObject_NewState = SourceData.StateObject_OldState;
	SourceData.VisualizeActor = ShooterVisualizer;	

	SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.ItemObject.ObjectID));
	if (SourceWeapon != None)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		AmmoTemplate = X2AmmoTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
	}

	bGoodAbility = XComGameState_Unit(SourceData.StateObject_NewState).IsFriendlyToLocalPlayer();

	if( Context.IsResultContextMiss() && AbilityTemplate.SourceMissSpeech != '' )
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildData, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.SourceMissSpeech, bGoodAbility ? eColor_Bad : eColor_Good);
	}
	else if( Context.IsResultContextHit() && AbilityTemplate.SourceHitSpeech != '' )
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildData, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.SourceHitSpeech, bGoodAbility ? eColor_Good : eColor_Bad);
	}

	if( !AbilityTemplate.bSkipFireAction || Context.InputContext.MovementPaths.Length > 0 )
	{
		ExitCoverAction = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceData, Context));
		ExitCoverAction.bSkipExitCoverVisualization = AbilityTemplate.bSkipExitCoverWhenFiring;

		// if this ability has a built in move, do it right before we do the fire action
		if(Context.InputContext.MovementPaths.Length > 0)
		{			
			// note that we skip the stop animation since we'll be doing our own stop with the end of move attack
			//class'X2VisualizerHelpers'.static.ParsePath(Context, SourceData, AbilityTemplate.bSkipMoveStop);

			//  add paths for other units moving with us (e.g. gremlins moving with a move+attack ability)
			//if (Context.InputContext.MovementPaths.Length > 1)
			//{
			//	for (TrackIndex = 1; TrackIndex < Context.InputContext.MovementPaths.Length; ++TrackIndex)
			//	{
			//		BuildData = InitData;
			//		BuildData.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.MovementPaths[TrackIndex].MovingUnitRef.ObjectID);
			//		BuildData.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.MovementPaths[TrackIndex].MovingUnitRef.ObjectID);
			//		MoveDelay = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(BuildData, Context));
			//		MoveDelay.Duration = class'X2Ability_DefaultAbilitySet'.default.TypicalMoveDelay;
			//		class'X2VisualizerHelpers'.static.ParsePath(Context, BuildData, AbilityTemplate.bSkipMoveStop);	
			//	}
			//}

			PathInputData = Context.InputContext.MovementPaths[0];
			PathResultData = Context.ResultContext.PathResults[0];

			CameraFollowAction = X2Action_CameraFollowUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_CameraFollowUnit', SourceData.VisualizeActor));						
			if(CameraFollowAction == none)
			{
				CameraFollowAction = X2Action_CameraFollowUnit(class'X2Action_CameraFollowUnit'.static.AddToVisualizationTree(SourceData, Context));
			}
			CameraFollowAction.AbilityToFrame = Context;
			CameraFollowAction.ParsePathSetParameters(PathInputData, PathResultData);
			CameraFollowAction.CameraTag = 'MovementFramingCamera';

			ForceJumpAction = X2Action_ForceJump(class'X2Action_ForceJump'.static.AddToVisualizationTree(SourceData, Context, false, none));
			ForceJumpAction.bSkipLandingAnimation = true;

			if( !AbilityTemplate.bSkipFireAction )
			{
				//MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(SourceData, Context, false, ForceJumpAction));
				//MoveTurnAction.m_vFacePoint = Context.InputContext.TargetLocations[0];
				//MoveTurnAction.ForceSetPawnRotation = true;

				AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(SourceData, Context, false, SourceData.LastActionAdded);
				
				//MoveEnd = X2Action_MoveEnd(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveEnd', SourceData.VisualizeActor));				
				//
				//if (MoveEnd != none)
				//{
				//	// add the fire action as a child of the node immediately prior to the move end
				//	AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(SourceData, Context, false, none, MoveEnd.ParentActions);
				//
				//	// reconnect the move end action as a child of the fire action, as a special end of move animation will be performed for this move + attack ability
				//	VisualizationMgr.DisconnectAction(MoveEnd);
				//	VisualizationMgr.ConnectAction(MoveEnd, VisualizationMgr.BuildVisTree, false, AddedAction);
				//}
				//else
				//{
				//	//See if this is a teleport. If so, don't perform exit cover visuals
				//	TeleportMoveAction = X2Action_MoveTeleport(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveTeleport', SourceData.VisualizeActor));
				//	if (TeleportMoveAction != none)
				//	{
				//		//Skip the FOW Reveal ( at the start of the path ). Let the fire take care of it ( end of the path )
				//		ExitCoverAction.bSkipFOWReveal = true;
				//	}
				//
				//	AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(SourceData, Context, false, SourceData.LastActionAdded);
				//}
			}
		}
		else
		{
			//If we were interrupted, insert a marker node for the interrupting visualization code to use. In the move path version above, it is expected for interrupts to be 
			//done during the move.
			if (Context.InterruptionStatus != eInterruptionStatus_None)
			{
				//Insert markers for the subsequent interrupt to insert into
				class'X2Action'.static.AddInterruptMarkerPair(SourceData, Context, ExitCoverAction);
			}

			if (!AbilityTemplate.bSkipFireAction)
			{
				// no move, just add the fire action. Parent is exit cover action if we have one
				AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(SourceData, Context, false, SourceData.LastActionAdded);
			}			
		}

		if( !AbilityTemplate.bSkipFireAction )
		{
			FireAction = AddedAction;

			class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(VisualizeGameState, false, 'AttackBegin', FireAction.ParentActions[0]);

			if( AbilityTemplate.AbilityToHitCalc != None )
			{
				X2Action_Fire(AddedAction).SetFireParameters(Context.IsResultContextHit());
			}
		}
	}

	//If there are effects added to the shooter, add the visualizer actions for them
	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, SourceData, Context.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));		
	}
	//****************************************************************************************

	//Configure the visualization track for the target(s). This functionality uses the context primarily
	//since the game state may not include state objects for misses.
	//****************************************************************************************	
	bSourceIsAlsoTarget = AbilityContext.PrimaryTarget.ObjectID == AbilityContext.SourceObject.ObjectID; //The shooter is the primary target
	if (AbilityTemplate.AbilityTargetEffects.Length > 0 &&			//There are effects to apply
		AbilityContext.PrimaryTarget.ObjectID > 0)				//There is a primary target
	{
		TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
		TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

		if( bSourceIsAlsoTarget )
		{
			BuildData = SourceData;
		}
		else
		{
			BuildData = InterruptTrack;        //  interrupt track will either be empty or filled out correctly
		}

		BuildData.VisualizeActor = TargetVisualizer;

		TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
		if( TargetStateObject != none )
		{
			History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.PrimaryTarget.ObjectID, 
															   BuildData.StateObject_OldState, BuildData.StateObject_NewState,
															   eReturnType_Reference,
															   VisualizeGameState.HistoryIndex);
			`assert(BuildData.StateObject_NewState == TargetStateObject);
		}
		else
		{
			//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
			//and show no change.
			BuildData.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
			BuildData.StateObject_NewState = BuildData.StateObject_OldState;
		}

		// if this is a melee attack, make sure the target is facing the location he will be melee'd from
		if(!AbilityTemplate.bSkipFireAction 
			&& !bSourceIsAlsoTarget 
			&& AbilityContext.MovementPaths.Length > 0
			&& AbilityContext.MovementPaths[0].MovementData.Length > 0
			&& XGUnit(TargetVisualizer) != none)
		{
			MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(BuildData, Context, false, ExitCoverAction));
			MoveTurnAction.m_vFacePoint = AbilityContext.MovementPaths[0].MovementData[AbilityContext.MovementPaths[0].MovementData.Length - 1].Position;
			MoveTurnAction.m_vFacePoint.Z = TargetVisualizerInterface.GetTargetingFocusLocation().Z;
			MoveTurnAction.UpdateAimTarget = true;

			// Jwats: Add a wait for ability effect so the idle state machine doesn't process!
			WaitForFireAction = X2Action_WaitForAnotherAction(class'X2Action_WaitForAnotherAction'.static.AddToVisualizationTree(BuildData, Context, false, MoveTurnAction));
			WaitForFireAction.ActionToWaitFor = FireAction;
		}

		//Pass in AddedAction (Fire Action) as the LastActionAdded if we have one. Important! As this is automatically used as the parent in the effect application sub functions below.
		if (AddedAction != none && AddedAction.IsA('X2Action_Fire'))
		{
			BuildData.LastActionAdded = AddedAction;
		}
		
		//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

			// Target effect visualization
			if( !Context.bSkipAdditionalVisualizationSteps )
			{
				AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);
			}

			// Source effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
		}

		//the following is used to handle Rupture flyover text
		TargetUnitState = XComGameState_Unit(BuildData.StateObject_OldState);
		if (TargetUnitState != none &&
			XComGameState_Unit(BuildData.StateObject_OldState).GetRupturedValue() == 0 &&
			XComGameState_Unit(BuildData.StateObject_NewState).GetRupturedValue() > 0)
		{
			//this is the frame that we realized we've been ruptured!
			class 'X2StatusEffects'.static.RuptureVisualization(VisualizeGameState, BuildData);
		}

		if (AbilityTemplate.bAllowAmmoEffects && AmmoTemplate != None)
		{
			for (EffectIndex = 0; EffectIndex < AmmoTemplate.TargetEffects.Length; ++EffectIndex)
			{
				ApplyResult = Context.FindTargetEffectApplyResult(AmmoTemplate.TargetEffects[EffectIndex]);
				AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);
				AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
			}
		}
		if (AbilityTemplate.bAllowBonusWeaponEffects && WeaponTemplate != none)
		{
			for (EffectIndex = 0; EffectIndex < WeaponTemplate.BonusWeaponEffects.Length; ++EffectIndex)
			{
				ApplyResult = Context.FindTargetEffectApplyResult(WeaponTemplate.BonusWeaponEffects[EffectIndex]);
				WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);
				WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
			}
		}

		if (Context.IsResultContextMiss() && (AbilityTemplate.LocMissMessage != "" || AbilityTemplate.TargetMissSpeech != ''))
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildData, Context, false, BuildData.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocMissMessage, AbilityTemplate.TargetMissSpeech, bGoodAbility ? eColor_Bad : eColor_Good);
		}
		else if( Context.IsResultContextHit() && (AbilityTemplate.LocHitMessage != "" || AbilityTemplate.TargetHitSpeech != '') )
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildData, Context, false, BuildData.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocHitMessage, AbilityTemplate.TargetHitSpeech, bGoodAbility ? eColor_Good : eColor_Bad);
		}

		if (!bPlayedAttackResultNarrative)
		{
			class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(VisualizeGameState, false, 'AttackResult');
			bPlayedAttackResultNarrative = true;
		}

		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildData);
		}

		if( bSourceIsAlsoTarget )
		{
			SourceData = BuildData;
		}
	}

	if (AbilityTemplate.bUseLaunchedGrenadeEffects)
	{
		MultiTargetEffects = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState)).LaunchedGrenadeEffects;
	}
	else if (AbilityTemplate.bUseThrownGrenadeEffects)
	{
		MultiTargetEffects = X2GrenadeTemplate(SourceWeapon.GetMyTemplate()).ThrownGrenadeEffects;
	}
	else
	{
		MultiTargetEffects = AbilityTemplate.AbilityMultiTargetEffects;
	}

	//  Apply effects to multi targets - don't show multi effects for burst fire as we just want the first time to visualize
	if( MultiTargetEffects.Length > 0 && AbilityContext.MultiTargets.Length > 0 && X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle) == none)
	{
		for( TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; ++TargetIndex )
		{	
			bMultiSourceIsAlsoTarget = false;
			if( AbilityContext.MultiTargets[TargetIndex].ObjectID == AbilityContext.SourceObject.ObjectID )
			{
				bMultiSourceIsAlsoTarget = true;
				bSourceIsAlsoTarget = bMultiSourceIsAlsoTarget;				
			}

			TargetVisualizer = History.GetVisualizer(AbilityContext.MultiTargets[TargetIndex].ObjectID);
			TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

			if( bMultiSourceIsAlsoTarget )
			{
				BuildData = SourceData;
			}
			else
			{
				BuildData = InitData;
			}
			BuildData.VisualizeActor = TargetVisualizer;

			// if the ability involved a fire action and we don't have already have a potential parent,
			// all the target visualizations should probably be parented to the fire action and not rely on the auto placement.
			if( (BuildData.LastActionAdded == none) && (FireAction != none) )
				BuildData.LastActionAdded = FireAction;

			TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
			if( TargetStateObject != none )
			{
				History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID, 
																	BuildData.StateObject_OldState, BuildData.StateObject_NewState,
																	eReturnType_Reference,
																	VisualizeGameState.HistoryIndex);
				`assert(BuildData.StateObject_NewState == TargetStateObject);
			}			
			else
			{
				//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
				//and show no change.
				BuildData.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
				BuildData.StateObject_NewState = BuildData.StateObject_OldState;
			}
		
			//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
			//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
			//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
			for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
			{
				ApplyResult = Context.FindMultiTargetEffectApplyResult(MultiTargetEffects[EffectIndex], TargetIndex);

				// Target effect visualization
				MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);

				// Source effect visualization
				MultiTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
			}			

			//the following is used to handle Rupture flyover text
			TargetUnitState = XComGameState_Unit(BuildData.StateObject_OldState);
			if (TargetUnitState != none && 
				XComGameState_Unit(BuildData.StateObject_OldState).GetRupturedValue() == 0 &&
				XComGameState_Unit(BuildData.StateObject_NewState).GetRupturedValue() > 0)
			{
				//this is the frame that we realized we've been ruptured!
				class 'X2StatusEffects'.static.RuptureVisualization(VisualizeGameState, BuildData);
			}
			
			if (!bPlayedAttackResultNarrative)
			{
				class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(VisualizeGameState, false, 'AttackResult');
				bPlayedAttackResultNarrative = true;
			}

			if( TargetVisualizerInterface != none )
			{
				//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
				TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildData);
			}

			if( bMultiSourceIsAlsoTarget )
			{
				SourceData = BuildData;
			}			
		}
	}
	//****************************************************************************************

	//Finish adding the shooter's track
	//****************************************************************************************
	if( !bSourceIsAlsoTarget && ShooterVisualizerInterface != none)
	{
		ShooterVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, SourceData);				
	}	

	//  Handle redirect visualization
	TypicalAbility_AddEffectRedirects(VisualizeGameState, SourceData);

	//****************************************************************************************

	//Configure the visualization tracks for the environment
	//****************************************************************************************

	if (ExitCoverAction != none)
	{
		ExitCoverAction.ShouldBreakWindowBeforeFiring( Context, WindowBreakTouchIndex );
	}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		BuildData = InitData;
		BuildData.VisualizeActor = none;
		BuildData.StateObject_NewState = EnvironmentDamageEvent;
		BuildData.StateObject_OldState = EnvironmentDamageEvent;

		// if this is the damage associated with the exit cover action, we need to force the parenting within the tree
		// otherwise LastActionAdded with be 'none' and actions will auto-parent.
		if ((ExitCoverAction != none) && (WindowBreakTouchIndex > -1))
		{
			if (EnvironmentDamageEvent.HitLocation == AbilityContext.ProjectileEvents[WindowBreakTouchIndex].HitLocation)
			{
				BuildData.LastActionAdded = ExitCoverAction;
			}
		}

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');		
		}

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');
		}

		for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');	
		}
	}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		BuildData = InitData;
		BuildData.VisualizeActor = none;
		BuildData.StateObject_NewState = WorldDataUpdate;
		BuildData.StateObject_OldState = WorldDataUpdate;

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');		
		}

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');
		}

		for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
		{
			MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');	
		}
	}
	//****************************************************************************************

	//Process any interactions with interactive objects
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		// Add any doors that need to listen for notification. 
		// Move logic is taken from MoveAbility_BuildVisualization, which only has special case handling for AI patrol movement ( which wouldn't happen here )
		if ( Context.InputContext.MovementPaths.Length > 0 || (InteractiveObject.IsDoor() && InteractiveObject.HasDestroyAnim()) ) //Is this a closed door?
		{
			BuildData = InitData;
			//Don't necessarily have a previous state, so just use the one we know about
			BuildData.StateObject_OldState = InteractiveObject;
			BuildData.StateObject_NewState = InteractiveObject;
			BuildData.VisualizeActor = History.GetVisualizer(InteractiveObject.ObjectID);

			class'X2Action_BreakInteractActor'.static.AddToVisualizationTree(BuildData, Context);
		}
	}
	
	//Add a join so that all hit reactions and other actions will complete before the visualization sequence moves on. In the case
	// of fire but no enter cover then we need to make sure to wait for the fire since it isn't a leaf node
	VisualizationMgr.GetAllLeafNodes(VisualizationMgr.BuildVisTree, LeafNodes);

	if (!AbilityTemplate.bSkipFireAction)
	{
		if (!AbilityTemplate.bSkipExitCoverWhenFiring)
		{			
			LeafNodes.AddItem(class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceData, Context, false, FireAction));
		}
		else
		{
			LeafNodes.AddItem(FireAction);
		}
	}
	
	if (VisualizationMgr.BuildVisTree.ChildActions.Length > 0)
	{
		JoinActions = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(SourceData, Context, false, none, LeafNodes));
		JoinActions.SetName("Join");
	}
}

static function X2AbilityTemplate ForceJump()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitProperty			UnitProperty;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_ForcePoints			ForcePointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceJump');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;
	Template.Hostility = eHostility_Movement;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///JediClassUI.UIPerk_jump";
	Template.bLimitTargetIcons = true;

	Template.TargetingMethod = class'X2TargetingMethod_ForceJump';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bMoveCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ForcePointCost = new class'X2AbilityCost_ForcePoints';
	ForcePointCost.ForceAmount = default.FORCE_JUMP_COST;
	ForcePointCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(ForcePointCost);

	Template.AbilityCooldown = none;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Path';

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	UnitProperty.ExcludeHostileToSource = true;
	UnitProperty.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitProperty);

	Template.AddShooterEffectExclusions();

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState; //ForceJump_BuildGameState;
	Template.BuildVisualizationFn = ForceJump_BuildVisualization;
	Template.ModifyNewContextFn = PrecomputedPathMovement_ModifyActivatedAbilityContext;
	Template.CinescriptCameraType = "";

	Template.AdditionalAbilities.AddItem('ForceJumpTraversal');

	return Template;
}

static simulated function PrecomputedPathMovement_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local PathPoint NextPoint, EmptyPoint;
	local PathingInputData InputData;
	local XComWorldData World;
	local TTile EmptyTile, NewTileLocation, EndTileLocation;
	local vector PathEndPosition;
	local array<TTile> PathTiles;
	local XComPrecomputedPath Path;
	local int Index;

	History = `XCOMHISTORY;
	World = `XWORLD;

	Path = XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).GetPrecomputedPath();
	
	AbilityContext = XComGameStateContext_Ability(Context);
	`assert(AbilityContext.InputContext.TargetLocations.Length > 0);
	
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	// Build the MovementData for the path
	// First posiiton is the current location
	InputData.MovementTiles.AddItem(UnitState.TileLocation);
	
	NextPoint.Position = World.GetPositionFromTileCoordinates(UnitState.TileLocation);
	NextPoint.Traversal = eTraversal_Teleport;
	NextPoint.PathTileIndex = 0;
	InputData.MovementData.AddItem(NextPoint);

	if(`PRES.GetTacticalHUD().GetTargetingMethod().GetPreAbilityPath(PathTiles))
	{
		EndTileLocation = PathTiles[PathTiles.Length - 1];
	}
	else if (AbilityContext.InputContext.AbilityTemplateName == 'ForceJump')
	{
		PathEndPosition = AbilityContext.InputContext.TargetLocations[0];
		EndTileLocation = World.GetTileCoordinatesFromPosition(PathEndPosition);
	}
	
	//PathEndPosition = Path.GetEndPosition();
	//PathEndTile = World.GetTileCoordinatesFromPosition(PathEndPosition);
	//EndTileLocation.Z = World.GetFloorTileZ(PathEndTile, true);

	if (EndTileLocation != EmptyTile)
	{
		for(Index = 0; Index < Path.iNumKeyframes; Index++)
		{
			NewTileLocation = World.GetTileCoordinatesFromPosition(Path.akKeyframes[Index].vLoc);

			if (NewTileLocation != EndTileLocation &&
				class'Helpers'.static.FindTileInList(NewTileLocation, InputData.MovementTiles) == INDEX_NONE)
			{
				NextPoint = EmptyPoint;
				NextPoint.Position = World.GetPositionFromTileCoordinates(NewTileLocation);
				NextPoint.Traversal = eTraversal_Teleport;
				NextPoint.PathTileIndex = InputData.MovementTiles.Length;
				InputData.MovementData.AddItem(NextPoint);
				InputData.MovementTiles.AddItem(NewTileLocation);

				`LOG(GetFuncName() @ NewTileLocation.X @ NewTileLocation.Y @ NewTileLocation.Z,, 'X2JediClassWOTC');
			}
		}

		NextPoint = EmptyPoint;
		NextPoint.Position = World.GetPositionFromTileCoordinates(EndTileLocation);
		NextPoint.Traversal = eTraversal_Landing;
		NextPoint.PathTileIndex = InputData.MovementTiles.Length;
		InputData.MovementData.AddItem(NextPoint);
		InputData.MovementTiles.AddItem(EndTileLocation);
		`LOG(GetFuncName() @ EndTileLocation.X @ EndTileLocation.Y @ EndTileLocation.Z,, 'X2JediClassWOTC');
	}

	//Now add the path to the input context
	InputData.MovingUnitRef = UnitState.GetReference();
	AbilityContext.InputContext.MovementPaths.Length = 0;
	AbilityContext.InputContext.MovementPaths.AddItem(InputData);
}

simulated function XComGameState ForceJump_BuildGameState_UNUSED(XComGameStateContext Context)
{
	local XComWorldData WorldData;
	local XComGameState NewGameState;
	local XComGameState_Unit MovingUnitState;
	local XComGameState_Ability AbilityState;	
	local XComGameStateContext_Ability AbilityContext;
	local X2AbilityTemplate AbilityTemplate;
	
	local TTile UnitTile;
	local TTile PrevUnitTile;
	local XComGameStateHistory History;
	local Vector TilePos, PrevTilePos, TilePosDiff;

	WorldData = `XWORLD;
	History = `XCOMHISTORY;

	//Build the new game state frame, and unit state object for the moving unit
	NewGameState = History.CreateNewGameState(true, Context);	

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());	
	AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', AbilityContext.InputContext.AbilityRef.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	// create a new state for the grapple unit
	MovingUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));

	// get our tile destination
	`assert(AbilityContext.InputContext.TargetLocations.Length == 1);
	TilePos = AbilityContext.InputContext.TargetLocations[0];
	UnitTile = WorldData.GetTileCoordinatesFromPosition(TilePos);

	//Set the unit's new location
	PrevUnitTile = MovingUnitState.TileLocation;
	MovingUnitState.SetVisibilityLocation( UnitTile );

	if (UnitTile != PrevUnitTile)
	{
		TilePos = `XWORLD.GetPositionFromTileCoordinates(UnitTile);
		PrevTilePos = `XWORLD.GetPositionFromTileCoordinates(PrevUnitTile);
		TilePosDiff = TilePos - PrevTilePos;
		TilePosDiff.Z = 0;

		MovingUnitState.MoveOrientation = Rotator(TilePosDiff);
	}

	AbilityContext.ResultContext.bPathCausesDestruction = AbilityContext.ResultContext.bPathCausesDestruction || MoveAbility_StepCausesDestruction(MovingUnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
	MoveAbility_AddTileStateObjects(NewGameState, MovingUnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
	MoveAbility_AddNewlySeenUnitStateObjects(NewGameState, MovingUnitState, AbilityContext.InputContext, 0);

	//Apply the cost of the ability
	AbilityTemplate.ApplyCost(AbilityContext, AbilityState, MovingUnitState, none, NewGameState);

	`XEVENTMGR.TriggerEvent( 'ObjectMoved', MovingUnitState, MovingUnitState, NewGameState );
	`XEVENTMGR.TriggerEvent( 'UnitMoveFinished', MovingUnitState, MovingUnitState, NewGameState );

	//Return the game state we have created
	return NewGameState;	
}

simulated function ForceJump_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local StateObjectReference MovingUnitRef;	
	local VisualizationActionMetadata ActionMetadata;
	local VisualizationActionMetadata EmptyTrack;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_EnvironmentDamage EnvironmentDamage;
	local X2Action_PlaySoundAndFlyOver CharSpeechAction;
	local X2Action_ForceJump ForceJumpAction;
	//local X2Action_ExitCover ExitCoverAction;
	local X2Action_RevealArea RevealAreaAction;
	local X2Action_UpdateFOW FOWUpdateAction;
	local XComGameStateVisualizationMgr VisualizationMgr;
	local PathingInputData PathInputData;
	local PathingResultData PathResultData;
	local X2Action_CameraFollowUnit CameraFollowAction;
	
	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	MovingUnitRef = AbilityContext.InputContext.SourceObject;
	
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(MovingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(MovingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(MovingUnitRef.ObjectID);

	CharSpeechAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	CharSpeechAction.SetSoundAndFlyOverParameters(None, "", 'GrapplingHook', eColor_Good);

	RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	RevealAreaAction.TargetLocation = AbilityContext.InputContext.TargetLocations[0];
	RevealAreaAction.AssociatedObjectID = MovingUnitRef.ObjectID;
	RevealAreaAction.ScanningRadius = class'XComWorldData'.const.WORLD_StepSize * 4;
	RevealAreaAction.bDestroyViewer = false;

	FOWUpdateAction = X2Action_UpdateFOW(class'X2Action_UpdateFOW'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	FOWUpdateAction.BeginUpdate = true;

	X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	//ExitCoverAction.bUsePreviousGameState = true;

	PathInputData = AbilityContext.InputContext.MovementPaths[0];
	PathResultData = AbilityContext.ResultContext.PathResults[0];

	CameraFollowAction = X2Action_CameraFollowUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_CameraFollowUnit', ActionMetadata.VisualizeActor));
	if(CameraFollowAction == none)
	{
		CameraFollowAction = X2Action_CameraFollowUnit(class'X2Action_CameraFollowUnit'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	}
	CameraFollowAction.AbilityToFrame = AbilityContext;
	CameraFollowAction.ParsePathSetParameters(PathInputData, PathResultData);
	CameraFollowAction.CameraTag = 'MovementFramingCamera';

	ForceJumpAction = X2Action_ForceJump(class'X2Action_ForceJump'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	ForceJumpAction.DesiredLocation = AbilityContext.InputContext.TargetLocations[0];

	// destroy any windows we flew through
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamage)
	{
		ActionMetadata = EmptyTrack;

		//Don't necessarily have a previous state, so just use the one we know about
		ActionMetadata.StateObject_OldState = EnvironmentDamage;
		ActionMetadata.StateObject_NewState = EnvironmentDamage;
		ActionMetadata.VisualizeActor = History.GetVisualizer(EnvironmentDamage.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ForceJumpAction);
		class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());
	}

	FOWUpdateAction = X2Action_UpdateFOW(class'X2Action_UpdateFOW'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	FOWUpdateAction.EndUpdate = true;

	RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	RevealAreaAction.AssociatedObjectID = MovingUnitRef.ObjectID;
	RevealAreaAction.bDestroyViewer = true;
}

static function X2AbilityTemplate ForcePowerPool()
{
	local X2AbilityTemplate					Template;
	local X2Effect_JediForcePool_ByRank		ForcePoolEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForcePowerPool');

	Template.IconImage = "img:///JediClassUI.UIPerk_Force";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ForcePoolEffect = new class'X2Effect_JediForcePool_ByRank';
	ForcePoolEffect.BuildPersistentEffect(1);
	ForcePoolEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, "img:///UILibrary_PerkIcons.UIPerk_standard", false,, Template.AbilitySourceName);
	Template.AddTargetEffect(ForcePoolEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.bCrossClassEligible = false;
	Template.AdditionalAbilities.AddItem('ForcePoolBonusDamage');

	return Template;
}

static function X2AbilityTemplate Holocron(name TemplateName, int PoolDivisor)
{
	local X2AbilityTemplate					Template;
	local X2Effect_JediForcePool_Holocron	ForcePoolEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.IconImage = "img:///JediClassUI.UIPerk_Holocron";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ForcePoolEffect = new class'X2Effect_JediForcePool_Holocron';
	ForcePoolEffect.BuildPersistentEffect(1);
	ForcePoolEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, "img:///UILibrary_PerkIcons.UIPerk_standard", false,, Template.AbilitySourceName);
	ForcePoolEffect.PoolDivisor = PoolDivisor;
	Template.AddTargetEffect(ForcePoolEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.bCrossClassEligible = false;

	return Template;
}

static function X2AbilityTemplate ForceMeditate()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	//local X2AbilityCost_Charges				ChargeCost;
	//local X2AbilityCharges					Charges;
	local X2Effect_ForceMeditate			MeditateEffect;
	local X2Effect_PersistentStatChange		NoDodgeEffect;
	local X2Effect_RemoveEffects			RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceMeditate');

	Template.IconImage = "img:///JediClassUI.UIPerk_meditation";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	//Charges = new class'X2AbilityCharges';
	//Charges.InitialCharges = default.FORCE_MEDITATE_CHARGES;
	//Template.AbilityCharges = Charges;
	//
	//ChargeCost = new class'X2AbilityCost_Charges';
	//ChargeCost.NumCharges = 1;
	//Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_MEDITATE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityTargetStyle = default.SelfTarget;

	MeditateEffect = new class'X2Effect_ForceMeditate';
	MeditateEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	MeditateEffect.RegenAmount = default.FORCE_MEDITATE_REGEN_PERCENT;
	Template.AddTargetEffect(MeditateEffect);

	NoDodgeEffect = new class'X2Effect_PersistentStatChange';
	NoDodgeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	NoDodgeEffect.AddPersistentStatChange(eStat_Dodge, 0, MODOP_PostMultiplication);       //  no dodge for you!
	Template.AddTargetEffect(NoDodgeEffect);

	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffect.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DazedName);
	RemoveEffect.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.ShatteredName);
	Template.AddTargetEffect(RemoveEffect);

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = ForceMeditate_BuildVisualization;
	//Template.BuildAffectedVisualizationSyncFn = ForceMeditate_BuildVisualizationSync;

	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

simulated function ForceMeditate_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata			EmptyTrack;
	local VisualizationActionMetadata			ActionMetadata;


	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	if (Context.InterruptionStatus == eInterruptionStatus_Interrupt)
	{
		// Only visualize InterruptionStatus eInterruptionStatus_None or eInterruptionStatus_Resume,
		// if eInterruptionStatus_Interrupt then the jedi was killed (or removed)
		return;
	}

	InteractingUnitRef = Context.InputContext.SourceObject;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_ForceMeditate'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	ForceMeditateAnimationVisualization(ActionMetadata, Context);
}

static function ForceMeditate_BuildVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	//class'X2Action_ForceMeditate'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	//ForceMeditateAnimationVisualization(ActionMetadata, Context);
}

static simulated function ForceMeditateAnimationVisualization(out VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	local X2Action_PersistentEffect		PersistentEffectAction;

	PersistentEffectAction = X2Action_PersistentEffect(class'X2Action_PersistentEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PersistentEffectAction.IdleAnimName = 'NO_ForceMeditationLoop';
}

static function X2AbilityTemplate ForceDrain()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	LOCAL X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local X2Condition_UnitProperty			CivilianProperty;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local X2AbilityCharges					Charges;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceDrain');

	Template.IconImage = "img:///JediClassUI.UIPerk_ForceDrain";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_DRAIN_COOLDOWN;
	Cooldown.bDoNotApplyOnHit = true;
	Template.AbilityCooldown = Cooldown;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.FORCE_DRAIN_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.FORCE_DRAIN_COST;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = 1;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = default.FORCE_DRAIN_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true; // skip the cover checks, the squad viewer will handle this once selected
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_DRAIN_BASEDAMAGE;
	CivilianProperty = new class'X2Condition_UnitProperty';
	CivilianProperty.ExcludeNonCivilian = false;
	CivilianProperty.ExcludeHostileToSource = false;
	CivilianProperty.ExcludeFriendlyToSource = false;
	DamageEffect.TargetConditions.AddItem(CivilianProperty);
	Template.AddMultiTargetEffect(DamageEffect);

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';

	Template.bShowActivation = true;
	Template.bSkipPerkActivationActions = true;

	Template.CustomFireAnim = 'HL_GainingFocus';
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.PostActivationEvents.AddItem(default.ForceDrainEventName);
	Template.AdditionalAbilities.AddItem('ForceDrainTriggered');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate ForceDrainTriggered()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    EventListener;
	local X2Condition_UnitProperty          ShooterProperty;
	local X2Effect_SoulSteal                StealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceDrainTriggered');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.IconImage = "img:///JediClassUI.UIPerk_ForceDrain";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	ShooterProperty = new class'X2Condition_UnitProperty';
	ShooterProperty.ExcludeAlive = false;
	ShooterProperty.ExcludeDead = true;
	ShooterProperty.ExcludeFriendlyToSource = false;
	ShooterProperty.ExcludeHostileToSource = true;
	ShooterProperty.ExcludeFullHealth = true;
	Template.AbilityShooterConditions.AddItem(ShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'X2Ability_JediClassAbilities'.static.ForceDrainListener;
	EventListener.ListenerData.EventID = default.ForceDrainEventName;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	StealEffect = new class'X2Effect_SoulSteal';
	StealEffect.UnitValueToRead = default.ForceDrainUnitValue;
	Template.AddShooterEffect(StealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'ADD_NO_Psi_CastAdditive';
	Template.ActionFireClass = class'X2Action_Fire_AdditiveAnim';

	return Template;
}

static function EventListenerReturn ForceDrainListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState NewGameState;
	local XComGameState_Unit NewSourceUnit, TargetUnit, SourceUnit;
	local int DamageDealt, DmgIdx;
	local float StolenHP;
	local StateObjectReference TargetRef;
	local StateObjectReference ForceDrainTriggeredRef;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	// These are Musashi's method of obtaining these objects, but they are time-consuming and the objects are already passed to the function. See below.
	//AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	//SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	AbilityState = XComGameState_Ability(EventData);
	SourceUnit = XComGameState_Unit(EventSource);

	ForceDrainTriggeredRef = SourceUnit.FindAbility('ForceDrainTriggered');
	if (ForceDrainTriggeredRef.ObjectID == 0)
		return ELR_NoInterrupt;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ForceDrainTriggeredRef.ObjectID));
	if (AbilityState == None)
		return ELR_NoInterrupt;

	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		foreach AbilityContext.InputContext.MultiTargets(TargetRef)
		{
			TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(TargetRef.ObjectID));

			if (TargetUnit != none)
			{
				DamageDealt = 0;
				for (DmgIdx = 0; DmgIdx < TargetUnit.DamageResults.Length; ++DmgIdx)
				{
					if (TargetUnit.DamageResults[DmgIdx].Context == AbilityContext)
					{
						DamageDealt += TargetUnit.DamageResults[DmgIdx].DamageAmount;
					}
				}
				if (DamageDealt > 0)
				{
					//`LOG("TargetUnit" @ TargetUnit.GetMyTemplateName() @ DamageDealt,, 'X2JediClassWOTC');
					StolenHP += Round(float(DamageDealt) * 1);
				}
			}
		}

		if (StolenHP > 0)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
			NewSourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
			if (NewSourceUnit != none)
			{
				//  Submit a game state that saves the Force Drained value on the source unit
				NewSourceUnit = XComGameState_Unit(NewGameState.CreateStateObject(NewSourceUnit.Class, NewSourceUnit.ObjectID));
				NewSourceUnit.SetUnitFloatValue(class'X2Ability_JediClassAbilities'.default.ForceDrainUnitValue, StolenHP, eCleanup_BeginTurn);
				NewGameState.AddStateObject(NewSourceUnit);
				`TACTICALRULES.SubmitGameState(NewGameState);
				//  Activate this ability to steal the HP
				//`LOG("ForceDrainListener AbilityTriggerAgainstSingleTarget" @ AbilityState.ObjectID,, 'X2JediClassWOTC');
				TargetRef.ObjectID = NewSourceUnit.ObjectID;
				AbilityState.AbilityTriggerAgainstSingleTarget(TargetRef, false);
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate ForceProtection()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Persistent           PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceProtection');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fortress";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = new class'X2Effect_Fortress';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	Template.bSkipFireAction = true;

	Template.bSkipPerkActivationActions = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate ForceSense()
{
	local X2AbilityTemplate						Template;
	Template = PurePassive('ForceSense', "img:///JediClassUI.UIPerk_ForceSense", true);
	Template.AdditionalAbilities.AddItem('ForceSenseTrigger');
	Template.AdditionalAbilities.AddItem('ForceSenseSpawnTrigger');

	return Template;
}

static function X2AbilityTemplate ForceSenseTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_RevealUnit				TrackingEffect;
	local X2Condition_UnitProperty			TargetProperty;
	local X2Condition_UnitEffects			EffectsCondition;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceSenseTrigger');

	Template.IconImage = "img:///JediClassUI.UIPerk_ForceSense";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsNotPlayerControlled');
	Template.AbilityShooterConditions.AddItem(EffectsCondition);

	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.FORCE_SENSE_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(TargetProperty);

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect(class'X2Effect_Burrowed'.default.EffectName, 'AA_UnitIsBurrowed');
	Template.AbilityMultiTargetConditions.AddItem(EffectsCondition);

	TrackingEffect = new class'X2Effect_RevealUnit';
	TrackingEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Template.AddMultiTargetEffect(TrackingEffect);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'PlayerTurnBegun';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Player;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;
	Template.bShowActivation = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// This triggers whenever a unit is spawned within tracking radius. The most likely
// reason for this to happen is a Faceless transforming due to tracking being applied.
// The newly spawned Faceless unit won't have the tracking effect when this happens,
// so we apply it here.
static function X2AbilityTemplate ForceSenseSpawnTrigger()
{
	local X2AbilityTemplate					Template;
	local X2Effect_RevealUnit				TrackingEffect;
	local X2Condition_UnitProperty			TargetProperty;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceSenseSpawnTrigger');

	Template.IconImage = "img:///JediClassUI.UIPerk_ForceSense";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = default.FORCE_SENSE_RADIUS * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	TrackingEffect = new class'X2Effect_RevealUnit';
	TrackingEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(TrackingEffect);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitSpawned';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


static function X2AbilityTemplate BattleMeditation()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_Persistent					BattleMeditationEffect;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCost_ForcePoints				FPCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BattleMeditation');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BATTLE_MEDITATION_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.BATTLE_MEDITATION_COST;
	FPCost.ConsumeAllForce = true;
	Template.AbilityCosts.AddItem(FPCost);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///JediClassUI.UIPerk_BattleMeditation";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// A persistent effect for the effects code to attach a duration to
	BattleMeditationEffect = new class'X2Effect_Persistent';
	BattleMeditationEffect.EffectName = 'BattleMeditation';
	BattleMeditationEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(BattleMeditationEffect);

	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'HL_GainingFocus';
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.bShowActivation = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate EnergyAbsorption()
{
	local X2AbilityTemplate         Template;

	Template = PurePassive('EnergyAbsorption', "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield");
	Template.AddTargetEffect(EnergyShieldEffect(default.ENERGY_ABSORPTION_SHIELD_POINTS));

	return Template;
}

static function X2AbilityTemplate ForceFear()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local array<name>						SkipExclusions;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceFear');

	// Icon Properties
	Template.IconImage = "img:///JediClassUI.UIPerk_ForceFear";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.ConcealmentRule = eConceal_Always;
	Template.DisplayTargetHitChance = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_FEAR_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.FORCE_FEAR_CONE_LENGTH_TILES * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = false;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.ConeEndDiameter = default.FORCE_FEAR_CONE_END_DIAMETER_TILES  * class'XComWorldData'.const.WORLD_StepSize; // 32
	ConeMultiTarget.ConeLength = default.FORCE_FEAR_CONE_LENGTH_TILES  * class'XComWorldData'.const.WORLD_StepSize; // 60
	ConeMultiTarget.fTargetRadius = Sqrt( Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength) ) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.FORCE_FEAR_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_Cone';
	Template.bOverrideAim = true;
	//Template.bUseSourceLocationZToAim = true;

	Template.AddMultiTargetEffect(PanickedStatusEffect(default.FORCE_FEAR_TURNS));

	Template.AddMultiTargetEffect(new class'X2Effect_GrantDarkSidePoint');

	// MAKE IT LIVE!
	//Template.bSkipFireAction = true;

	Template.CustomFireAnim = 'FF_MindTricksA';
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.bShowActivation = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate ForceSpeed()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_GrantActionPoints			PointEffect;
	local X2Effect_Persistent					ActionPointPersistEffect;
	local X2Effect_ForceSpeed					ForceSpeedEffect;
	local X2AbilityCost_ForcePoints				FPCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceSpeed');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_SPEED_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.FORCE_SPEED_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///JediClassUI.UIPerk_ForceSpeed";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	PointEffect = new class'X2Effect_GrantActionPoints';
	PointEffect.NumActionPoints = 1;
	PointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(PointEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = 'ForceSpeedPerk';
	ActionPointPersistEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd );
	Template.AddTargetEffect(ActionPointPersistEffect);

	ForceSpeedEffect = new class'X2Effect_ForceSpeed';
	ForceSpeedEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	ForceSpeedEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, , , Template.AbilitySourceName);
	Template.AddTargetEffect(ForceSpeedEffect);

	Template.CustomFireAnim = 'HL_GainingFocus';
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate MindControl()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	local X2Effect_MindControl          MindControlEffect;
	local X2Effect_StunRecover			StunRecoverEffect;
	local X2Condition_UnitEffects       EffectCondition;
	local X2AbilityCharges              Charges;
	local X2AbilityCost_Charges         ChargeCost;
	local X2AbilityCost_ForcePoints		FPCost;
	local X2AbilityCooldown             Cooldown;
	local X2Condition_UnitImmunities	UnitImmunityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MindControl');

	Template.IconImage = "img:///JediClassUI.UIPerk_MindControl";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.MIND_CONTROL_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.MIND_CONTROL_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.bOnlyOnHit = true;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MIND_CONTROL_COOLDOWN;
	Cooldown.bDoNotApplyOnHit = true;
	Template.AbilityCooldown = Cooldown;
	
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = true;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	//  mind control target
	MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(1, false, true);
	Template.AddTargetEffect(MindControlEffect);

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	Template.AddTargetEffect(StunRecoverEffect);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
	Template.AddTargetEffect(new class'X2Effect_GrantDarkSidePoint');

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ActivationSpeech = 'Domination';
	Template.SourceMissSpeech = 'SoldierFailsControl';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_ForceA';
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate ForceHeal()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_UnitStatCheck			UnitStatCheckCondition;
	local X2Effect_ApplyMedikitHeal			MedikitHeal;
	local X2AbilityCharges					ForceHealCharges;
	local X2Effect_Revive					ReviveEffect;
	local array<name>						SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceHeal');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;	
	Template.AbilityCosts.AddItem(ActionPointCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.FORCE_HEAL_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_HEAL_COOLDOWN;
	Cooldown.bDoNotApplyOnHit = true;
	Template.AbilityCooldown = Cooldown;

	ForceHealCharges = new class'X2AbilityCharges';
	ForceHealCharges.InitialCharges = default.FORCE_HEAL_CHARGES;
	Template.AbilityCharges = ForceHealCharges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	//ChargeCost.SharedAbilityCharges.AddItem('GremlinStabilize');
	Template.AbilityCosts.AddItem(ChargeCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false; //Hack: See following comment.
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeFullHealth = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeTurret = true;
	//UnitPropertyCondition.IsBleedingOut = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	//UnitEffectsCondition = new class'X2Condition_UnitEffects';
	//UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	//Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	ReviveEffect = new class'X2Effect_Revive';
	Template.AddTargetEffect(ReviveEffect);

	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = default.FORCE_HEAL_PERUSEHP;
	Template.AddTargetEffect(MedikitHeal);

	Template.AddTargetEffect(RemoveAllEffectsByDamageType());
	Template.AddTargetEffect(RemoveAdditionalEffects());
	
	Template.AddTargetEffect(new class'X2Effect_GrantLightSidePoint');

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.IconImage = "img:///JediClassUI.UIPerk_ForceHeal";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_ForceA';
	//Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2Effect_RemoveEffects RemoveAdditionalEffects()
{
	local X2Effect_RemoveEffects RemoveEffects;
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	return RemoveEffects;
}

static function X2Effect_RemoveEffectsByDamageType RemoveAllEffectsByDamageType()
{
	local X2Effect_RemoveEffectsByDamageType RemoveEffectTypes;
	local name HealType;

	RemoveEffectTypes = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffectTypes.DamageTypesToRemove.AddItem(HealType);
	}
	return RemoveEffectTypes;
}

static function X2AbilityTemplate MindTricks()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local array<name>						SkipExclusions;
	local X2Effect_MindTricks				MindTricksEffect;
	local X2Effect_RemoveActionPoints		RemoveActionPointsEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MindTricks');

	// Icon Properties
	Template.IconImage = "img:///JediClassUI.UIPerk_MindTricks";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.ConcealmentRule = eConceal_Always;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MIND_TRICKS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can't target dead; Can't target friendlies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.MIND_TRICKS_RANGE;
	Template.AbilityTargetStyle = CursorTarget;
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.MIND_TRICKS_RADIUS;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.MIND_TRICKS_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';
	Template.bOverrideAim = true;
	//Template.bUseSourceLocationZToAim = true;

	MindTricksEffect = new class'X2Effect_MindTricks';
	MindTricksEffect.BuildPersistentEffect(default.MIND_TRICKS_TURNS, false, true,, eGameRule_PlayerTurnBegin);
	MindTricksEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	Template.AddMultiTargetEffect(MindTricksEffect);

	RemoveActionPointsEffect = new class'X2Effect_RemoveActionPoints';
	RemoveActionPointsEffect.BuildPersistentEffect(default.MIND_TRICKS_TURNS, false, true,, eGameRule_PlayerTurnBegin);
	Template.AddMultiTargetEffect(RemoveActionPointsEffect);

	// MAKE IT LIVE!
	//Template.bSkipFireAction = true;

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_MindTricksA';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate ForceJumpTraversal()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger						Trigger;
	local X2Effect_PersistentTraversalChange	JumpEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceJumpTraversal');
	Template.IconImage = "img:///JediClassUI.UIPerk_jump";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	JumpEffect = new class'X2Effect_PersistentTraversalChange';
	JumpEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	//JumpEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false,, Template.AbilitySourceName);
	JumpEffect.AddTraversalChange(eTraversal_JumpUp, true);
	Template.AddTargetEffect(JumpEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Template.bShowActivation = false;
	Template.bCrossClassEligible = false;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');
	Template.AdditionalAbilities.AddItem('ForceAlignmentModifier');

	return Template;
}

static function X2AbilityTemplate ForceWind()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local array<name>						SkipExclusions;
	local X2Effect_ForcePush				KnockBackEffect;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2Effect_RemoveOverwatch			RemoveOverwatchEffect;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2AbilityCooldown					Cooldown;


	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceWind');

	// Icon Properties
	Template.IconImage = "img:///JediClassUI.UIPerk_ForcePushMulti";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_WIND_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.FORCE_WIND_CONE_LENGTH_TILES * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetStyle = CursorTarget;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = false;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.ConeEndDiameter = default.FORCE_WIND_CONE_END_DIAMETER_TILES  * class'XComWorldData'.const.WORLD_StepSize; // 32
	ConeMultiTarget.ConeLength = default.FORCE_WIND_CONE_LENGTH_TILES  * class'XComWorldData'.const.WORLD_StepSize; // 60
	ConeMultiTarget.fTargetRadius = Sqrt( Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength) ) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.FORCE_WIND_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EnvironmentalDamageAmount = default.FORCE_WIND_ENVIRONMENTAL_DAMAGE;
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.bApplyOnMiss = true;
	DamageEffect.EffectDamageValue = default.FORCE_WIND_BASEDAMAGE;
	DamageEffect.EffectDamageValue.DamageType = 'HarborWave';
	Template.AddMultiTargetEffect(DamageEffect);

	KnockBackEffect = new class'X2Effect_ForcePush';
	KnockBackEffect.KnockbackDistance = default.FORCE_WIND_KNOCKBACK_DISTANCE;
	KnockBackEffect.bKnockbackDestroysNonFragile = true;
	KnockBackEffect.ForcePushAnimSequence = '';
	Template.AddMultiTargetEffect(KnockBackEffect);

	Template.AddMultiTargetEffect(DisorientEffect());

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('Suppression');
	RemoveEffects.EffectNamesToRemove.AddItem('AreaSuppression');
	RemoveEffects.bCheckSource = true;
	Template.AddMultiTargetEffect(RemoveEffects);

	RemoveOverwatchEffect = new class'X2Effect_RemoveOverwatch';
	Template.AddMultiTargetEffect(RemoveOverwatchEffect);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.bSkipFireAction = false;
	Template.bShowActivation = true;
	Template.ActionFireClass = class'X2Action_Fire_Wave';
	Template.CustomFireAnim = 'FF_ForceWindA';
	//Template.AssociatedPlayTiming = SPT_AfterParallel;

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_Cone';
	Template.bOverrideAim = true;
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate ForcePush()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local array<name>						SkipExclusions;
	local X2Effect_ForcePush				KnockBackEffect;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2Effect_RemoveOverwatch			RemoveOverwatchEffect;
	local X2AbilityCooldown					Cooldown;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForcePush');

	// Icon Properties
	Template.IconImage = "img:///JediClassUI.UIPerk_ForcePushSingle";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_PUSH_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.FORCE_PUSH_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EnvironmentalDamageAmount = 20;
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_PUSH_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	KnockBackEffect = new class'X2Effect_ForcePush';
	KnockBackEffect.KnockbackDistance = default.FORCE_PUSH_KNOCKBACK_DISTANCE;
	KnockBackEffect.bKnockbackDestroysNonFragile = true;
	KnockBackEffect.ForcePushAnimSequence = '';
	Template.AddTargetEffect(KnockBackEffect);

	Template.AddTargetEffect(DisorientEffect());

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('Suppression');
	RemoveEffects.EffectNamesToRemove.AddItem('AreaSuppression');
	RemoveEffects.bCheckSource = true;
	Template.AddTargetEffect(RemoveEffects);

	RemoveOverwatchEffect = new class'X2Effect_RemoveOverwatch';
	Template.AddTargetEffect(RemoveOverwatchEffect);

	//Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';
	Template.AbilityToHitCalc = default.DeadEye;

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bOverrideAim = true;
	//Template.bUseSourceLocationZToAim = true;
	
	//Template.AssociatedPlayTiming = SPT_AfterParallel;

	// MAKE IT LIVE!
	Template.bSkipFireAction = false;
	Template.bShowActivation = true;
	Template.ActionFireClass = class'X2Action_Fire_Wave';
	Template.CustomFireAnim = 'FF_ForcePushA';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate ForceChoke()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_AdditionalAnimSets		TargetAnimSet;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceChoke');

	// Icon Properties
	Template.IconImage = "img:///JediClassUI.UIPerk_ForceChoke";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_LIGHTNING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.FORCE_LIGHTNING_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_CHOKE_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	TargetAnimSet = new class'X2Effect_AdditionalAnimSets';
	TargetAnimSet.AddAnimSetWithPath("JediClassAbilities.Anims.AS_ForceChokeTarget");
	TargetAnimSet.BuildPersistentEffect(1, false, false, false);
	Template.AddTargetEffect(TargetAnimSet);

	Template.SourceMissSpeech = 'SwordMiss';

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = ForceChoke_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

simulated function ForceChoke_BuildVisualization(XComGameState VisualizeGameState/*, out array<VisualizationTrack> OutVisualizationTracks*/)
{
	local XComGameStateHistory					History;
	local XComGameStateContext_Ability			Context;
	local StateObjectReference					InteractingUnitRef, TargetUnitRef;
	local VisualizationActionMetadata			EmptyTrack, ActionMetadata;
	local X2Action_PlaySoundAndFlyOver			SoundAndFlyOver;
	local XComGameState_Ability					AbilityState;
	local X2AbilityTemplate						AbilityTemplate;
	local X2VisualizerInterface					TargetVisualizerInterface;
	local X2Action_PlayAnimation				PlayAnimationAction;
	local X2Action_ExitCover					ExitCoverAction;
	local X2Action_Fire_ForceChoke				FireAction;
	local int i;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;
	TargetUnitRef = Context.InputContext.PrimaryTarget;
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;

	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	ExitCoverAction = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));

	if(Context.IsResultContextHit())
	{
		if(AbilityTemplate.SourceHitSpeech != '')
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.SourceHitSpeech, eColor_Bad);
		}

		FireAction = X2Action_Fire_ForceChoke(class'X2Action_Fire_ForceChoke'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	}
	else
	{
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		PlayAnimationAction.Params.AnimName = 'FF_ForceChokeA';

		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "Force Choke failed", '', eColor_Bad);

	}

	//Configure the visualization track for the target
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(TargetUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(TargetUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(TargetUnitRef.ObjectID);

	TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	
	//  This is sort of a super hack, that allows DLC/mods to visualize extra stuff in here.
	//  Visualize effects from index 1 as index 0 should be the base game damage effect.
	for (i = 1; i < AbilityTemplate.AbilityTargetEffects.Length; ++i)
	{
		// Parenting the X2Effect_AdditionalAnimSets.AddX2ActionsForVisualization to the parent of exit cover
		// so it runs before the fire action
		ActionMetadata.LastActionAdded = ExitCoverAction.ParentActions[0].ParentActions[0];
		AbilityTemplate.AbilityTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[i]));
	}

	// the rest is parented to the fire action
	ActionMetadata.LastActionAdded = FireAction;

	if(Context.IsResultContextHit())
	{
		if (AbilityTemplate.LocHitMessage != "" || AbilityTemplate.TargetHitSpeech != '')
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocHitMessage, AbilityTemplate.TargetHitSpeech, eColor_Good);
		}

		//`LOG(AbilityTemplate.AbilityTargetEffects[0].Name @ Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[0]),, 'X2JediClassWOTC');
		
		// add the damage action after WaitForAbilityEffect
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		AbilityTemplate.AbilityTargetEffects[0].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[0]));

		//Visualize the target's death normally.
		if (TargetVisualizerInterface != none)
		{
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}
	else
	{
		if( AbilityTemplate.LocMissMessage != "" || AbilityTemplate.TargetMissSpeech != '' )
		{
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocMissMessage, AbilityTemplate.TargetMissSpeech, eColor_Bad);
		}
	}

	//OutVisualizationTracks.AddItem(BuildTrack);
}


static function X2AbilityTemplate ForceLightning()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local array<name>                       SkipExclusions;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceLightning');

	// Icon Properties
	Template.IconImage = "img:///JediClassUI.UIPerk_ForceLightning";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_LIGHTNING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = false;
	UnitPropertyCondition.ExcludeCosmetic = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.FORCE_LIGHTNING_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);

	//Stun Effect
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_LIGHTNING_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	Template.AddTargetEffect(StunEffect(default.FORCE_LIGHTNING_STUNNED_ACTIONS, default.FORCE_LIGHTNING_STUN_CHANCE, false));

	// Hit Calculation (Different weapons now have different calculations for range)
	//ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	//ToHitCalc.bGuaranteedHit = true;
	//ToHitCalc.bMeleeAttack = true;
	//ToHitCalc.bAllowCrit = false;
	//Template.AbilityToHitCalc = ToHitCalc;
	//Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	//Template.ActionFireClass = class'X2Action_Fire_ChainLightning';
	Template.CustomFireAnim = 'HL_ForceLightningA';
	Template.AdditionalAbilities.AddItem('ForceLightningAnimSets');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate ForceChainLightning()
{

	local X2AbilityCooldown						Cooldown;
	local X2AbilityTemplate						Template;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCost_ForcePoints				FPCost;
	local X2Effect_ApplyWeaponDamage			DamageEffect;
	local X2AbilityMultiTarget_AllAllies		MultiTargetStyle;
	local array<name>							SkipExclusions;
	local X2Effect_PrimaryTargetGuaranteedHit	PrimaryTargetGuaranteedHitEffect;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceChainLightning');

	// Icon Properties
	Template.IconImage = "img:///JediClassUI.UIPerk_ChainLightning";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_CHAIN_LIGHTNING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	MultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	MultiTargetStyle.bDontAcceptNeutralUnits = false;
	MultiTargetStyle.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = MultiTargetStyle;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.FORCE_CHAIN_LIGHTNING_COST;
	FPCost.ConsumeAllForce = true;
	Template.AbilityCosts.AddItem(FPCost);

	PrimaryTargetGuaranteedHitEffect = new class'X2Effect_PrimaryTargetGuaranteedHit';
	PrimaryTargetGuaranteedHitEffect.BuildPersistentEffect(1, false, false, false);
	PrimaryTargetGuaranteedHitEffect.Ability = 'ForceChainLightnings';
	Template.AddShooterEffect(PrimaryTargetGuaranteedHitEffect);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_CHAIN_LIGHTNING_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddTargetEffect(StunEffect(default.FORCE_CHAIN_LIGHTNING_STUNNED_ACTIONS, default.FORCE_CHAIN_LIGHTNING_STUN_CHANCE, false));
	Template.AddMultiTargetEffect(StunEffect(default.FORCE_CHAIN_LIGHTNING_STUNNED_ACTIONS, default.FORCE_CHAIN_LIGHTNING_STUN_CHANCE, false));

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';
	
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.ActionFireClass = class'X2Action_Fire_ChainLightning';
	Template.CustomFireAnim = 'HL_ForceChainLightningA';
	Template.AdditionalAbilities.AddItem('ForceLightningAnimSets');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}


static function X2AbilityTemplate LeapStrikeFleche()
{
	local X2AbilityTemplate						Template;
	local X2Effect_FlecheBonusDamage			FlecheBonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LeapStrikeFleche');
	Template.IconImage = "img:///JediClassUI.UIPerk_LeapStrike";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bHideOnClassUnlock = true;
	Template.bCrossClassEligible = false;

	// Fleche
	FlecheBonusDamageEffect = new class 'X2Effect_FlecheBonusDamage';
	FlecheBonusDamageEffect.BuildPersistentEffect (1, true, true);
	FlecheBonusDamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	FlecheBonusDamageEffect.AbilityNames.AddItem('LeapStrike');
	Template.AddTargetEffect(FlecheBonusDamageEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate ForceAlignmentModifier()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ForceAlignmentModifier	ForceAlignmentModifier;
	
	Template = PurePassive('ForceAlignmentModifier', "", false, 'eAbilitySource_Perk', false);
	
	ForceAlignmentModifier = new class'X2Effect_ForceAlignmentModifier';
	ForceAlignmentModifier.BuildPersistentEffect(1, true, true, false);
	Template.AddTargetEffect(ForceAlignmentModifier);

	return Template;
}

static function X2AbilityTemplate ForceLightningAnimSets()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_AdditionalAnimSets		AnimSets;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceLightningAnimSets');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	AnimSets = new class'X2Effect_AdditionalAnimSets';
	AnimSets.AddAnimSetWithPath("Perk_Force_Lightning_Assets.Anims.AS_ForceLightning");
	AnimSets.AddAnimSetWithPath("Perk_Force_Lightning_Assets.Anims.AS_ForceChainLightning");
	AnimSets.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(AnimSets);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

static function X2AbilityTemplate ForceAbilitiesAnimSet()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_AdditionalAnimSets		AnimSets;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceAbilitiesAnimSet');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	AnimSets = new class'X2Effect_AdditionalAnimSets';
	AnimSets.EffectName = 'ForceAnimsets';
	AnimSets.AddAnimSetWithPath("AnimSet'JediClassAbilities.Anims.AS_ForcePowers'");
	AnimSets.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	AnimSets.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(AnimSets);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

static function X2Effect_PersistentStatChange EnergyShieldEffect(int ShieldHPAmount)
{
	local X2Effect_EnergyShield ShieldedEffect;

	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(1, true, false);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, ShieldHPAmount);

	return ShieldedEffect;
}

static function X2Effect_Persistent DisorientEffect()
{
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Condition_UnitProperty Condition_UnitProperty;

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.bApplyOnHit = true;
	DisorientedEffect.bApplyOnMiss = false;
	DisorientedEffect.VisualizationFn = none;

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	DisorientedEffect.TargetConditions.AddItem(Condition_UnitProperty);
	
	return DisorientedEffect;
}

static function X2Effect_Stunned StunEffect(int StunLevel, int Chance, optional bool bIsMentalDamage = true)
{
	local X2Effect_Stunned StunEffect;
	local X2Condition_UnitProperty Condition_UnitProperty;

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(StunLevel, Chance, bIsMentalDamage);
	StunEffect.bApplyOnHit = true;
	StunEffect.bApplyOnMiss = false;

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	StunEffect.TargetConditions.AddItem(Condition_UnitProperty);
	
	return StunEffect;
}

static function X2Effect_Panicked PanickedStatusEffect(int PanickTurns, float DelayVisualizationSec=0.0f)
{
	local X2Effect_Panicked     PanickedEffect;

	PanickedEffect = new class'X2Effect_Panicked';
	PanickedEffect.EffectName = class'X2AbilityTemplateManager'.default.PanickedName;
	PanickedEffect.BuildPersistentEffect(PanickTurns, , , , eGameRule_PlayerTurnBegin);  // Because the effect is removed at Begin turn, we add 1 to duration.
	PanickedEffect.AddPersistentStatChange(eStat_Offense, class'X2StatusEffects'.default.PANICKED_AIM_ADJUST);
	PanickedEffect.EffectHierarchyValue = class'X2StatusEffects'.default.PANICKED_HIERARCHY_VALUE;
	PanickedEffect.EffectAppliedEventName = 'PanickedEffectApplied';

	return PanickedEffect;
}

static function X2AbilityTemplate LightsaberTelekinesis()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown						Cooldown;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCost_ForcePoints				FPCost;
	local X2Effect_ApplyWeaponDamage			WeaponDamageEffect;
	//local array<name>							SkipExclusions;
	//local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityMultiTarget_AllUnits			MultiTargetLightsaber;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	//local X2AbilityTarget_Cursor				CursorTarget;
	//local X2AbilityTarget_Single				SingleTarget;
	local X2Effect_PrimaryTargetGuaranteedHit	PrimaryTargetGuaranteedHitEffect;
	local X2Condition_UnitInventory				LightsaberCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightsaberTelekinesis');

	// Icon Properties
	Template.IconImage = "img:///LightSaber_CV.UI.UIPerk_TossMulti";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 1;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LIGHTSABER_MULTI_TOSS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';

	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	MultiTargetLightsaber = new class'X2AbilityMultiTarget_AllUnits';
	Template.AbilityMultiTargetStyle = MultiTargetLightsaber;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.LIGHTSABER_MULTI_TOSS_COST;
	FPCost.ConsumeAllForce = true;
	Template.AbilityCosts.AddItem(FPCost);

	PrimaryTargetGuaranteedHitEffect = new class'X2Effect_PrimaryTargetGuaranteedHit';
	PrimaryTargetGuaranteedHitEffect.BuildPersistentEffect(1, false, false, false);
	PrimaryTargetGuaranteedHitEffect.Ability = 'LightsaberTelekinesis';
	Template.AddShooterEffect(PrimaryTargetGuaranteedHitEffect);
	
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Can't toss a non-saber
	LightsaberCondition = new class'X2Condition_UnitInventory';
	LightsaberCondition.RelevantSlot = eInvSlot_PrimaryWeapon;
	LightsaberCondition.RequireWeaponCategory = 'lightsaber';
	Template.AbilityShooterConditions.AddItem(LightsaberCondition);

	Template.bAllowBonusWeaponEffects = true;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	//StandardAim.bIndirectFire = true;
	//StandardAim.LOW_COVER_BONUS = 0;
	//StandardAim.HIGH_COVER_BONUS = 0;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.bUsesFiringCamera = true;
	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	//Template.CinescriptCameraType = "Huntman_ThrowAxe";
	
	Template.SourceMissSpeech = 'SwordMiss';

	Template.CustomFireAnim = 'FF_LightsaberTossA';
	Template.CustomFireKillAnim = 'FF_LightsaberTossA';
	Template.ActionFireClass = class'X2Action_LightsaberToss';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.DamagePreviewFn = NormalDamagePreview;
	return Template;
}

static function X2AbilityTemplate LightsaberToss()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_ForcePoints			FPCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	//local X2AbilityCost_Ammo                AmmoCost;
	local X2Condition_UnitInventory			LightsaberCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightsaberToss');

	// Icon Properties
	Template.IconImage = "img:///LightSaber_CV.UI.UIPerk_TossSingle";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LIGHTSABER_TOSS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FPCost = new class'X2AbilityCost_ForcePoints';
	FPCost.ForceAmount = default.LIGHTSABER_TOSS_COST;
	FPCost.ConsumeAllForce = false;
	Template.AbilityCosts.AddItem(FPCost);
	
	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Can't toss a non-saber
	LightsaberCondition = new class'X2Condition_UnitInventory';
	LightsaberCondition.RelevantSlot = eInvSlot_PrimaryWeapon;
	LightsaberCondition.RequireWeaponCategory = 'lightsaber';
	Template.AbilityShooterConditions.AddItem(LightsaberCondition);

	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.bAllowBonusWeaponEffects = true;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	Template.bUsesFiringCamera = true;
	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	Template.TargetingMethod = class'X2TargetingMethod_LightsaberToss';
	Template.CinescriptCameraType = "Huntman_ThrowAxe";
	
	Template.SourceMissSpeech = 'SwordMiss';

	Template.CustomFireAnim = 'FF_LightsaberTossA';
	Template.CustomFireKillAnim = 'FF_LightsaberTossA';
	Template.ActionFireClass = class'X2Action_LightsaberToss';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate LightsaberDeflect()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LightsaberDeflect			RedirectEffect;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	Template = PurePassive('LightsaberDeflect', "img:///LightSaber_CV.UI.UIPerk_Reflect", , 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('LightsaberDeflectShot');

	RedirectEffect = new class'X2Effect_LightsaberDeflect';
	RedirectEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(RedirectEffect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, -50);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	return Template;
}

static function X2AbilityTemplate LightsaberDeflectShot(name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_ApplyReflectDamage			DamageEffect;
	local X2Effect_IncrementUnitValue			IncrementDeflectCount;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///LightSaber_CV.UI.UIPerk_Deflect";

	// Deflect shots should always miss. Only Reflect shots should hit
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_LightsaberDeflect';
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'X2Ability_JediClassAbilities'.static.JediReflectListener;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	DamageEffect = new class'X2Effect_ApplyReflectDamage';
	DamageEffect.EffectDamageValue.DamageType = 'Psi';
	Template.AddTargetEffect(DamageEffect);

	IncrementDeflectCount = new class'X2Effect_IncrementUnitValue';
	IncrementDeflectCount.NewValueToSet = 1;
	IncrementDeflectCount.UnitName = 'DeflectUsed';
	IncrementDeflectCount.CleanupType = eCleanup_BeginTurn;
	Template.AddShooterEffect(IncrementDeflectCount);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.MergeVisualizationFn = LightsaberDeflectShotMergeVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CustomFireAnim = 'HL_LightsaberReflectStartA';
	Template.CustomFireKillAnim = 'HL_LightsaberReflectStartA';
	Template.ActionFireClass = class'X2Action_LightsaberDeflect';

	Template.LocMissMessage = "";
	Template.TargetMissSpeech = '';

	Template.bCrossClassEligible = false;

	return Template;
}

static function X2AbilityTemplate LightsaberReflect()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LightsaberReflect			RedirectEffect;
	local X2Effect_ExtraDeflectChance			DeflectBonusEffect;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;
	
	Template = PurePassive('LightsaberReflect', "img:///LightSaber_CV.UI.UIPerk_Reflect", , 'eAbilitySource_Perk');
	Template.PrerequisiteAbilities.AddItem('LightsaberDeflect');
	Template.OverrideAbilities.AddItem('LightsaberDeflect');
	Template.AdditionalAbilities.AddItem('LightsaberReflectShot');

	RedirectEffect = new class'X2Effect_LightsaberReflect';
	RedirectEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(RedirectEffect);

	DeflectBonusEffect = new class'X2Effect_ExtraDeflectChance';
	DeflectBonusEffect.BuildPersistentEffect(1);
	DeflectBonusEffect.DeflectBonus = default.REFLECT_BONUS;
	Template.AddTargetEffect(DeflectBonusEffect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, -50);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	return Template;
}

static function EventListenerReturn JediReflectListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability		AbilityContext;
	local XComGameState						NewGameState;
	local XComGameState_Unit				UnitState;
	local XComGameState_Ability				JediAbilityState;
	local name								AbilityName;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	JediAbilityState = XComGameState_Ability(CallbackData);

	if (AbilityContext == none || JediAbilityState == none)
	{
		return ELR_NoInterrupt;
	}

	AbilityName = JediAbilityState.GetMyTemplateName();

	if (AbilityContext.InputContext.PrimaryTarget.ObjectID != JediAbilityState.OwnerStateObject.ObjectID)
	{
		return ELR_NoInterrupt;
	}

	//`LOG(default.class @ GetFuncName() @
	//	AbilityContext.InputContext.AbilityTemplateName @ "->" @
	//	AbilityName @
	//	AbilityContext.InterruptionStatus @
	//	AbilityContext.ResultContext.HitResult @
	//	AbilityContext.InputContext.PrimaryTarget.ObjectID @
	//	JediAbilityState.OwnerStateObject.ObjectID
	//,, 'X2JediClassWOTC');

	if ((AbilityName == 'LightsaberDeflectShot' &&
		 AbilityContext.ResultContext.HitResult == eHit_Deflect &&
		 AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
		 ||
		(AbilityName == 'LightsaberReflectShot' &&
		 AbilityContext.ResultContext.HitResult == eHit_Reflect &&
		 AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
	)
	{
		//	set the data needed to apply reflect damage correctly
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(AbilityName @ "Set De/Reflect Context");
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', JediAbilityState.OwnerStateObject.ObjectID));
		UnitState.ReflectedAbilityContext = AbilityContext;
		`TACTICALRULES.SubmitGameState(NewGameState);

		JediAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.SourceObject, false);
	}
	
	return ELR_NoInterrupt;
}

function LightsaberDeflectShotMergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_ExitCover SourceExitCover;
	local X2Action_LightsaberDeflect SourceFire;
	local X2Action_ExitCover TargetExitCover;
	local X2Action_Fire TargetFire;
	local X2Action_EnterCover TargetEnterCover;
	local X2Action_ApplyWeaponDamageToUnit TargetReact;
	local X2Action_MarkerTreeInsertBegin InsertHere;
	local Actor SourceUnit;
	local Actor TargetUnit;
	

	VisMgr = `XCOMVISUALIZATIONMGR;

	SourceFire = X2Action_LightsaberDeflect(VisMgr.GetNodeOfType(BuildTree, class'X2Action_LightsaberDeflect'));
	SourceUnit = SourceFire.Metadata.VisualizeActor;
	TargetReact = X2Action_ApplyWeaponDamageToUnit(VisMgr.GetNodeOfType(BuildTree, class'X2Action_ApplyWeaponDamageToUnit'));
	TargetUnit = TargetReact.Metadata.VisualizeActor;

	SourceExitCover = X2Action_ExitCover(VisMgr.GetNodeOfType(BuildTree, class'X2Action_ExitCover', SourceUnit));
	//VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToUnit', SourceReacts, SourceUnit);

	TargetExitCover = X2Action_ExitCover(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_ExitCover', TargetUnit));
	TargetFire = X2Action_Fire(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_Fire', TargetUnit));
	TargetEnterCover = X2Action_EnterCover(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_EnterCover', TargetUnit));

	// Inject the shooter's projectile into the reflector's fire action
	//SourceFire.SetInstigatingAction(TargetFire);

	// First let's link up the start of our trees
	InsertHere = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_MarkerTreeInsertBegin'));
	VisMgr.ConnectAction(BuildTree, VisualizationTree, false, InsertHere);

	// Now Make the Exit Covers happen at the same time
	VisMgr.ConnectAction(SourceExitCover, VisualizationTree, false, , TargetExitCover.ParentActions);
	VisMgr.ConnectAction(TargetExitCover, VisualizationTree, false, , SourceExitCover.ParentActions);

	// Make the Target Fire wait for both exit covers
	VisMgr.ConnectAction(TargetFire, VisualizationTree, false, SourceExitCover);

	// Now the Source fire should wait for both exit covers as well. The action will delay itself until the proper time.
	VisMgr.ConnectAction(SourceFire, VisualizationTree, false, TargetExitCover);

	// The Target needs to wait to enter cover until after the attack
	VisMgr.ConnectAction(TargetEnterCover, VisualizationTree, false, TargetReact);
}

static function X2AbilityTemplate AddSyncedAnimationDeathOverride()
{
	local X2AbilityTemplate Template;
	local X2Effect_OverrideDeathAction DeathActionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SyncedAnimationDeathOverride');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter"; // TODO: This needs to be changed

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DeathActionEffect = new class'X2Effect_OverrideDeathAction';
	DeathActionEffect.DeathActionClass = class'X2Action_SyncedAnimationDeath';
	Template.AddTargetEffect(DeathActionEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2DataTemplate ForcePoolBonusDamage()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ForcePoolBonusDamage		ForcePoolBonusDamageEffect;

	Template = PurePassive('ForcePoolBonusDamage',,,,false);

	ForcePoolBonusDamageEffect = new class'X2Effect_ForcePoolBonusDamage';
	ForcePoolBonusDamageEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(ForcePoolBonusDamageEffect);

	return Template;
}



DefaultProperties
{
	ForceDrainEventName="ForceDrainTriggered"
	ForceDrainUnitValue="ForceDrainAmount"
}