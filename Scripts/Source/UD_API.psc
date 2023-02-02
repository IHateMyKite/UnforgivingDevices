scriptname UD_API extends Quest

import UnforgivingDevicesMain

;QUESTS
Quest                               Property UD_Quest           auto
Quest                               Property UD_UtilityQuest    auto

;SCRIPTS
UDCustomDeviceMain                  Property UDCDmain       auto
UD_AbadonQuest_script               Property UDAbadonQuest  auto
UD_MCM_script                       Property UDMCM          auto
UD_OrgasmManager                    Property UDOM           auto
UD_OrgasmManager                    Property UDOMPlayer     auto
UD_ExpressionManager                Property UDEM           auto
UD_CustomDevices_NPCSlotsManager    Property UDNPCM         auto
UD_MutexManagerScript               Property UDMM           auto
UD_ModifierManager_Script           Property UDMOM          auto
UD_UserInputScript                  Property UDUI           auto
UD_AnimationManagerScript           Property UDAM           auto
UD_CompatibilityManager_Script      Property UDCM           auto

;zadlibs for simpler access
zadlibs                             property libs           auto 
zadxlibs                            property libsx          auto
zadxlibs2                           property libsx2         auto

UD_MenuChecker Property UDMC Hidden
    UD_MenuChecker Function get()
        return UD_UtilityQuest as UD_MenuChecker
    EndFunction
EndProperty
zadlibs_UDPatch property libsp Hidden
    zadlibs_UDPatch Function get()
        return libs as zadlibs_UDPatch
    EndFunction
EndProperty
zadBoundCombatScript_UDPatch Property BoundCombat Hidden
    zadBoundCombatScript_UDPatch Function get()
        return libs.BoundCombat as zadBoundCombatScript_UDPatch
    EndFunction
EndProperty
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function get()
        return UD_Quest as UnforgivingDevicesMain
    EndFunction
EndProperty
UD_libs Property UDlibs Hidden
    UD_libs Function get()
        return UD_Quest as UD_libs
    EndFunction
EndProperty
UD_LeveledList_Patcher Property UDLLP Hidden
    UD_LeveledList_Patcher Function get()
        return UD_Quest as UD_LeveledList_Patcher
    EndFunction
EndProperty
UD_ParalelProcess Property UDPP Hidden
    UD_ParalelProcess Function get()
        return UD_Quest as UD_ParalelProcess
    EndFunction
EndProperty
UD_RandomRestraintManager Property UDRRM Hidden
    UD_RandomRestraintManager Function get()
        return UD_Quest as UD_RandomRestraintManager
    EndFunction
EndProperty
UDItemManager Property UDItem Hidden
    UDItemManager Function get()
        return UD_Quest as UDItemManager
    EndFunction
EndProperty

;return true if mod is ready
bool Function Ready()
    return UDmain.Ready
EndFunction

