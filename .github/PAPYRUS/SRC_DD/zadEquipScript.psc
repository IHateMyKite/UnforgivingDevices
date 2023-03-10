Scriptname zadEquipScript extends ObjectReference  

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadlibs Property libs Auto
slaUtilScr Property Aroused Auto
Message Property zad_DeviceMsgMagic auto Hidden
Message Property zad_DeviceRemoveMsg auto Hidden
Message Property zad_DeviceEscapeMsg Auto Hidden
Bool Property JammedLock = False Auto Hidden
Message Property zad_DeviceMsg auto
Armor Property deviceRendered Auto
Armor Property deviceInventory Auto
Keyword Property zad_DeviousDevice Auto
Quest Property deviceQuest Auto
String Property deviceName Auto
MiscObject Property Lockpick Auto
String[] Property struggleIdles Auto
String[] Property struggleIdlesHob Auto
Key Property deviceKey  Auto
Bool Property DestroyKey = False Auto
Bool Property DestroyOnRemove = False Auto
Int Property NumberOfKeysNeeded = 1 Auto
Float Property LockAccessDifficulty = 0.0 Auto
Float Property UnlockCooldown = 0.0	Auto
Float Property KeyBreakChance = 0.0 Auto
Float Property LockJamChance = 0.0 Auto
Float Property LockShieldTimerMin = 0.0 Auto
Float Property LockShieldTimerMax = 0.0 Auto
Bool Property TimedUnlock = False Auto
Float Property LockTimerMin = 0.0 Auto
Float Property LockTimerMax = 0.0 Auto
Float Property BaseEscapeChance = 0.0 Auto
Float Property LockPickEscapeChance = 0.0 Auto
Form[] Property AllowedLockPicks Auto 
Bool Property AllowLockPick = True Auto
Float Property CutDeviceEscapeChance = 0.0 Auto
Bool Property AllowStandardTools = True Auto
Keyword[] Property AllowedTool Auto
Float Property CatastrophicFailureChance = 0.0 Auto
Float Property EscapeCooldown = 2.0	Auto
Float Property RepairJammedLockChance = 20.0 Auto
Float Property RepairCooldown = 4.0	Auto
Bool Property AllowDifficultyModifier = False Auto
Bool Property DisableLockManipulation = False Auto
Message Property zad_DD_EscapeDeviceMSG Auto
Message Property zad_DD_OnEquipDeviceMSG Auto
Message Property zad_DD_OnNoKeyMSG Auto
Message Property zad_DD_OnNotEnoughKeysMSG	Auto
Message Property zad_DD_OnLeaveItNotWornMSG Auto
Message Property zad_DD_OnLeaveItWornMSG Auto
Message Property zad_DD_KeyBreakMSG Auto
Message Property zad_DD_KeyBreakJamMSG Auto
Message Property zad_DD_UnlockFailJammedMSG	Auto
Message Property zad_DD_RepairLockNotJammedMSG Auto
Message Property zad_DD_RepairLockMSG Auto
Message Property zad_DD_RepairLockSuccessMSG Auto
Message Property zad_DD_RepairLockFailureMSG Auto
Message Property zad_DD_EscapeStruggleMSG Auto
Message Property zad_DD_EscapeStruggleFailureMSG Auto
Message Property zad_DD_EscapeStruggleSuccessMSG Auto
Message Property zad_DD_EscapeLockPickMSG Auto
Message Property zad_DD_EscapeLockPickFailureMSG Auto
Message Property zad_DD_EscapeLockPickSuccessMSG Auto
Message Property zad_DD_EscapeCutMSG Auto
Message Property zad_DD_EscapeCutFailureMSG Auto
Message Property zad_DD_EscapeCutSuccessMSG Auto
Message Property zad_DD_OnPutOnDevice Auto
Message Property zad_DD_OnTimedUnlockMSG Auto
Keyword[] Property EquipConflictingDevices Auto
Keyword[] Property EquipRequiredDevices Auto
Keyword[] Property UnEquipConflictingDevices Auto
Message Property zad_EquipConflictFailMsg auto
Message Property zad_EquipRequiredFailMsg auto
Message Property zad_UnEquipFailMsg auto
Armor Property LinkedDeviceEquipOnUntighten Auto
Armor Property LinkedDeviceEquipOnTighten Auto

