Scriptname zadclibs extends Quest  

; ============================================================================
; ============================================================================
; THIS IS COPY OF ORIGINAL SCRIPT WHICH IS ONLY USED FOR COMPILING UD SCRIPTS 
; ============================================================================
; ============================================================================

zadlibs Property libs Auto
slaUtilScr Property Aroused Auto
zadcAnims Property cAnims Auto
Quest Property zadc_nearbyfurniture Auto
Keyword Property zadc_FurnitureDevice Auto
Keyword Property zadc_FurnitureKit Auto
Key Property zadc_FurnitureKey Auto
Outfit Property zadc_outfit_naked Auto
Package Property zadc_pk_donothing Auto
ReferenceAlias Property UserRef  Auto
FormList Property zadc_CellFurnitureList Auto
Armor Property zadc_NoWaitItem Auto
Armor Property zadc_PrisonerChainsInventory Auto
Armor Property zadc_PrisonerChainsRendered Auto
Actor Property SelectedUser Auto Hidden
Activator Property zadc_BondageChair Auto
Activator Property zadc_BondagePole Auto
Activator Property zadc_cross Auto
Activator Property zadc_gallowspole_overhead Auto
Activator Property zadc_gallowspole_strappado Auto
Activator Property zadc_gallowspole_suspend_hogtie Auto
Activator Property zadc_gallowspole_upside_down Auto
Activator Property zadc_gallowspole_woodenhorse Auto
Activator Property zadc_Pillory Auto
Activator Property zadc_Pillory2 Auto
Activator Property zadc_RestraintPost Auto
Activator Property zadc_ShackleWallIron Auto
Activator Property zadc_TorturePole01 Auto
Activator Property zadc_TorturePole02 Auto
Activator Property zadc_TorturePole03 Auto
Activator Property zadc_TorturePole04 Auto
Activator Property zadc_TorturePole05 Auto
Activator Property zadc_WoodenHorse Auto
Activator Property zadc_xcross Auto
MiscObject Property zadc_kit_bondagechair Auto
MiscObject Property zadc_kit_bondagepost Auto
MiscObject Property zadc_kit_cross Auto
MiscObject Property zadc_kit_gallowspolehogtie Auto
MiscObject Property zadc_kit_gallowspoleoverhead Auto
MiscObject Property zadc_kit_gallowspolestrappado Auto
MiscObject Property zadc_kit_gallowspoleupsidedown Auto
MiscObject Property zadc_kit_gallowspolewoodenhorse Auto
MiscObject Property zadc_kit_pillory Auto
MiscObject Property zadc_kit_pillory2 Auto
MiscObject Property zadc_kit_restraintpost Auto
MiscObject Property zadc_kit_torturepole Auto
MiscObject Property zadc_kit_torturepole2 Auto
MiscObject Property zadc_kit_torturepole3 Auto
MiscObject Property zadc_kit_torturepole4 Auto
MiscObject Property zadc_kit_torturepole5 Auto
MiscObject Property zadc_kit_wallshackle Auto
MiscObject Property zadc_kit_woodenhorse Auto
MiscObject Property zadc_kit_xcross Auto

Bool Function GetIsFurnitureDevice(ObjectReference FurnitureDevice)
EndFunction
Actor Function GetUser(ObjectReference FurnitureDevice)
EndFunction
Bool Function IsValidActor(Actor akActor)
EndFunction
ObjectReference Function GetDevice(Actor act)
EndFunction
Key Function GetDeviceKey(ObjectReference FurnitureDevice)
EndFunction
ObjectReference Function GetClosestFurnitureDevice()
EndFunction
ObjectReference Function GetLinkedDevice(ObjectReference FurnitureDevice, int Position)
EndFunction
FormList Function FindFurnitureDevicesInCell()
EndFunction
Function SetOverridePose(ObjectReference FurnitureDevice, Package pose)
EndFunction
Package Function GetOverridePose(ObjectReference FurnitureDevice)	
EndFunction
Function ClearOverridePose(ObjectReference FurnitureDevice)
EndFunction
Bool Function SetTimedRelease(ObjectReference FurnitureDevice, Int Hours, Bool ResetStartTime = False)
EndFunction
Bool Function LockActor(Actor akActor, ObjectReference FurnitureDevice, Package OverridePose = None)
EndFunction
Bool Function UnlockActor(Actor akActor)
EndFunction
Bool Function PlaySexScene(Actor User, Actor Partner, String AnimationName = "")
EndFunction
Bool Function GetIsTransportable(ObjectReference FurnitureDevice)
EndFunction
Bool Function GetHasBlueprint(ObjectReference FurnitureDevice)
EndFunction
MiscObject Function GetBlueprint(ObjectReference FurnitureDevice)
EndFunction
Bool Function SetIsTransportable(ObjectReference FurnitureDevice)
EndFunction
Bool Function SetBlueprint(ObjectReference FurnitureDevice, MiscObject Blueprint)
EndFunction
ObjectReference Function BobTheBuilder(Activator FurnitureToBuild, ObjectReference WhereToBuild = None)
EndFunction
Event OnInit()
EndEvent
Function InitLibrary()
EndFunction
Event OnRegisterMCMKeys(string eventName, string strArg, float numArg, Form sender)
EndEvent
Function Reinitialize()
EndFunction
Event OnKeyDown(Int KeyCode)
EndEvent
Bool Function GetIsFemale(Actor act)
EndFunction
Function Test()
EndFunction
bool Function IsAnimating(actor akActor)
EndFunction
Function FurnitureAction()
EndFunction
Function CloseMenus()
EndFunction
Function AlignObject(ObjectReference ObjectToAlign, ObjectReference ObjectToAlignWith)
EndFunction
Function MoveObjectByVector(ObjectReference ObjectToMove, ObjectReference ObjectToMoveFrom, Float Distance = 100.0)	
EndFunction
Function StripOutfit(Actor akActor)
EndFunction
Function RestoreOutfit(Actor akActor)
EndFunction
Function ClearDevice(Actor act)
EndFunction
Function StoreDevice(Actor act, ObjectReference obj)
EndFunction
Function StoreBondage(Actor akActor, Keyword[] InvalidDevices, Bool Force = False)
EndFunction
Function RestoreBondage(Actor akActor)	
EndFunction
Function SetNiOverrideOverride(Actor aktarget)
EndFunction
Function ResetNiOverrideOverride(Actor aktarget)
EndFunction