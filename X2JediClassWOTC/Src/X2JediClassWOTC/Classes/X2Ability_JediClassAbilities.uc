class X2Ability_JediClassAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(JediClass);

var config int FORCE_DRAIN_RADIUS;
var config int FORCE_DRAIN_CHARGES;

var config int FORCE_SENSE_RADIUS;

var config int BATTLE_MEDITATION_COOLDOWN;

var config int ENERGY_ABSORPTION_SHIELD_POINTS;

var config int FORCE_FEAR_COOLDOWN;
var config int FORCE_FEAR_CONE_LENGTH_TILES;
var config int FORCE_FEAR_CONE_END_DIAMETER_TILES;
var config int FORCE_FEAR_TURNS;

var config int FORCE_SPEED_COOLDOWN;

var config int MIND_CONTROL_CHARGES;
var config int MIND_CONTROL_COOLDOWN;

var config int FORCE_HEAL_CHARGES;
var config int FORCE_HEAL_PERUSEHP;

var config int MIND_TRICKS_COOLDOWN;
var config int MIND_TRICKS_RANGE;
var config int MIND_TRICKS_RADIUS;
var config int MIND_TRICKS_TURNS;

var config int FORCE_PUSH_COOLDOWN;
var config int FORCE_PUSH_KNOCKBACK_DISTANCE;

var config int FORCE_WIND_COOLDOWN;
var config int FORCE_WIND_KNOCKBACK_DISTANCE;
var config int FORCE_WIND_CONE_LENGTH_TILES;
var config int FORCE_WIND_CONE_END_DIAMETER_TILES;
var config int FORCE_WIND_ENVIRONMENTAL_DAMAGE;

var config int FORCE_LIGHTNING_STUNNED_ACTIONS;
var config int FORCE_LIGHTNING_STUN_CHANCE;
var config int FORCE_CHAIN_LIGHTNING_STUNNED_ACTIONS;
var config int FORCE_CHAIN_LIGHTNING_STUN_CHANCE;
var config int FORCE_LIGHTNING_COOLDOWN;
var config int FORCE_CHAIN_LIGHTNING_COOLDOWN;

var config WeaponDamageValue FORCE_LIGHTNING_BASEDAMAGE;
var config WeaponDamageValue FORCE_CHAIN_LIGHTNING_BASEDAMAGE;
var config WeaponDamageValue FORCE_CHOKE_BASEDAMAGE;
var config WeaponDamageValue FORCE_PUSH_BASEDAMAGE;
var config WeaponDamageValue FORCE_WIND_BASEDAMAGE;
var config WeaponDamageValue FORCE_DRAIN_BASEDAMAGE;

var config int LIGHTSABER_MULTI_TOSS_COOLDOWN;
var config int LIGHTSABER_MULTI_TOSS_MAX_TARGETS;
var config float LIGHTSABER_MULTI_TOSS_NEXT_TARGET_MAXLENGTH;

var config int REFLECT_BONUS;
var config int REFLECT_REPEAT_MALUS;

var privatewrite name ForceDrainEventName;
var privatewrite name ForceDrainUnitValue;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> AbilityTemplates;

	AbilityTemplates.AddItem(ForceDrain());
	AbilityTemplates.AddItem(LightsaberSlash());
	AbilityTemplates.AddItem(ForceProtection());
	AbilityTemplates.AddItem(ForceSense());
	AbilityTemplates.AddItem(BattleMeditation());
	AbilityTemplates.AddItem(EnergyAbsorption());
	AbilityTemplates.AddItem(ForceFear());
	AbilityTemplates.AddItem(ForceSpeed());
	AbilityTemplates.AddItem(MindControl());
	AbilityTemplates.AddItem(ForceHeal());
	AbilityTemplates.AddItem(MindTricks());
	AbilityTemplates.AddItem(ForceJump());
	AbilityTemplates.AddItem(ForceWind());
	AbilityTemplates.AddItem(ForcePush());
	AbilityTemplates.AddItem(ForceChoke());
	AbilityTemplates.AddItem(ForceLightning());
	AbilityTemplates.AddItem(ForceChainLightning());
	AbilityTemplates.AddItem(LeapStrike());

	// Pulled from PrimaryMeleeWeapons
	AbilityTemplates.AddItem(LightsaberTelekinesis());
	AbilityTemplates.AddItem(LightsaberToss());
	AbilityTemplates.AddItem(LightsaberDeflect());
	AbilityTemplates.AddItem(LightsaberDeflectShot());
	AbilityTemplates.AddItem(LightsaberReflect());

	// Helper abilities, should not be assigned directly
	AbilityTemplates.AddItem(LeapStrikeFleche());
	AbilityTemplates.AddItem(ForceDrainTriggered());
	AbilityTemplates.AddItem(ForceSenseTrigger());
	AbilityTemplates.AddItem(ForceSenseSpawnTrigger());
	AbilityTemplates.AddItem(ForcLightningAnimSets());
	AbilityTemplates.AddItem(ForceAbilitiesAnimSet());
	AbilityTemplates.AddItem(ForceAlignmentModifier());

	return AbilityTemplates;
}