;==========================================================================================
;                           GLOBAL UnforgivingDevicesMain FUNCTIONS
;==========================================================================================
;  RET.VAL   |        FUNCTION NAME              |                 ARGUMENTS
;==========================================================================================
;   string   |   IntToBit                        |   (int argInt) ;convert int to bit map string
;   float    |   CalcDistance                    |   (ObjectReference obj1,ObjectReference obj2)
;   bool     |   GActorIsPlayer                  |   (Actor akActor) ;slow. Better use local ActorIsPlayer
;   string   |   GetActorName                    |   (Actor akActor)
;   int      |   codeBit                         |   (int iCodedMap,int iValue,int iSize,int iIndex)
;   int      |   decodeBit                       |   (int iCodedMap,int iSize,int iIndex)
;   float    |   fRange                          |   (float fValue,float fMin,float fMax)
;   int      |   iRange                          |   (int iValue,int iMin,int iMax)
;   string   |   formatString                    |   (string str,int floatPoints)
;   float    |   checkLimit                      |   (float value,float limit)
;   int      |   Round                           |   (float value)
;            |   closeMenu                       |   ()
;            |   closeLockpickMenu               |   ()
;   string   |   getPlugsVibrationStrengthString |   (int strenght)
;   float    |   getMaxActorValue                |   (Actor akActor,string akValue, float perc_part = 1.0)
;   float    |   getCurrentActorValuePerc        |   (Actor akActor,string akValue)
;   float    |   getCurrentActorValuePercCustom  |   (Actor akActor,string akValue,float fBase)
;   bool     |   ModInstalled                    |   (string sModFileName)
;   bool     |   ModInstalledAfterUD             |   (string sModFileName)
;   string   |   MakeDeviceHeader                |   (Actor akActor,Armor invDevice)
;   Int      |   iUnsig                          |   (Int iValue)
;   Float    |   fUnsig                          |   (Int iValue)
;            |   ShowMessageBox                  |   (string strText)
;            |   DCLog                           |   (String msg) ;only use for debugging
;            |   GInfo                           |   (String msg)
;            |   GWarning                        |   (String msg)
;            |   GError                          |   (String msg) ;global error function. Ignore safety in sake of usebality
;==========================================================================================

;==========================================================================================
;                                  UTILITY FUNCTIONS
;==========================================================================================

;return true if logging is enabled. Use this function first beffore calling Log function in case that Info is called many times in row!!!!
;Otherwise performance can be greatly affected
;Example
;Function fun()
;   if UDAPI.TraceAllowed()
;       UDAPI.Log("fun called!",2)
;   endif
;   //do something//
;EndFunction
bool    Function TraceAllowed()
    return UDmain.TraceAllowed()
EndFunction

        Function Log(String asMsg, int aiLevel = 1)
    UDmain.Log(asMsg,aiLevel)
EndFunction

;Console Log. Print Msg to console
        Function CLog(String asMsg)
    UDmain.CLog(asMsg)
EndFunction

;print message for player (notification)
        Function Print(String asMsg,int aiLevel = 1,bool abLog = false)
    UDmain.Print(asMsg,aiLevel,abLog)
EndFunction

;print error message in to console and papyrus log
        Function    Error(String asMsg)
    UDmain.Error(asMsg)
EndFunction

;print warning message in to console and papyrus log
;can be turned off with MCM
        Function    Warning(String asMsg)
    UDmain.Warning(asMsg)
EndFunction

;print info message in to console and papyrus log
;is not affected by MCM setting. 
;Should be used rarely only for specifically informing user through console
        Function    Info(String asMsg)
    UDmain.Info(asMsg)
EndFunction

;returns true fs actor is player
bool    Function    ActorIsPlayer(Actor akActor)
    return akActor == UDmain.Player
EndFunction

;return ture if actor is follower
bool    Function    ActorIsFollower(Actor akActor)
    return UDmain.ActorIsFollower(akActor)
EndFunction

;return ture if actor is valid for mod (can wear devious devices)
bool    Function    ActorIsValidForUD(Actor akActor)
    return UDmain.ActorIsValidForUD(akActor)
EndFunction

;return true if actor is in hearing range from player
;hearing range is specified in MCM
;can be used in combination with Print function, so message is only show if actor is close to player
bool    Function    ActorInCloseRange(Actor akActor)
    return UDmain.ActorInCloseRange(akActor)
EndFunction


