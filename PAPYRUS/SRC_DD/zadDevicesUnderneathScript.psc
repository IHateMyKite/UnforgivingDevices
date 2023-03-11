scriptname zadDevicesUnderneathScript extends Quest

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadLibs Property libs Auto
Armor Property zad_DeviceHider Auto
ArmorAddon Property zad_DeviceHiderAA Auto

int[] Property SlotMaskFilters Auto
int[] Property SlotMaskUsage Auto
int[] Property ShiftCache Auto

int Property SlotMask Auto ; Avoid repeated lookups

Function SetDefaultSlotMasks()
EndFunction
Function HideEquipment(int slot1, int slot2)
EndFunction
Function Maintenance()
EndFunction
Function ApplySlotmask(Actor akActor)
EndFunction
Int Function FilterMask(Actor akActor, Int aiSloMask)
EndFunction
Bool Function IsDevice(Armor akArmor)
EndFunction
Function UpdateSlotmask(int index, int slot, bool equipOrUnequip)
EndFunction
Function RebuildSlotmask(actor akActor)
EndFunction
Function StartHiderMutex()
EndFunction
Function EndHiderMutex()
EndFunction
Function UpdateDeviceHiderSlot()
EndFunction