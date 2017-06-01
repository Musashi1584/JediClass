class X2Ability_JediClassAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(JediClass);

var config int FORCE_PUSH_KNOCKBACK_DISTANCE;
var config int FORCE_LIGHTNING_COOLDOWN;
var config int FORCE_CHAIN_LIGHTNING_COOLDOWN;
var config WeaponDamageValue FORCE_LIGHTNING_BASEDAMAGE;
var config WeaponDamageValue FORCE_CHAIN_LIGHTNING_BASEDAMAGE;
var config WeaponDamageValue FORCE_CHOKE_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> AbilityTemplates;

	AbilityTemplates.AddItem(ForcePush());
	AbilityTemplates.AddItem(ForceChoke());
	AbilityTemplates.AddItem(ForceLightning());
	AbilityTemplates.AddItem(ForceChainLightning());

	AbilityTemplates.AddItem(ForcLightningAnimSets());
	AbilityTemplates.AddItem(ForceChokeAnimSet());

	return AbilityTemplates;
}

static function X2AbilityTemplate ForcePush()
{
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	//local X2Effect_ApplyWeaponDamage		DamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_ForcePush				KnockBackEffect;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForcePush');

	// Icon Properties
	//Template.IconImage = "img:///";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

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
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	//Stun Effect
	//DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	//DamageEffect.bIgnoreBaseDamage = true;
	//DamageEffect.bBypassShields = true;
	//DamageEffect.EffectDamageValue = default.FORCE_CHOKE_BASEDAMAGE;
	//Template.AddTargetEffect(DamageEffect);
	KnockBackEffect = new class'X2Effect_ForcePush';
	KnockBackEffect.KnockbackDistance = default.FORCE_PUSH_KNOCKBACK_DISTANCE;
	KnockBackEffect.bKnockbackDestroysNonFragile = true;
	//KnockBackEffect.bUseTargetLocation = true;
	Template.AddTargetEffect(KnockBackEffect);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bOverrideAim = true;
	//Template.bUseSourceLocationZToAim = true;

	Template.SourceMissSpeech = 'SwordMiss';

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

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
	Template.AdditionalAbilities.AddItem('ForceChokeAnimSet');

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
	Template.AddTargetEffect(ElectroshockDisorientEffect());

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
	Template.AddTargetEffect(ElectroshockDisorientEffect());
	Template.AddMultiTargetEffect(ElectroshockDisorientEffect());

	// Hit Calculation (Different weapons now have different calculations for range)
	//ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	//ToHitCalc.bGuaranteedHit = true;
	//ToHitCalc.bMeleeAttack = true;
	//ToHitCalc.bAllowCrit = false;
	//Template.AbilityToHitCalc = ToHitCalc;
	//Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
	//ToHitCalc.bOnlyMultiHitWithSuccess = false;
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	//Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	//Template.CinescriptCameraType = "Psionic_FireAtLocation";
	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;
	//Template.ActivationSpeech = 'StunTarget';

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

static function X2AbilityTemplate ForceChokeAnimSet()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_AdditionalAnimSets		AnimSets;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ForceChokeAnimSet');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	AnimSets = new class'X2Effect_AdditionalAnimSets';
	AnimSets.AddAnimSetWithPath("AnimSet'JediClassAbilities.Anims.AS_ForceChoke'");
	AnimSets.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(AnimSets);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}



static function X2Effect_Persistent ElectroshockDisorientEffect()
{
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Condition_AbilityProperty   AbilityCondition;
	local X2Condition_UnitProperty Condition_UnitProperty;

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.bApplyOnHit = true;
	DisorientedEffect.bApplyOnMiss = false;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	//AbilityCondition.OwnerHasSoldierAbilities.AddItem('Electroshock');
	//DisorientedEffect.TargetConditions.AddItem(AbilityCondition);

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	DisorientedEffect.TargetConditions.AddItem(Condition_UnitProperty);
	
	return DisorientedEffect;
}