;==========================================================================================
;                                  MENU FUNCTIONS
;==========================================================================================
;very fast functions for checking if menu is open
;have little lag because it works by checking events (still didn't manage to get issue)
;==========================================================================================
;  RET.VAL   |        FUNCTION NAME                 |                 ARGUMENTS
;==========================================================================================
;   Bool     |   IsMenuOpen                         |   ()
;   Bool     |   IsMenuOpenID                       |   (int aiID)
;   Bool     |   IsContainerMenuOpen                |   ()
;   Bool     |   IsLockpickingMenuOpen              |   ()
;==========================================================================================

;return true if any registered menu is open
Bool    Function    IsMenuOpen()
    return UDmain.IsMenuOpen()
EndFunction
;======================================;
;           Menu ID table              ;
;======================================;
;   aiID    |||         MENU           ;
;--------------------------------------;
;    00     =     ContainerMenu        ;
;    01     =     Lockpicking Menu     ;
;    02     =     InventoryMenu        ;
;    03     =     Journal Menu         ;
;    04     =     Crafting Menu        ;
;    05     =     Dialogue Menu        ;
;    06     =     FavoritesMenu        ;
;    07     =     GiftMenu             ;
;    08     =     Main Menu            ;
;    09     =     Loading Menu         ;
;    10     =     Book Menu            ;
;    11     =     MagicMenu            ;
;    12     =     MapMenu              ;
;    13     =     MessageBoxMenu       ;
;    14     =     RaceSex Menu         ;
;    15     =     Sleep/Wait Menu      ;
;    16     =     StatsMenu            ;
;    17     =     Tutorial Menu        ;
;    18     =     TweenMenu            ;
;    19     =     Console              ;
;    20     =     BarterMenu           ;
;======================================;
;returns true if menu with aiID is open
Bool    Function    IsMenuOpenID(int aiID)
    return UDmain.IsMenuOpenID(aiID)
EndFunction
;return true if Container menu is open
Bool    Function    IsContainerMenuOpen()
    return UDmain.IsContainerMenuOpen()
EndFunction
;return true if Lockpick menu is open
Bool    Function    IsLockpickingMenuOpen()
    return UDmain.IsLockpickingMenuOpen()
EndFunction

;==========================================================================================
;                                  NPC SLOT FUNCTIONS
;==========================================================================================
;NPC Slot Functions
;mod = 0 => AND     (device need all provided keyword)
;mod = 1 => OR     (device need one provided keyword)
;
;  UD_CustomDevice_RenderScript   getDeviceByInventory(Armor deviceInventory)       ;returns first device which have connected corresponding Inventory Device
;  UD_CustomDevice_RenderScript   getDeviceByRender(Armor deviceRendered)   ;returns first device which have connected corresponding Render Device
;  UD_CustomDevice_RenderScript   getHeavyBondageDevice()                   ;returns heavy bondage (hand restrain) device
;  UD_CustomDevice_RenderScript   getFirstDeviceByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)   ;returs first device by keywords
;  UD_CustomDevice_RenderScript   getLastDeviceByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)    ;returns last device containing keyword
;  UD_CustomDevice_RenderScript   getDeviceByKeyword(keyword akKeyword)     ;returs first device by keywords
;  UD_CustomDevice_RenderScript[] getAllDevicesByKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)                                        ;returns array of all device containing keyword in their render device
;  UD_CustomDevice_RenderScript[] getAllActivableDevicesByKeyword(bool bCheckCondition, keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)         ;returns array of all device containing keyword in their render device
;  int                            getNumberOfDevicesWithKeyword(keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)                                 ;returns number of all device containing keyword in their render device
;  int                            getNumberOfActivableDevicesWithKeyword(bool bCheckCondition, keyword kw1,keyword kw2 = none,keyword kw3 = none, int mod = 0)  ;returns number of all device containing keyword in their render device
;  int                            getActiveDevicesNum()                     ;returns number of devices that can be activated
;  UD_CustomDevice_RenderScript[] getActiveDevices()                        ;returns all device that can be activated
;                                 TurnOffAllVibrators()
;  int                            getVibratorNum()                          ;returns number of vibrators
;  int                            getActivableVibratorNum()                 ;returns number of vibrators
;  int                            getOffVibratorNum()                       ;returns number of turned off vibrators (and the ones which can be turned on)
;  UD_CustomDevice_RenderScript[] getVibrators()                            ;returns all vibrators
;  UD_CustomDevice_RenderScript[] getOffVibrators()                         ;returns all turned off vibrators
;  UD_CustomDevice_RenderScript[] getActivableVibrators()                   ;returns all turned activable vibrators

