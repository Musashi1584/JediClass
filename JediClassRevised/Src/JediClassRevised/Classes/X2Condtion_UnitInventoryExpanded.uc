// like X2Condition_UnitInventory but checks multiple slots
class X2Condtion_UnitInventoryExpanded extends X2Condition;

var() array<EInventorySlot> RelevantSlots;
var() name ExcludeWeaponCategory;
var() name RequireWeaponCategory;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Item RelevantItem;
	local XComGameState_Unit UnitState;
	local X2WeaponTemplate WeaponTemplate;
	local EInventorySlot Slot;
	local bool bFoundRequiredCategory;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	foreach RelevantSlots(Slot)
	{
		RelevantItem = UnitState.GetItemInSlot(Slot);
		if (RelevantItem != none)
			WeaponTemplate = X2WeaponTemplate(RelevantItem.GetMyTemplate());

		if (ExcludeWeaponCategory != '')
		{		
			if (WeaponTemplate != none && WeaponTemplate.WeaponCat == ExcludeWeaponCategory)
				return 'AA_WeaponIncompatible';
		}
		if (RequireWeaponCategory != '')
		{
			if (RelevantItem != none || X2WeaponTemplate(RelevantItem.GetMyTemplate()).WeaponCat == RequireWeaponCategory)
				bFoundRequiredCategory = true;
		}
	}
	if (!bFoundRequiredCategory)
	{
		return 'AA_WeaponIncompatible';
	}

	return 'AA_Success';
}