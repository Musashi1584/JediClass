class X2Ability_JediClassAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(JediClass);

var config int FORCE_LIGHTNING_COOLDOWN;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> AbilityTemplates;

	AbilityTemplates.AddItem(ForceLightning());

	return AbilityTemplates;
}

static function X2AbilityTemplate ForceLightning()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local X2Effect_AdditionalAnimSets		AnimSets;
	local array<name>                       SkipExclusions;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceLightning');

	// Icon Properties
	//Template.IconImage = "img:///";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FORCE_LIGHTNING_COOLDOWN;
	//Template.AbilityCooldown = Cooldown;

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
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	//Stun Effect
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.bBypassShields = true;
	DamageEffect.EffectDamageValue.Damage = 10;
	DamageEffect.EffectDamageValue.DamageType = 'Psi';
	Template.AddTargetEffect(DamageEffect);
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AssociatedPassives.AddItem('Electroshock');
	Template.AddTargetEffect(ElectroshockDisorientEffect());
	Template.AddMultiTargetEffect(ElectroshockDisorientEffect());

	// Hit Calculation (Different weapons now have different calculations for range)
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = true;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
			
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	//Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";
	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;
	//Template.ActivationSpeech = 'StunTarget';

	AnimSets = new class'X2Effect_AdditionalAnimSets';
	AnimSets.AddAnimSetWithPath("Perk_Force_Lightning_Assets.Anims.AS_ForceLightning");
	AnimSets.BuildPersistentEffect(1, true, false, false);
	Template.AddShooterEffect(AnimSets);


	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.ActionFireClass = class'X2Action_Fire_ChainLightning';
	Template.CustomFireAnim = 'HL_ForceLightningA';

	return Template;
}

static function X2Effect_Persistent ElectroshockDisorientEffect()
{
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Condition_AbilityProperty   AbilityCondition;
	local X2Condition_UnitProperty Condition_UnitProperty;

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.bApplyOnHit = false;
	DisorientedEffect.bApplyOnMiss = true;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	//AbilityCondition.OwnerHasSoldierAbilities.AddItem('Electroshock');
	//DisorientedEffect.TargetConditions.AddItem(AbilityCondition);

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	DisorientedEffect.TargetConditions.AddItem(Condition_UnitProperty);
	
	return DisorientedEffect;
}
