//---------------------------------------------------------------------------------------
// Based on X2Effect_Knockback
//---------------------------------------------------------------------------------------
class X2Effect_ForcePush extends X2Effect;

var name ForcePushAnimSequence;

/** Distance that the target will be thrown backwards, in meters */
var int KnockbackDistance;

/** If true, the KnockbackDistance will be added to the target's location instead of the source location. */
var bool bUseTargetLocation;

/** Used to step the knockback forward along the movement vector until either knock back distance is reached, or there are no more valid tiles*/
var private float IncrementalStepSize;

/** If true, the knocked back unit will cause non fragile destruction ( like kinetic strike ) */
var bool bKnockbackDestroysNonFragile;

/** Distance that the target will be thrown backwards, in meters */
var float OverrideRagdollFinishTimerSec;

var float DefaultDamage;
var float DefaultRadius;

function name WasTargetPreviouslyDead(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	// A unit that was dead before this game state should not get a knockback, they are already a corpse
	local name AvailableCode;
	local XComGameState_Unit PreviousTargetStateObject;
	local XComGameStateHistory History;

	AvailableCode = 'AA_Success';

	History = `XCOMHISTORY;

	PreviousTargetStateObject = XComGameState_Unit(History.GetGameStateForObjectID(kNewTargetState.ObjectID));
	if( (PreviousTargetStateObject != none) && PreviousTargetStateObject.IsDead() )
	{
		//`LOG("X2Effect_ForcePush WasTargetPreviouslyDead true",, 'X2JediClassWOTC');
		return 'AA_UnitIsDead';
	}

	return AvailableCode;
}

private function bool CanBeDestroyed(XComInteractiveLevelActor InteractiveActor, float DamageAmount)
{
	//make sure the knockback damage can destroy this actor.
	//check the number of interaction points to prevent larger objects from being destroyed.
	//return InteractiveActor != none && DamageAmount >= InteractiveActor.Health && InteractiveActor.InteractionPoints.Length <= 8;
	return true;
}

private function int GetKnockbackDistance(XComGameStateContext_Ability AbilityContext, XComGameState_BaseObject kNewTargetState)
{
	local int UpdatedKnockbackDistance_Meters, ReasonIndex;
	local XComGameState_Unit TargetUnitState;
	local name UnitTypeName;
	local array<KnockbackDistanceOverride> KnockbackDistanceOverrides;

	KnockbackDistanceOverrides = class'X2Effect_Knockback'.default.KnockbackDistanceOverrides;
	UpdatedKnockbackDistance_Meters = KnockbackDistance;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	if (TargetUnitState != none)
	{
		UnitTypeName = TargetUnitState.GetMyTemplate().CharacterGroupName;
	}

	// For now, the only OverrideReason is CharacterGroupName. If otheres are desired, add extra checks here.
	ReasonIndex = KnockbackDistanceOverrides.Find('OverrideReason', UnitTypeName);

	if (ReasonIndex != INDEX_NONE)
	{
		UpdatedKnockbackDistance_Meters = KnockbackDistanceOverrides[ReasonIndex].NewKnockbackDistance_Meters;
	}

	return UpdatedKnockbackDistance_Meters;
}