Function ProcessLinkedDeviceOnUntighten(Actor akActor)
EndFunction
Function ProcessLinkedDeviceOnTighten(Actor akActor)
EndFunction
Function MultipleItemFailMessage(string offendingItem)
EndFunction
bool Function ShouldEquipSilently(actor akActor)
EndFunction
Event OnEquipped(Actor akActor)
EndEvent
Event OnUnequipped(Actor akActor)
EndEvent
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
endEvent
Function EquipDevice(actor akActor, bool skipMutex=false)
EndFunction
Function RemoveDevice(actor akActor, bool destroyDevice=false, bool skipMutex=false)	
EndFunction
bool Function RemoveDeviceWithKey(actor akActor = none, bool destroyDevice=false)
EndFunction
Function ResetLockShield()
EndFunction
Function SetLockShield()
EndFunction
Bool Function CheckLockShield()
EndFunction
Function SetLockTimer()
EndFunction
Function SyncInventory()
EndFunction
Bool Function CheckLockTimer()
EndFunction
string function GetMessageName(actor akActor)
EndFunction
Bool Function IsEquipDeviceConflict(Actor akActor)
EndFunction
Bool Function IsEquipRequiredDeviceConflict(Actor akActor)
EndFunction
Bool Function IsUnEquipDeviceConflict(Actor akActor)
EndFunction
Bool Function CanMakeUnlockAttempt()
EndFunction
Bool Function CheckLockAccess()
EndFunction
Function NoKeyFailMessage(Actor akActor)
EndFunction
Function DeviceMenu(Int msgChoice = 0)
EndFunction
Function DeviceMenuExt(Int msgChoice)
EndFunction
Function DeviceMenuEquip()
EndFunction
function DeviceMenuRemoveWithKey()
EndFunction
Function DeviceMenuCarryOn()
EndFunction
Function DisplayDifficultyMsg()
EndFunction
Float Function CalculateDifficultyModifier(Bool operator = true)
EndFunction
Float Function CalculateCooldownModifier(Bool operator = true)
EndFunction
Float Function CalculateTimerModifier(float timerMin, float timerMax)
EndFunction
Float Function CalculateKeyModifier(Bool operator = true)
EndFunction
Bool Function CanMakeStruggleEscapeAttempt()
EndFunction
Bool Function CanMakeCutEscapeAttempt()
EndFunction
Bool Function CanMakeLockPickEscapeAttempt()
EndFunction
Int Function Escape(Float Chance)
EndFunction
Bool Function HasValidCuttingTool()
EndFunction
Float Function CalclulateCutSuccess()
EndFunction
Function EscapeAttemptCut()	
EndFunction
Function EscapeAttemptLockPick()
EndFunction
Bool Function HasValidLockPick()
EndFunction
Bool Function DestroyLockPick()
EndFunction
Float Function CalclulateLockPickSuccess()
EndFunction
String[] Function SelectStruggleArray(actor akActor)
EndFunction
Function StruggleScene(actor akActor)
EndFunction
Function EscapeAttemptStruggle()
EndFunction
Float Function CalclulateStruggleSuccess()
EndFunction
Int Function RepairJammedLock(Float Chance)
EndFunction
Function DeviceMenuRemoveWithoutKey()
EndFunction
int Function OnEquippedFilter(actor akActor, bool silent=false)
EndFunction
Function OnEquippedPre(actor akActor, bool silent=false)
EndFunction
Function OnEquippedPost(actor akActor)
EndFunction
int Function OnUnequippedFilter(actor akActor)
EndFunction
Function OnUnequippedPre(Actor akActor)
EndFunction
Function OnUnequippedPost(Actor akActor)
EndFunction
int Function OnContainerChangedFilter(ObjectReference akNewContainer, ObjectReference akOldContainer)
EndFunction
Function OnContainerChangedPre(ObjectReference akNewContainer, ObjectReference akOldContainer)
EndFunction
Function OnContainerChangedPost(ObjectReference akNewContainer, ObjectReference akOldContainer)
EndFunction
Function OnRemoveDevice(actor akActor)
EndFunction
Function StoreEquippedDevice(actor akActor)
EndFunction
Function UnsetStoredDevice(actor akActor)
EndFunction