;return true if actor is registered
bool    Function    isRegistered(Actor akActor)
    return UDNPCM.isRegistered(akActor)
EndFunction

;register passed actor in to free NPC slot
;abMessage - toggle message that show for user, saying that NPC was registered and number of slot
;returns true if actor was succefully registered
bool    Function    RegisterNPC(Actor akActor,bool abMessage = false)
    return UDNPCM.RegisterNPC(akActor,abMessage)
EndFunction

;unregister passed actor
;abMessage - toggle message that show for user, saying that NPC was unregistered and number of slot
;returns true if actor was succefully unregistered
bool    Function    UnregisterNPC(Actor akActor,bool abMessage = false)
    return UDNPCM.UnregisterNPC(akActor,abMessage)
EndFunction

;return player NPC slot
UD_CustomDevice_NPCSlot     Function    getPlayerSlot()
    return UDNPCM.getPlayerSlot()
EndFunction

;return specific NPC slot
;in case that function fails, it returns none
UD_CustomDevice_NPCSlot     Function    getNPCSlotByActor(Actor akActor)
    return UDNPCM.getNPCSlotByActor(akActor)
EndFunction

;return specific NPC slot by actor name
;asName - name of actor
;in case that function fails, it returns none
UD_CustomDevice_NPCSlot     Function    getNPCSlotByActorName(string asName)
    return UDNPCM.getNPCSlotByActorName(asName)
EndFunction

;returns number of free NPC slots
int     Function    GetNumberOfFreeNPCSlots()
    return UDNPCM.numberOfFreeSlots()
EndFunction

;==========================================================================================
;                               ORGASM/AROUSAL FUNCTIONS
;==========================================================================================
;  RET.VAL |        FUNCTION NAME         |                 ARGUMENTS
;==========================================================================================
;          | UpdateBaseOrgasmVals         |  (Actor akActor, int aiDuration, float afOrgasmRate, float afForcing = 0.0, float afArousalRate = 0.0)
;   int    | GetOrgasmExhaustion          |  (Actor akActor)
;   Float  | getOrgasmRate                |  (Actor akActor, Int aiMode = 0)
;   Int    | GetArousal                   |  (Actor akActor)
;   Float  | GetArousalRate               |  (Actor akActor,int abMode = 0)
;   Float  | GetAntiOrgasmRate            |  (Actor akActor)
;   Float  | GetActorOrgasmForcing        |  (Actor akActor)
;   Float  | GetOrgasmRateMultiplier      |  (Actor akActor)
;   Float  | GetOrgasmResist              |  (Actor akActor, Int aiMode = 0)
;   Float  | GetOrgasmResistMultiplier    |  (Actor akActor)
;   Float  | GetArousalRateMultiplier     |  (Actor akActor)
;   Float  | GetOrgasmProgress            |  (Actor akActor)
;   Float  | GetOrgasmProgressPerc        |  (Actor akActor)
;   Float  | GetActorOrgasmCapacity       |  (Actor akActor)
;   Float  | UpdateOrgasmRate             |  (Actor akActor ,float afOrgasmRate,float afOrgasmForcing)
;   Float  | UpdateArousalRate            |  (Actor akActor ,float afArousalRate)
;   Float  | UpdateOrgasmRateMultiplier   |  (Actor akActor ,float afOrgasmRateMultiplier)
;   Float  | UpdateOrgasmResist           |  (Actor akActor ,float afOrgasmResist)
;   Float  | UpdateOrgasmResistMultiplie  |  (Actor akActor ,float afOrgasmResistMultiplier)
;   Float  | UpdateArousalRateMultiplier  |  (Actor akActor ,Float afArousalRateMultiplier)
;   Int    | UpdatetActorOrgasmCapacity   |  (Actor akActor,Int aiValue)
;==========================================================================================

