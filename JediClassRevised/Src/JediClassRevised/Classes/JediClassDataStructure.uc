class JediClassDataStructure extends Object;

struct SyncedAnimation
{
	var name AttackAnimSequence;
	var name DeathAnimSequence;
};


struct UpgradeSetup
{
	var name				UpgradeName;
	var string				ImagePath;
	var string				MeshPath;
	var string				IconPath;
	var int					Tier;
	var int					UpgradeValue;
	var int					AimBonus;
	var int					CritChanceBonus;
	var array<ArtifactCost>	ResourceCosts;
	var array<ArtifactCost>	ArtifactCosts;
	var array<name>			RequiredTechs;
	var WeaponDamageValue	DamageValue;
	var array<name>			BonusAbilities;
};
