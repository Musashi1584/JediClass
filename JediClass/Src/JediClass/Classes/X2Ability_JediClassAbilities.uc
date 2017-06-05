class X2Ability_JediClassAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(JediClass);

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
var config int FORCE_WIND_RADIUS;
var config int FORCE_WIND_RANGE;

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

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> AbilityTemplates;

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

	AbilityTemplates.AddItem(ForcLightningAnimSets());
	AbilityTemplates.AddItem(ForceAbilitiesAnimSet());

	return AbilityTemplates;
}

static function X2AbilityTemplate ForceSpeed()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_GrantActionPoints			PointEffect;
	local X2Effect_Persistent					ActionPointPersistEffect;
	local X2Effect_Persistent					ForceSpeedEffect;
	local X2Condition_AbilityProperty			AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceSpeed');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_SPEED_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_overdrive";

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
	ActionPointPersistEffect.BuildPersistentEffect( 1, false, true, false, eGameRule_PlayerTurnEnd );
	Template.AddTargetEffect(ActionPointPersistEffect);

	ForceSpeedEffect = new class'X2Effect_Persistent';
	ForceSpeedEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	ForceSpeedEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, , , Template.AbilitySourceName);
	ForceSpeedEffect.EffectName = 'ForceSpeed';
	Template.AddTargetEffect(ForceSpeedEffect);

	Template.CustomFireAnim = 'FF_Overdrive';
	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.PostActivationEvents.AddItem('OverdriveActivated');
	
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

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_domination";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
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
	
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
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
	
	return Template;
}

static function X2AbilityTemplate ForceHeal()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Charges				ChargeCost;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_UnitStatCheck			UnitStatCheckCondition;
	local X2Condition_UnitEffects			UnitEffectsCondition;
	local X2Effect_ApplyMedikitHeal			MedikitHeal;
	local X2AbilityCharges					ForceHealCharges;
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
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	//Hack: Do this instead of ExcludeDead, to only exclude properly-dead or bleeding-out units.
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = default.FORCE_HEAL_PERUSEHP;
	Template.AddTargetEffect(MedikitHeal);

	Template.AddTargetEffect(RemoveAllEffectsByDamageType());
	Template.AddTargetEffect(RemoveAdditionalEffects());

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_medicalprotocol";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CustomFireAnim = 'HL_ForceA';

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	return Template;
}

static function X2Effect_RemoveEffects RemoveAdditionalEffects()
{
	local X2Effect_RemoveEffects RemoveEffects;
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
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
	local X2AbilityToHitCalc_StandardAim	ToHitCalc;
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
	//Template.IconImage = "img:///";
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
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
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

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';

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
	
	return Template;
}

static function X2AbilityTemplate ForceJump()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle					TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_PersistentTraversalChange	JumpEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceJump');
	Template.IconImage = "img:///JediClassUI.UIPerk_jump";
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	TargetStyle = new class'X2AbilityTarget_Self';

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	JumpEffect = new class'X2Effect_PersistentTraversalChange';
	JumpEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	JumpEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
	JumpEffect.AddTraversalChange(eTraversal_JumpUp, true);
	Template.AddTargetEffect(JumpEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//Template.bShowActivation = true;
	Template.bCrossClassEligible = false;

	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	return Template;
}

static function X2AbilityTemplate ForceWind()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim	ToHitCalc;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local array<name>						SkipExclusions;
	local X2Effect_ForcePush				KnockBackEffect;
	local X2Effect_RemoveEffects			RemoveEffects;
	local X2Effect_RemoveOverwatch			RemoveOverwatchEffect;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
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

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.FORCE_WIND_RANGE;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.FORCE_WIND_RADIUS;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	KnockBackEffect = new class'X2Effect_ForcePush';
	KnockBackEffect.KnockbackDistance = default.FORCE_WIND_KNOCKBACK_DISTANCE;
	KnockBackEffect.bKnockbackDestroysNonFragile = true;
	KnockBackEffect.ForcePushAnimSequence = 'FF_ForcceWindA';
	//KnockBackEffect.bUseTargetLocation = true;
	Template.AddMultiTargetEffect(KnockBackEffect);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EnvironmentalDamageAmount = 20;
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
	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';
	Template.bOverrideAim = true;

	Template.SourceMissSpeech = 'SwordMiss';

	// MAKE IT LIVE!
	Template.bSkipFireAction = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');
	
	return Template;
}

static function X2AbilityTemplate ForcePush()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim	ToHitCalc;
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

	//Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
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
	
	return Template;
}

static function X2AbilityTemplate ForceChoke()
{

	//local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_AdditionalAnimSets		TargetAnimSet;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceChoke');

	// Icon Properties
	//Template.IconImage = "img:///";
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

	//Stun Effect
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_CHOKE_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	TargetAnimSet = new class'X2Effect_AdditionalAnimSets';
	TargetAnimSet.AddAnimSetWithPath("AnimSet'JediClassAbilities.Anims.AS_ForceChokeTarget'");
	Template.AddTargetEffect(TargetAnimSet);
	
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;

	Template.SourceMissSpeech = 'SwordMiss';

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = ForceChoke_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.AdditionalAbilities.AddItem('ForceAbilitiesAnimSet');

	return Template;
}