//Returns the list of tiles that the unit will pass through as part of the knock back. The last tile in the array is the final destination.
private function GetTilesEnteredArray(XComGameStateContext_Ability AbilityContext, XComGameState_BaseObject kNewTargetState, out array<TTile> OutTilesEntered, out Vector OutAttackDirection, float DamageAmount, XComGameState NewGameState)
{
	local XComWorldData WorldData;
	local XComGameState_Unit SourceUnit;
	local XComGameState_Unit TargetUnit;
	local Vector SourceLocation;
	local Vector TargetLocation;
	local Vector StartLocation;
	local TTile  TempTile, StartTile;
	local TTile  LastTempTile;
	local Vector KnockbackToLocation;	
	local float  StepDistance;
	local Vector TestLocation;
	local float  TestDistanceUnits;
	local XGUnit TargetVisualizer;
	local XComUnitPawn TargetUnitPawn;
	local Vector Extents;
	local XComGameStateHistory History;

	local ActorTraceHitInfo TraceHitInfo;
	local array<ActorTraceHitInfo> Hits;
	local Actor FloorTileActor;

	local int UpdatedKnockbackDistance_Meters;
	local array<StateObjectReference> TileUnits;

	WorldData = `XWORLD;
	History = `XCOMHISTORY;

	//`LOG("X2Effect_ForcePush GetTilesEnteredArray" @ AbilityContext,, 'X2JediClassWOTC');

	if(AbilityContext != none)
	{
		TargetUnit = XComGameState_Unit(kNewTargetState);
		TargetUnit.GetKeystoneVisibilityLocation(StartTile);
		TargetLocation = WorldData.GetPositionFromTileCoordinates(StartTile);
		//`LOG("X2Effect_ForcePush TargetLocation" @ TargetLocation,, 'X2JediClassWOTC');

		//attack source is from a Unit
		SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		SourceUnit.GetKeystoneVisibilityLocation(TempTile);
		SourceLocation = WorldData.GetPositionFromTileCoordinates(TempTile);

		//`LOG("X2Effect_ForcePush TargetUnit" @ TargetUnit.IsAlive() @ TargetUnit.IsIncapacitated(),, 'X2JediClassWOTC');

		//if(TargetUnit.IsAlive() || TargetUnit.IsIncapacitated())
		//{
			OutAttackDirection = Normal(TargetLocation - SourceLocation);
			OutAttackDirection.Z = 0.0f;
			StartLocation = TargetLocation;											

			UpdatedKnockbackDistance_Meters = GetKnockbackDistance(AbilityContext, kNewTargetState);

			KnockbackToLocation = StartLocation + (OutAttackDirection * float(UpdatedKnockbackDistance_Meters) * 64.0f); //Convert knockback distance to meters

			//`LOG("X2Effect_ForcePush StartLocation KnockbackToLocation" @ StartLocation @ KnockbackToLocation,, 'X2JediClassWOTC');
			TargetVisualizer = XGUnit(History.GetVisualizer(TargetUnit.ObjectID));
			if( TargetVisualizer != None )
			{
				TargetUnitPawn = TargetVisualizer.GetPawn();
				if( TargetUnitPawn != None )
				{
					Extents.X = TargetUnitPawn.CylinderComponent.CollisionRadius;
					Extents.Y = TargetUnitPawn.CylinderComponent.CollisionRadius; 
					Extents.Z = TargetUnitPawn.CylinderComponent.CollisionHeight;
				}
			}

			if (WorldData.GetAllActorsTrace(StartLocation, KnockbackToLocation, Hits, Extents))
			{
				foreach Hits(TraceHitInfo)
				{
					TempTile = WorldData.GetTileCoordinatesFromPosition(TraceHitInfo.HitLocation);
					FloorTileActor = WorldData.GetFloorTileActor(TempTile);

					if( TraceHitInfo.HitActor == FloorTileActor )
					{
						continue;
					}

					if((!CanBeDestroyed(XComInteractiveLevelActor(TraceHitInfo.HitActor), DamageAmount) && XComFracLevelActor(TraceHitInfo.HitActor) == none) || !bKnockbackDestroysNonFragile)
					{
						//We hit an indestructible object
						`LOG("X2Effect_ForcePush Hitting undestructible actor",, 'X2JediClassWOTC');
						KnockbackToLocation = TraceHitInfo.HitLocation + (-OutAttackDirection * 16.0f); //Scoot the hit back a bit and use that as the knockback location
						break;
					}
				}
			}

			//Walk in increments down the attack vector. We will stop if we can't find a floor, or have reached the knock back distance
			TestDistanceUnits = VSize2D(KnockbackToLocation - StartLocation);
			StepDistance = 0.0f;
			OutTilesEntered.Length = 0;
			LastTempTile = StartTile;
			while(StepDistance < TestDistanceUnits)
			{
				TestLocation = StartLocation + (OutAttackDirection * StepDistance);
				if(!WorldData.GetFloorTileForPosition(TestLocation, TempTile, true))
				{
					TestLocation -= (OutAttackDirection * StepDistance * 2);
					break;
				}

				if (TempTile != StartTile)		//	don't check the start tile, since the target unit would be on it
				{
					TileUnits = WorldData.GetUnitsOnTile(TempTile);
					if (TileUnits.Length > 0)
						break;
				}

				if(LastTempTile != TempTile)
				{
					OutTilesEntered.AddItem(TempTile);
					LastTempTile = TempTile;
				}
				
				StepDistance += IncrementalStepSize;
			}

			//Move the target unit to the knockback location
			if (OutTilesEntered.Length == 0 || OutTilesEntered[OutTilesEntered.Length - 1] != LastTempTile)
				OutTilesEntered.AddItem(LastTempTile);
		//}
	}
}


simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_BaseObject kNewTargetState;
	local int Index;
	local XComGameState_EnvironmentDamage DamageEvent;
	local XComWorldData WorldData;
	local TTile HitTile;
	local array<TTile> TilesEntered;
	local Vector AttackDirection;
	local array<StateObjectReference> Targets;
	local StateObjectReference CurrentTarget;
	local XComGameState_Unit TargetUnit;
	local TTile NewTileLocation;
	local float KnockbackDamage;
	local float KnockbackRadius;
	local int EffectIndex, MultiTargetIndex;
	local X2Effect_ForcePush KnockbackEffect;

	//`LOG("X2Effect_ForcePush ApplyEffectToWorld",, 'X2JediClassWOTC');

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	if(AbilityContext != none)
	{
		if (AbilityContext.InputContext.PrimaryTarget.ObjectID > 0)
		{
			// Check the Primary Target for a successful knockback
			for (EffectIndex = 0; EffectIndex < AbilityContext.ResultContext.TargetEffectResults.Effects.Length; ++EffectIndex)
			{
				KnockbackEffect = X2Effect_ForcePush(AbilityContext.ResultContext.TargetEffectResults.Effects[EffectIndex]);
				if (KnockbackEffect != none)
				{
					if (AbilityContext.ResultContext.TargetEffectResults.ApplyResults[EffectIndex] == 'AA_Success')
					{
						Targets.AddItem(AbilityContext.InputContext.PrimaryTarget);
						break;
					}
				}
			}
		}

		for (MultiTargetIndex = 0; MultiTargetIndex < AbilityContext.InputContext.MultiTargets.Length; ++MultiTargetIndex)
		{
			// Check the MultiTargets for a successful knockback
			for (EffectIndex = 0; EffectIndex < AbilityContext.ResultContext.MultiTargetEffectResults[MultiTargetIndex].Effects.Length; ++EffectIndex)
			{
				KnockbackEffect = X2Effect_ForcePush(AbilityContext.ResultContext.MultiTargetEffectResults[MultiTargetIndex].Effects[EffectIndex]);
				if (KnockbackEffect != none)
				{
					if (AbilityContext.ResultContext.MultiTargetEffectResults[MultiTargetIndex].ApplyResults[EffectIndex] == 'AA_Success')
					{
						Targets.AddItem(AbilityContext.InputContext.MultiTargets[MultiTargetIndex]);
						`LOG("X2Effect_ForcePush Add multi target" @ AbilityContext.InputContext.MultiTargets[MultiTargetIndex].ObjectID,, 'X2JediClassWOTC');
						break;
					}
				}
			}
		}

		foreach Targets(CurrentTarget)
		{
			KnockbackDamage = default.DefaultDamage;
			KnockbackRadius = default.DefaultRadius;

			kNewTargetState = NewGameState.GetGameStateForObjectID(CurrentTarget.ObjectID);
			TargetUnit = XComGameState_Unit(kNewTargetState);
			if(TargetUnit != none) //Only units can be knocked back
			{
				TilesEntered.Length = 0;
				GetTilesEnteredArray(AbilityContext, kNewTargetState, TilesEntered, AttackDirection, KnockbackDamage, NewGameState);

				//Only process the code below if the target went somewhere
				if(TilesEntered.Length > 0)
				{
					WorldData = `XWORLD;

					if(bKnockbackDestroysNonFragile)
					{
						for(Index = 0; Index < TilesEntered.Length; ++Index)
						{
							HitTile = TilesEntered[Index];
							HitTile.Z += 1;

							DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));
							DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ForcePush:ApplyEffectToWorld";
							DamageEvent.DamageAmount = KnockbackDamage;
							DamageEvent.DamageTypeTemplateName = 'Melee';
							DamageEvent.HitLocation = WorldData.GetPositionFromTileCoordinates(HitTile);
							DamageEvent.HitLocationTile = HitTile;
							DamageEvent.Momentum = AttackDirection;
							DamageEvent.DamageDirection = AttackDirection; //Limit environmental damage to the attack direction( ie. spare floors )
							DamageEvent.PhysImpulse = 500;
							DamageEvent.DamageRadius = KnockbackRadius;
							DamageEvent.DamageCause = ApplyEffectParameters.SourceStateObjectRef;
							DamageEvent.DamageSource = DamageEvent.DamageCause;
							DamageEvent.bRadialDamage = false;
							DamageEvent.bIsHit = true;
							//`LOG("X2Effect_ForcePush Add DamageEvent",, 'X2JediClassWOTC');
						}
					}

					NewTileLocation = TilesEntered[TilesEntered.Length - 1];
					TargetUnit.SetVisibilityLocation(NewTileLocation);
				}
			}			
		}
	}
}

simulated function int CalculateDamageAmount(const out EffectAppliedData ApplyEffectParameters, out int ArmorMitigation, out int NewShred)
{
	return 0;
}

simulated function bool PlusOneDamage(int Chance)
{
	return false;
}

simulated function bool IsExplosiveDamage() 
{ 
	return false; 
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_ForcePush KnockbackAction;
	local X2Action_CameraFollowUnit CameraFollowAction;

	//`LOG("X2Effect_ForcePush AddX2ActionsForVisualization",, 'X2JediClassWOTC');

	if (EffectApplyResult == 'AA_Success')
	{
		if (ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
		{
			//if (XComGameState_Unit(BuildTrack.StateObject_NewState).IsAlive())
			//{
				CameraFollowAction = X2Action_CameraFollowUnit(class'X2Action_CameraFollowUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
				CameraFollowAction.AbilityToFrame = XComGameStateContext_Ability(VisualizeGameState.GetContext());

				//`LOG("X2Effect_ForcePush Add X2Action_ForcePush",, 'X2JediClassWOTC');
				KnockbackAction = X2Action_ForcePush(class'X2Action_ForcePush'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
				KnockbackAction.ForcePushAnimSequence = ForcePushAnimSequence;
				//KnockbackAction.AnimationDelay = 1.0f + RandRange(0.0f, 1.0f);
				
			//}
		}
		else if (ActionMetadata.StateObject_NewState.IsA('XComGameState_EnvironmentDamage') || ActionMetadata.StateObject_NewState.IsA('XComGameState_Destructible'))
		{
			//This can be added by other effects, so check to see whether this track already has one of these
			//Porter's note: In the shift to WOTC, tracks were removed, as was this comment to "check to whether this track already has" an X2Action_ApplyWeaponDamageToTerrain, yet the check itself is missing
			//if (!`XCOMVISUALIZATIONMGR.TrackHasActionOfType(BuildTrack, class'X2Action_ApplyWeaponDamageToTerrain'))
			//{
				class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());//auto-parent to damage initiating action
			//}
		}
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	
}

defaultproperties
{
	IncrementalStepSize=8.0

	Begin Object Class=X2Condition_UnitProperty Name=UnitPropertyCondition
		ExcludeTurret = true
		ExcludeDead = true
		FailOnNonUnits = true
	End Object

	TargetConditions.Add(UnitPropertyCondition)

	DamageTypes.Add("KnockbackDamage");

	DefaultDamage=100000.0
	DefaultRadius=16.0

	OverrideRagdollFinishTimerSec=-1

	ApplyChanceFn=WasTargetPreviouslyDead
}	