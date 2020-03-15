class X2Effect_JediForcePool_Holocron extends X2Effect_JediForcePool_ByRank;

var int PoolDivisor;

simulated protected function int GetPoolToInit(XComGameState_Unit UnitState)
{
	local int ForceAmount;

	ForceAmount = super.GetPoolToInit(UnitState);

	ForceAmount = ForceAmount / PoolDivisor;

	return ForceAmount;
}