;           Orgasm(Actor akActor,int aiDuration,int aiArousalDecrease = 75,int aiForce = 0, bool abBlocking = true)
;increase actor orgasm rate for certain duration. Values will be returned to previous values once effect end
;aiDuration - duration of effect
;afOrgasmRate - by how much is orgasm rate increased while effect is on
;afForcing - how much is orgasm forcing increased (0.0 = masturbation / 1.0> = forced orgasm) while effect is on
;afArousalRate - how much is arousal rate increased while effect is on
;WARNING: Both afOrgasmRate and afForcing are recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
        Function    UpdateBaseOrgasmVals(Actor akActor, int aiDuration, float afOrgasmRate, float afForcing = 0.0, float afArousalRate = 0.0)
    UDmain.GetUDOM(akActor).UpdateBaseOrgasmVals(akActor, aiDuration, afOrgasmRate, afForcing, afArousalRate)
EndFunction

;return ammount of orgasm exhaustions actor currently have
Int     Function    GetOrgasmExhaustion(Actor akActor)
    return UDmain.GetUDOM(akActor).GetOrgasmExhaustion(akActor)
EndFunction

;return current orgasm rate of actor.
;actual orgasm rate can be calculated as OrgasmRate - AntiOrgasmRate
;aiMode -   0 -> returns value affected´ by modifier
;           1 -> returns raw value
Float   Function    GetOrgasmRate(Actor akActor, Int aiMode = 0)
    if aiMode == 0
        return UDmain.GetUDOM(akActor).getActorAfterMultOrgasmRate(akActor)
    else
        return UDmain.GetUDOM(akActor).getActorOrgasmRate(akActor)
    endif
EndFunction

;return current arousal of actor
Int     Function    GetArousal(Actor akActor)
    return UDmain.GetUDOM(akActor).getArousal(akActor)
EndFunction

;return current arousal rate of actor.
;aiMode -   0 -> returns value affected by modifier
;           1 -> returns raw value
Float   Function    GetArousalRate(Actor akActor,int abMode = 0)
    if abMode == 0
        return UDmain.GetUDOM(akActor).getArousalRateM(akActor)
    else
        return UDmain.GetUDOM(akActor).getArousalRate(akActor)
    endif
EndFunction

