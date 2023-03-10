Scriptname zadx_BondageMittensEffectScript extends activemagiceffect

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadlibs Property libs  Auto
Armor Property zad_DeviceHider Auto

bool function hasAnyWeaponEquipped(actor a)
EndFunction
function stripweapons(actor a, bool unequiponly = true)
endfunction
bool Function isDeviousDevice(Form device)
EndFunction
bool Function isValidItem(Form item)
EndFunction
Event OnEffectStart(Actor akTarget, Actor akCaster)
EndEvent
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
EndEvent
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
EndEvent