static function X2AbilityTemplate ForceDrain()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityCost_Charges				ChargeCost;
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

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.FORCE_DRAIN_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnitForce';
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = default.FORCE_DRAIN_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true; // skip the cover checks, the squad viewer will handle this once selected
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

	Template.bStationaryWeapon = true;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bSkipPerkActivationActions = true;

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
					//`LOG("TargetUnit" @ TargetUnit.GetMyTemplateName() @ DamageDealt,, 'JediClass');
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
				//`LOG("ForceDrainListener AbilityTriggerAgainstSingleTarget" @ AbilityState.ObjectID,, 'JediClass');
				TargetRef.ObjectID = NewSourceUnit.ObjectID;
				AbilityState.AbilityTriggerAgainstSingleTarget(TargetRef, false);
			}
		}
	}

	return ELR_NoInterrupt;
}


static function X2AbilityTemplate LightsaberSlash()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightsaberSlash');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
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
	Template.bSkipPerkActivationActions = true; // we'll trigger this perk manually based on tile movement
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

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

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BattleMeditation');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BATTLE_MEDITATION_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

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

	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;

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

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceSpeed');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_SPEED_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityCosts.AddItem(default.FreeActionCost);

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

	//Template.CustomFireAnim = 'FF_Overdrive';
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;

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

	Template.CustomFireAnim = 'HL_ForceA';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

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

	Template.CustomFireAnim = 'HL_ForceA';

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
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);	

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

	Template.CustomFireAnim = 'FF_MindTricksA';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate ForceJump()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger						Trigger;
	local X2Effect_PersistentTraversalChange	JumpEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceJump');
	Template.IconImage = "img:///JediClassUI.UIPerk_jump";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	JumpEffect = new class'X2Effect_PersistentTraversalChange';
	JumpEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	JumpEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
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

	KnockBackEffect = new class'X2Effect_ForcePush';
	KnockBackEffect.KnockbackDistance = default.FORCE_WIND_KNOCKBACK_DISTANCE;
	KnockBackEffect.bKnockbackDestroysNonFragile = true;
	KnockBackEffect.ForcePushAnimSequence = 'FF_ForceWindA';
	//KnockBackEffect.bUseTargetLocation = true;
	Template.AddMultiTargetEffect(KnockBackEffect);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EnvironmentalDamageAmount = default.FORCE_WIND_ENVIRONMENTAL_DAMAGE;
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_WIND_BASEDAMAGE;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(DisorientEffect());

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('Suppression');
	RemoveEffects.EffectNamesToRemove.AddItem('AreaSuppression');
	RemoveEffects.bCheckSource = true;
	Template.AddMultiTargetEffect(RemoveEffects);

	RemoveOverwatchEffect = new class'X2Effect_RemoveOverwatch';
	Template.AddMultiTargetEffect(RemoveOverwatchEffect);

	Template.AbilityToHitCalc = default.DeadEye;

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_Cone';
	Template.bOverrideAim = true;

	Template.SourceMissSpeech = 'SwordMiss';

	// MAKE IT LIVE!
	Template.bSkipFireAction = true;

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

	KnockBackEffect = new class'X2Effect_ForcePush';
	KnockBackEffect.KnockbackDistance = default.FORCE_PUSH_KNOCKBACK_DISTANCE;
	KnockBackEffect.bKnockbackDestroysNonFragile = true;
	KnockBackEffect.ForcePushAnimSequence = 'FF_ForcePushA';
	//KnockBackEffect.bUseTargetLocation = true;
	Template.AddTargetEffect(KnockBackEffect);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EnvironmentalDamageAmount = 20;
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_PUSH_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

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

	Template.SourceMissSpeech = 'SwordMiss';

	// MAKE IT LIVE!
	Template.bSkipFireAction = true;

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

	//local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_ActionPoints        ActionPointCost;
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

	//Cooldown = new class'X2AbilityCooldown';
	//Cooldown.iNumTurns = default.FORCE_LIGHTNING_COOLDOWN;
	//Template.AbilityCooldown = Cooldown;

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

		//`LOG(AbilityTemplate.AbilityTargetEffects[0].Name @ Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[0]),, 'JediClass');
		
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
	Template.AdditionalAbilities.AddItem('ForcLightningAnimSets');

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
	Template.AdditionalAbilities.AddItem('ForcLightningAnimSets');

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

