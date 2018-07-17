//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_JediClass.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_JediClass extends X2DownloadableContentInfo config (JediClass);

struct SocketReplacementInfo
{
	var name TorsoName;
	var string SocketMeshString;
	var bool Female;
};


var config array<SocketReplacementInfo> SocketReplacements;

var config array<Name> IgnoreAbilitiesForForceSpeed;

var config array<LootTable> LOOT_TABLES;

var config name BASIC_LOOT_ENTRIES_TO_TABLE;
var config array<LootTableEntry> BASIC_LOOT_ENTRIES;

var config name ADVANCED_LOOT_ENTRIES_TO_TABLE;
var config array<LootTableEntry> ADVANCED_LOOT_ENTRIES;

var config name SUPERIOR_LOOT_ENTRIES_TO_TABLE;
var config array<LootTableEntry> SUPERIOR_LOOT_ENTRIES;


/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	UpdateResearch();
}

static function UpdateResearch()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2TechTemplate TechTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	local name ResearchName;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(default.class $ "::" $ GetFuncName());

	foreach class'X2StrategyElement_LightsaberTech'.default.LIGHTSABER_PROJECT_NAMES(ResearchName)
	{
		if (!IsResearchInHistory(ResearchName))
		{
			`log(default.class @ GetFuncName() @ ResearchName @ "not found, creating...",, 'X2JediClassWOTC');
			TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate(ResearchName));
			if (TechTemplate != none)
			{
				NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
			}
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`GAMERULES.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static function bool IsResearchInHistory(name ResearchName)
{
	// Check if we've already injected the tech templates
	local XComGameState_Tech	TechState;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if ( TechState.GetMyTemplateName() == ResearchName )
		{
			return true;
		}
	}
	return false;
}


/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	//`LOG("ForceLightning Ability" @ class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('ForceLightning'),, 'JediClass');
	OnPostAbilityTemplatesCreated();
	OnPostLootTablesCreated();
}

static function OnPostAbilityTemplatesCreated()
{
	local array<name> TemplateNames;
	local array<X2AbilityTemplate> AbilityTemplates;
	local name TemplateName;
	local X2AbilityTemplateManager AbilityMgr;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityCost Cost;
	local X2AbilityCost_ActionPoints ActionPointCost;


	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityMgr.GetTemplateNames(TemplateNames);
	foreach TemplateNames(TemplateName)
	{
		if (default.IgnoreAbilitiesForForceSpeed.Find(TemplateName) != INDEX_NONE)
		{
			continue;
		}

		AbilityMgr.FindAbilityTemplateAllDifficulties(TemplateName, AbilityTemplates);
		foreach AbilityTemplates(AbilityTemplate)
		{
			foreach AbilityTemplate.AbilityCosts(Cost)
			{
				ActionPointCost = X2AbilityCost_ActionPoints(Cost);
				if (ActionPointCost != None)
				{
					ActionPointCost.DoNotConsumeAllEffects.AddItem('ForceSpeed');
				}
			}
		}
	}
}

static function OnPostLootTablesCreated()
{
	local LootTable CurrentLoot;
	local LootTableEntry CurrentEntry;

	foreach default.LOOT_TABLES(CurrentLoot)
	{
		class'X2LootTableManager'.static.AddLootTableStatic(CurrentLoot);
	}

	foreach default.BASIC_LOOT_ENTRIES(CurrentEntry)
	{
		class'X2LootTableManager'.static.AddEntryStatic(default.BASIC_LOOT_ENTRIES_TO_TABLE, CurrentEntry, false);
	}
	class'X2LootTableManager'.static.RecalculateLootTableChanceStatic(default.BASIC_LOOT_ENTRIES_TO_TABLE);

	foreach default.ADVANCED_LOOT_ENTRIES(CurrentEntry)
	{
		class'X2LootTableManager'.static.AddEntryStatic(default.ADVANCED_LOOT_ENTRIES_TO_TABLE, CurrentEntry, false);
	}
	class'X2LootTableManager'.static.RecalculateLootTableChanceStatic(default.ADVANCED_LOOT_ENTRIES_TO_TABLE);

	foreach default.SUPERIOR_LOOT_ENTRIES(CurrentEntry)
	{
		class'X2LootTableManager'.static.AddEntryStatic(default.SUPERIOR_LOOT_ENTRIES_TO_TABLE, CurrentEntry, false);
	}
	class'X2LootTableManager'.static.RecalculateLootTableChanceStatic(default.SUPERIOR_LOOT_ENTRIES_TO_TABLE);
}


static function string DLCAppendSockets(XComUnitPawn Pawn)
{
	local SocketReplacementInfo SocketReplacement;
	local name TorsoName;
	local bool bIsFemale;
	local string DefaultString, ReturnString;
	local XComHumanPawn HumanPawn;

	//`LOG("DLCAppendSockets" @ Pawn,, 'DualWieldMelee');

	HumanPawn = XComHumanPawn(Pawn);
	if (HumanPawn == none) { return ""; }

	TorsoName = HumanPawn.m_kAppearance.nmTorso;
	bIsFemale = HumanPawn.m_kAppearance.iGender == eGender_Female;

	//`LOG("DLCAppendSockets: Torso= " $ TorsoName $ ", Female= " $ string(bIsFemale),, 'DualWieldMelee');

	foreach default.SocketReplacements(SocketReplacement)
	{
		if (TorsoName != 'None' && TorsoName == SocketReplacement.TorsoName && bIsFemale == SocketReplacement.Female)
		{
			ReturnString = SocketReplacement.SocketMeshString;
			break;
		}
		else
		{
			if (SocketReplacement.TorsoName == 'Default' && SocketReplacement.Female == bIsFemale)
			{
				DefaultString = SocketReplacement.SocketMeshString;
			}
		}
	}
	if (ReturnString == "")
	{
		// did not find, so use default
		ReturnString = DefaultString;
	}

	return ReturnString;
}

static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	if (UnitState.IsAdvent() || UnitState.IsAlien())
	{
		CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("JediClassAbilities.Anims.AS_ForceChokeTarget")));
	}
}

