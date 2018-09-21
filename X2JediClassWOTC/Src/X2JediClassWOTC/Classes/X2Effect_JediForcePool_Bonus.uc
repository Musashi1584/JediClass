class X2Effect_JediForcePool_Bonus extends X2Effect_JediForcePool_ByRank;

var int ForceAmount;

simulated protected function int GetPoolToInit(XComGameState_Unit UnitState)
{
	return ForceAmount;
}