;return current anti orgasm rate of actor. This value is already affected by modifiers
;this value is affected by arousal
;actual orgasm rate can be calculated as OrgasmRate - AntiOrgasmRate
Float   Function    GetAntiOrgasmRate(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorAfterMultAntiOrgasmRate(akActor)
EndFunction

;returns current orgasm forcing of actor
Float   Function    GetActorOrgasmForcing(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmForcing(akActor)
EndFunction

;return current orgasm rate multiplier of actor
Float   Function    GetOrgasmRateMultiplier(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmRateMultiplier(akActor)
EndFunction

;return current orgasm resistence. This value is already affected by orgasm resistence multiplier
;aiMode -   0 -> returns value affected by modifier
;           1 -> returns raw value
Float   Function    GetOrgasmResist(Actor akActor, Int aiMode = 0)
    if aiMode == 0
        return UDmain.GetUDOM(akActor).getActorOrgasmResistM(akActor)
    else
        return UDmain.GetUDOM(akActor).getActorOrgasmResist(akActor)
    endif
EndFunction

;return current orgasm resist multiplier of actor
Float   Function    GetOrgasmResistMultiplier(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmResistMultiplier(akActor)
EndFunction

;return current arousal rate multiplier of actor
Float   Function    GetArousalRateMultiplier(Actor akActor)
    return UDmain.GetUDOM(akActor).getArousalRateMultiplier(akActor)
EndFunction

;return current orgasm progress of the actor
Float   Function    GetOrgasmProgress(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmProgress(akActor)
EndFunction

;return relative orgasm progress of the actor
;range 0.0 - 1.0
Float   Function    GetOrgasmProgressPerc(Actor akActor)
    return UDmain.GetUDOM(akActor).getOrgasmProgressPerc(akActor)
EndFunction

;return current orgasm capacity of actor
Float   Function    GetActorOrgasmCapacity(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmCapacity(akActor)
EndFunction

;updates orgasm rate and orgasm forcing by passed value. The value will be not changed back. Allways change the value back to original values !!!!!
;returns new value
;WARNING: Both afOrgasmRate and afForcing are recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
Float   Function    UpdateOrgasmRate(Actor akActor ,float afOrgasmRate,float afOrgasmForcing)
    return UDmain.GetUDOM(akActor).UpdateOrgasmRate(akActor,afOrgasmRate,afOrgasmForcing)
EndFunction

;updates arousal rate. The value will be not changed back. Allways change the value back to original values !!!!!
;WARNING: afArousalRate is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
Float   Function    UpdateArousalRate(Actor akActor ,float afArousalRate)
    return UDmain.GetUDOM(akActor).UpdateArousalRate(akActor, afArousalRate)
EndFunction

;updates orgasm rate multiplier. The value will be not changed back. Allways change the value back to original values !!!!!
;WARNING: Both afOrgasmRateMultiplier is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
Float   Function    UpdateOrgasmRateMultiplier(Actor akActor ,float afOrgasmRateMultiplier)
    return UDmain.GetUDOM(akActor).UpdateOrgasmRateMultiplier(akActor, afOrgasmRateMultiplier)
EndFunction

;updates orgasm rate resistence. The value will be not changed back. Allways change the value back to original values !!!!!
;WARNING: afOrgasmResist is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
Float   Function    UpdateOrgasmResist(Actor akActor ,float afOrgasmResist)
    return UDmain.GetUDOM(akActor).UpdateOrgasmResist(akActor ,afOrgasmResist)
EndFunction

;updates orgasm rate resistence multiplier. The value will be not changed back. Allways change the value back to original values !!!!!
;WARNING: afOrgasmResistMultiplier is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
Float   Function    UpdateOrgasmResistMultiplier(Actor akActor ,float afOrgasmResistMultiplier)
    return UDmain.GetUDOM(akActor).UpdateOrgasmResistMultiplier(akActor, afOrgasmResistMultiplier)
EndFunction

;updates arousal rate resistence multiplier. The value will be not changed back. Allways change the value back to original values !!!!!
;WARNING: afArousalRateMultiplier is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
Float   Function    UpdateArousalRateMultiplier(Actor akActor ,Float afArousalRateMultiplier)
    return UDmain.GetUDOM(akActor).UpdateArousalRateMultiplier(akActor, afArousalRateMultiplier)
EndFunction

;updates orgasm capacity. The value will be not changed back. Allways change the value back to original values !!!!!
;Returns updated value
Int     Function    UpdatetActorOrgasmCapacity(Actor akActor,Int aiValue)
    return UDmain.GetUDOM(akActor).UpdatetActorOrgasmCapacity(akActor, aiValue)
EndFunction

;make actor orgasm
;aiDuration - duration of orgasm. !WARNING! - some animations might look weird if duration is different then 20 seconds
;iArousalDecrease - how much is arousal decreased on orgasm
;iForce - orgasm state: 0 -> self caused orgasm
;                       2 -> forced orgasm
;                       1 -> something between
;abBlocking - if true, function will be blocked untill the orgasm function starts
        Function    Orgasm(Actor akActor,int aiDuration,int aiArousalDecrease = 75,int aiForce = 0, bool abBlocking = true)
    UDmain.GetUDOM(akActor).startOrgasm(akActor,aiDuration,aiArousalDecrease,aiForce, abBlocking)
EndFUnction

;==========================================================================================
;                                     INPUT FUNCTIONS
;==========================================================================================
;open text input for user and return string
string  Function    GetUserTextInput()
    return UDmain.GetUserTextInput()
EndFunction

;open list of options and return selected option
Int     Function    GetUserListInput(string[] apList)
    return UDmain.GetUserListInput(apList)
EndFunction