simulated function ForceChoke_BuildVisualization(XComGameState VisualizeGameState, out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory					History;
	local XComGameStateContext_Ability			Context;
	local StateObjectReference					InteractingUnitRef, TargetUnitRef;

	local VisualizationTrack					EmptyTrack;
	local VisualizationTrack					BuildTrack;
	local X2Action_PlaySoundAndFlyOver			SoundAndFlyOver;
	local X2Action_ApplyWeaponDamageToUnit		WeaponDamageAction;
	local XComGameState_Ability					AbilityState;
	local X2AbilityTemplate						AbilityTemplate;
	local X2VisualizerInterface					TargetVisualizerInterface;
	local X2Action_PlayAnimation				PlayAnimationAction;
	local X2Action_MoveTurn						MoveTurnAction;
	local int i;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;
	TargetUnitRef = Context.InputContext.PrimaryTarget;
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;

	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTrack(BuildTrack, Context));

	if(Context.IsResultContextHit())
	{
		if(AbilityTemplate.SourceHitSpeech != '')
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.SourceHitSpeech, eColor_Bad);
		}

		class'X2Action_Fire_ForceChoke'.static.AddToVisualizationTrack(BuildTrack, Context);
	}
	else
	{
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(BuildTrack, Context));
		PlayAnimationAction.Params.AnimName = 'FF_ForceChokeA';

		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "Force Choke failed", '', eColor_Bad);

	}

	OutVisualizationTracks.AddItem(BuildTrack);


	//Configure the visualization track for the target
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(TargetUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(TargetUnitRef.ObjectID);
	BuildTrack.TrackActor = History.GetVisualizer(TargetUnitRef.ObjectID);

	TargetVisualizerInterface = X2VisualizerInterface(BuildTrack.TrackActor);
	
	//  This is sort of a super hack, that allows DLC/mods to visualize extra stuff in here.
	//  Visualize effects from index 1 as index 0 should be the base game damage effect.
	for (i = 1; i < AbilityTemplate.AbilityTargetEffects.Length; ++i)
	{
		AbilityTemplate.AbilityTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[i]));
	}

	if(Context.IsResultContextHit())
	{
		if (AbilityTemplate.LocHitMessage != "" || AbilityTemplate.TargetHitSpeech != '')
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTrack(BuildTrack, Context));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocHitMessage, AbilityTemplate.TargetHitSpeech, eColor_Good);
		}

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTrack(BuildTrack, Context);
		AbilityTemplate.AbilityTargetEffects[0].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[0]));

		//Visualize the target's death normally.
		if (TargetVisualizerInterface != none)
		{
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
		}
	}
	else
	{
		if( AbilityTemplate.LocMissMessage != "" || AbilityTemplate.TargetMissSpeech != '' )
		{
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocMissMessage, AbilityTemplate.TargetMissSpeech, eColor_Bad);
		}
	}

	OutVisualizationTracks.AddItem(BuildTrack);
}


static function X2AbilityTemplate ForceLightning()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
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
	UnitPropertyCondition.ExcludeRobotic = false;
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

	//Stun Effect
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_LIGHTNING_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);

	Template.AssociatedPassives.AddItem('Electroshock');
	Template.AddTargetEffect(StunEffect(default.FORCE_LIGHTNING_STUNNED_ACTIONS, default.FORCE_LIGHTNING_STUN_CHANCE, false));

	// Hit Calculation (Different weapons now have different calculations for range)
	//ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	//ToHitCalc.bGuaranteedHit = true;
	//ToHitCalc.bMeleeAttack = true;
	//ToHitCalc.bAllowCrit = false;
	//Template.AbilityToHitCalc = ToHitCalc;
	//Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;
	Template.CinescriptCameraType = "Psionic_FireAtLocation";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	//Template.ActionFireClass = class'X2Action_Fire_ChainLightning';
	Template.CustomFireAnim = 'HL_ForceLightningA';
	Template.AdditionalAbilities.AddItem('ForcLightningAnimSets');

	return Template;
}

static function X2AbilityTemplate ForceChainLightning()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local X2AbilityMultiTarget_AllAllies	MultiTargetStyle;
	local array<name>                       SkipExclusions;

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

	//Stun Effect
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue = default.FORCE_CHAIN_LIGHTNING_BASEDAMAGE;
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AssociatedPassives.AddItem('Electroshock');
	Template.AddTargetEffect(StunEffect(default.FORCE_CHAIN_LIGHTNING_STUNNED_ACTIONS, default.FORCE_CHAIN_LIGHTNING_STUN_CHANCE, false));
	Template.AddMultiTargetEffect(StunEffect(default.FORCE_CHAIN_LIGHTNING_STUNNED_ACTIONS, default.FORCE_CHAIN_LIGHTNING_STUN_CHANCE, false));

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	
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
	AnimSets.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	AnimSets.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(AnimSets);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}



static function X2Effect_Persistent DisorientEffect()
{
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Condition_AbilityProperty   AbilityCondition;
	local X2Condition_UnitProperty Condition_UnitProperty;

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.bApplyOnHit = true;
	DisorientedEffect.bApplyOnMiss = false;

	AbilityCondition = new class'X2Condition_AbilityProperty';

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

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(StunLevel,Chance, bIsMentalDamage);
	StunEffect.bApplyOnHit = true;
	StunEffect.bApplyOnMiss = false;

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	StunEffect.TargetConditions.AddItem(Condition_UnitProperty);
	
	return StunEffect;
}