static function X2AbilityTemplate LeapStrike()
{
	local X2AbilityTemplate									Template;
	local X2AbilityToHitCalc_StandardMelee					StandardMelee;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local array<name>										SkipExclusions;
	local X2AbilityCost_ActionPoints						ActionPointCost;
	local X2Effect_Persistent								ShadowStepEffect;
	local X2Condition_Visibility							VisibilityCondition;
	local X2Effect_PersistentTraversalChange				TeleportEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LeapStrike');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///JediClassUI.UIPerk_LeapStrike";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
	
	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

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

	TeleportEffect = new class'X2Effect_PersistentTraversalChange';
	TeleportEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	TeleportEffect.AddTraversalChange(eTraversal_Teleport, true);
	Template.AddShooterEffect(TeleportEffect);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	
	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.CustomFireKillAnim = 'MV_MeleeKill';

	Template.ModifyNewContextFn = Teleport_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = Teleport_BuildGameState;
	Template.BuildVisualizationFn = Teleport_BuildVisualization; //TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');
	Template.AdditionalAbilities.AddItem('LeapStrikeFleche');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	return Template;
}

static simulated function Teleport_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local PathPoint NextPoint, EmptyPoint;
	local PathingInputData InputData;
	local XComWorldData World;
	local vector NewLocation;
	local TTile NewTileLocation;
	local array<TTile> PathTiles;

	History = `XCOMHISTORY;
	World = `XWORLD;
	
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
		NewTileLocation = PathTiles[PathTiles.Length - 1];
		NewLocation = World.GetPositionFromTileCoordinates(NewTileLocation);
	}
	else
	{
		NewTileLocation = XComTacticalController(`PRES.GetTacticalHUD().PC).m_kPathingPawn.LastDestinationTile;
		NewLocation = World.GetPositionFromTileCoordinates(NewTileLocation);
	}

	NextPoint = EmptyPoint;
	NextPoint.Position = NewLocation;
	NextPoint.Traversal = eTraversal_Landing;
	NextPoint.PathTileIndex = 1;
	InputData.MovementData.AddItem(NextPoint);
	InputData.MovementTiles.AddItem(NewTileLocation);
	
    //Now add the path to the input context
	InputData.MovingUnitRef = UnitState.GetReference();
	AbilityContext.InputContext.MovementPaths.Length = 0;
	AbilityContext.InputContext.MovementPaths.AddItem(InputData);
	`LOG(GetFuncName() @ AbilityContext.InputContext.MovementPaths.Length,, 'JediClass');
}

static simulated function XComGameState Teleport_BuildGameState(XComGameStateContext Context)
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
	`assert(LastElementIndex > 0);
	NewLocation = AbilityContext.InputContext.MovementPaths[0].MovementData[LastElementIndex].Position;
	NewTileLocation = World.GetTileCoordinatesFromPosition(NewLocation);
	UnitState.SetVisibilityLocation(NewTileLocation);

	AbilityContext.ResultContext.bPathCausesDestruction = MoveAbility_StepCausesDestruction(UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
	MoveAbility_AddTileStateObjects(NewGameState, UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);

	EventManager.TriggerEvent('ObjectMoved', UnitState, UnitState, NewGameState);
	EventManager.TriggerEvent('UnitMoveFinished', UnitState, UnitState, NewGameState);

	return NewGameState;
}

function Teleport_BuildVisualization(XComGameState VisualizeGameState)
{
	XComGameStateContext_Ability(VisualizeGameState.GetContext()).InputContext.MovementPaths.Remove(1, 1);
	TypicalAbility_BuildVisualization(VisualizeGameState);
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

static function X2AbilityTemplate ForcLightningAnimSets()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_AdditionalAnimSets		AnimSets;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForcLightningAnimSets');
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
	AnimSets.AddAnimSetWithPath("AnimSet'JediClassAbilities.Anims.AS_Teleport'");
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
	local X2Effect_ApplyWeaponDamage			WeaponDamageEffect;
	//local array<name>							SkipExclusions;
	//local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityMultiTarget_AllUnits			MultiTargetLightsaber;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	//local X2AbilityTarget_Cursor				CursorTarget;
	//local X2AbilityTarget_Single				SingleTarget;
	local X2Effect_PrimaryTargetGuaranteedHit	PrimaryTargetGuaranteedHitEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightsaberTelekinesis');

	// Icon Properties
	Template.IconImage = "img:///LightSaber_CV.UI.UIPerk_TossMulti";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
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
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	//local X2AbilityCost_Ammo                AmmoCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightsaberToss');

	// Icon Properties
	Template.IconImage = "img:///LightSaber_CV.UI.UIPerk_TossSingle";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

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

	Template = PurePassive('LightsaberDeflect', "img:///LightSaber_CV.UI.UIPerk_Reflect", , 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('LightsaberDeflectShot');

	RedirectEffect = new class'X2Effect_LightsaberDeflect';
	RedirectEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(RedirectEffect);

	return Template;
}

static function X2AbilityTemplate LightsaberDeflectShot()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_ApplyReflectDamage			DamageEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightsaberDeflectShot');

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
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.TemplarReflectListener;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	DamageEffect = new class'X2Effect_ApplyReflectDamage';
	DamageEffect.EffectDamageValue.DamageType = 'Psi';
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.MergeVisualizationFn = LightsaberDeflectShotMergeVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	// The Action will fire off the animation at the right time, so leave the jedi idling until then
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CustomFireAnim = 'HL_Idle';
	Template.CustomFireKillAnim = 'HL_Idle';
	Template.ActionFireClass = class'X2Action_LightsaberDeflect';

	Template.bCrossClassEligible = false;

	return Template;
}

static function X2AbilityTemplate LightsaberReflect()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LightsaberReflect			RedirectEffect;
	local X2Effect_ExtraDeflectChance			DeflectBonusEffect;

	Template = PurePassive('LightsaberReflect', "img:///LightSaber_CV.UI.UIPerk_Reflect", , 'eAbilitySource_Perk');
	Template.PrerequisiteAbilities.AddItem('LightsaberDeflect');
	Template.OverrideAbilities.AddItem('LightsaberDeflect');
	Template.AdditionalAbilities.AddItem('LightsaberDeflectShot');

	RedirectEffect = new class'X2Effect_LightsaberReflect';
	RedirectEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(RedirectEffect);

	DeflectBonusEffect = new class'X2Effect_ExtraDeflectChance';
	DeflectBonusEffect.BuildPersistentEffect(1);
	DeflectBonusEffect.DeflectBonus = default.REFLECT_BONUS;
	Template.AddTargetEffect(DeflectBonusEffect);

	return Template;
}

function LightsaberDeflectShotMergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_ExitCover SourceExitCover;
	//local Array<X2Action> SourceReacts;
	local X2Action_LightsaberDeflect SourceFire;
	local X2Action_ExitCover TargetExitCover;
	local X2Action_Fire TargetFire;
	local X2Action_EnterCover TargetEnterCover;
	local X2Action_ApplyWeaponDamageToUnit TargetReact;
	local X2Action_MarkerTreeInsertBegin InsertHere;
	local Actor SourceUnit;
	local Actor TargetUnit;
	local XComGameState NewGameState;
	local XComGameState_Unit DeflectUnit, NewDeflectUnitState;
	local UnitValue DeflectValue;

	VisMgr = `XCOMVISUALIZATIONMGR;

	SourceFire = X2Action_LightsaberDeflect(VisMgr.GetNodeOfType(BuildTree, class'X2Action_LightsaberDeflect'));
	SourceUnit = SourceFire.Metadata.VisualizeActor;
	TargetReact = X2Action_ApplyWeaponDamageToUnit(VisMgr.GetNodeOfType(BuildTree, class'X2Action_ApplyWeaponDamageToUnit'));
	TargetUnit = TargetReact.Metadata.VisualizeActor;

	// Tell the unit how many times it's deflected this turn
	DeflectUnit = XComGameState_Unit(SourceFire.Metadata.StateObject_NewState);
	DeflectUnit.GetUnitValue(class'X2Effect_LightsaberDeflect'.default.DeflectUsed, DeflectValue);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(String(GetFuncName()));
	NewDeflectUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', DeflectUnit.ObjectID));
	NewDeflectUnitState.SetUnitFloatValue(class'X2Effect_LightsaberDeflect'.default.DeflectUsed, int(DeflectValue.fValue) + 1, eCleanup_BeginTurn);
	DeflectUnit.SetUnitFloatValue(class'X2Effect_LightsaberDeflect'.default.DeflectUsed, int(DeflectValue.fValue) + 1, eCleanup_BeginTurn);
	`GAMERULES.SubmitGameState(NewGameState);

	SourceExitCover = X2Action_ExitCover(VisMgr.GetNodeOfType(BuildTree, class'X2Action_ExitCover', SourceUnit));
	//VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToUnit', SourceReacts, SourceUnit);

	TargetExitCover = X2Action_ExitCover(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_ExitCover', TargetUnit));
	TargetFire = X2Action_Fire(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_Fire', TargetUnit));
	TargetEnterCover = X2Action_EnterCover(VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_EnterCover', TargetUnit));

	// Inject the shooter's projectile into the reflector's fire action
	SourceFire.SetInstigatingAction(TargetFire);

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

DefaultProperties
{
	ForceDrainEventName="ForceDrainTriggered"
	ForceDrainUnitValue="ForceDrainAmount"
}