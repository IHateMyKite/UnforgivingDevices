;   File: UD_API
;   This is mod interface for Unforgiving Devices. 
;   It should be prefered to use these functions instead of functions from modules, as it will be backward compatible
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

;/  Function: Ready

    Returns:

        True if mod is fully loaded and ready
/;
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


;/  Function: TraceAllowed

    Allways use this function first beffore calling Log function!
    
    Otherwise performance can be greatly affected for users which don't use Papyrus logging

    Example:
    --- Code
    Function fun()
       if UDAPI.TraceAllowed()
           UDAPI.Log("fun called!",2)
       endif
       ; ||              ||
       ; VV FUNCTINALITY VV
    EndFunction
    ---

    Returns:

        True if logging is enabled
/;
bool    Function TraceAllowed()
    return UDmain.TraceAllowed()
EndFunction

;/  Function: Log

    Prints one line of text to Papyrus log
    
    Note that users needs to have Papyrus logging enabled first

    Parameters:

        asMsg   - Message which should be printed to Papyrus log.
        aiLevel - (optional) Level of imporatance for message. Is used for filtering messages based on MCM setting. 1 means most important message and 5 least important message
/;
        Function Log(String asMsg, int aiLevel = 1)
    UDmain.Log(asMsg,aiLevel)
EndFunction


;/  Function: CLog

    Prints one line of text to console. User first needs to have ConsoleUtil installed!
    
    Parameters:

        asMsg   - Message which should be printed to Console
/;
        Function CLog(String asMsg)
    UDmain.CLog(asMsg)
EndFunction

;/  Function: Print

    Prints one line of text to skyrim text output (left upper corner)
    
    Parameters:

        asMsg   - Message which should be printed to Console
        aiLevel - (optional) Level of imporatance for message. Is used for filtering messages based on MCM setting. 1 means most important message and 5 least important message
        abLog   - (optional) Set to true if the message should be also added to Papyrus log
/;
        Function Print(String asMsg,int aiLevel = 1,bool abLog = false)
    UDmain.Print(asMsg,aiLevel,abLog)
EndFunction

;/  Function: Error

    Prints one line of error message to console and Papyrus log
    
    Parameters:

        asMsg   - Error message information
/;
        Function    Error(String asMsg)
    UDmain.Error(asMsg)
EndFunction


;/  Function: Warning

    Prints one line of warning message to console and Papyrus log
    
    Note: This feature can toggled off in MCM
    
    Parameters:

        asMsg   - Error message information
/;
        Function    Warning(String asMsg)
    UDmain.Warning(asMsg)
EndFunction


;/  Function: Info

    Prints one line of info message to console and Papyrus log
    
    This function is intended to be only ussed for debugging
    
    Parameters:

        asMsg   - Info message information
/;
        Function    Info(String asMsg)
    UDmain.Info(asMsg)
EndFunction


;/  Function: ActorIsPlayer

    Parameters:

        akActor   - Actor which will be checked

    Returns:

        True if passed akActor is player
/;
bool    Function    ActorIsPlayer(Actor akActor)
    return akActor == UDmain.Player
EndFunction

;/  Function: ActorIsFollower

    Parameters:

        akActor   - Actor which will be checked

    Returns:

        True if passed akActor is follower
/;
bool    Function    ActorIsFollower(Actor akActor)
    return UDmain.ActorIsFollower(akActor)
EndFunction

;/  Function: ActorIsValidForUD
    This function check if passed actor is valid for Unforgiving Devices (wearing devices, orgasm system, etc...).
    
    Following conditions have to be meet for actor to be valid

    - Actor is not child
    - Actors race is playable
    - Actor is not dead
    - Actor is not male IF For Him is not installed

    Parameters:

        akActor   - Actor which will be checked

    Returns:

        True if passed akActor is valid
/;
bool    Function    ActorIsValidForUD(Actor akActor)
    return UDmain.ActorIsValidForUD(akActor)
EndFunction

;/  Function: ActorInCloseRange
    This function check if passed actor is close to Player
    
    Checked range depends on MCM setting Hearing range

    Parameters:

        akActor   - Actor which will be checked if they are in close range of Player

    Returns:

        True if passed akActor is close to player
/;
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

;/  Function: IsMenuOpen

    This function check if any menu is open. It is much faster then its UI couterpart

    Returns:

        True if any menu is open
/;
Bool    Function    IsMenuOpen()
    return UDmain.IsMenuOpen()
EndFunction

;/  Function: IsMenuOpenID

    This function check if specific menu is open

    Parameters:

        aiID   - ID of menu which should be checked. See <Menus ID>

    Returns:

        True if menu with aiID is open
/;
Bool    Function    IsMenuOpenID(int aiID)
    return UDmain.IsMenuOpenID(aiID)
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

;/  Function: isRegistered

    This function checks if passed actor is registered in any NPC slot on any NPC manager or NPC static slot

    Parameters:

        akActor   - Actor which should be checked

    Returns:

        True if passed actor is registered
/;
bool    Function    isRegistered(Actor akActor)
    return UDNPCM.isRegistered(akActor)
EndFunction


;/  Function: RegisterNPC

    Registers passed actor to first free NPC slot on Generic NPC manager

    Parameters:

        akActor   - Actor which should be registered
        abMessage - (optional) Message will be printed to left upper corner if enabled
    Returns:

        True if actor was succefully registered
/;
bool    Function    RegisterNPC(Actor akActor,bool abMessage = false)
    return UDNPCM.RegisterNPC(akActor,abMessage)
EndFunction

;/  Function: UnregisterNPC

    Registers passed actor to first free NPC slot on Generic NPC manager

    Parameters:

        akActor   - Actor which should be unregistered
        abMessage - (optional) Message will be printed to left upper corner if enabled
    Returns:

        True if actor was succefully unregistered
/;
bool    Function    UnregisterNPC(Actor akActor,bool abMessage = false)
    return UDNPCM.UnregisterNPC(akActor,abMessage)
EndFunction

;/  Function: getPlayerSlot

    Returns:

        Player NPC slot
/;
UD_CustomDevice_NPCSlot     Function    getPlayerSlot()
    return UDNPCM.getPlayerSlot()
EndFunction

;/  Function: getNPCSlotByActor

    Returns actors NPC slot

    Parameters:

        akActor   - Actor whose slot should be returned

    Returns:

        Slot of passed actor, or none in case of issue
/;
UD_CustomDevice_NPCSlot     Function    getNPCSlotByActor(Actor akActor)
    return UDNPCM.getNPCSlotByActor(akActor)
EndFunction


;/  Function: getNPCSlotByActorName

    Returns NPC slot of actor by the name

    Parameters:

        asName   - Actors name whose slot should be returned

    Returns:

        Slot of passed actors name, or none in case of issue
/;
UD_CustomDevice_NPCSlot     Function    getNPCSlotByActorName(string asName)
    return UDNPCM.getNPCSlotByActorName(asName)
EndFunction


;/  Function: GetNumberOfFreeNPCSlots

    Returns number of free npc slots on UD NPC manager

    Returns:

        Number of free slots
/;
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

;/  Function: UpdateBaseOrgasmVals

    Updates actor orgasm values of set amount of time.
    This function is not blocking.
    
    WARNING: Both afOrgasmRate and afForcing are recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
    
    Parameters:
        akActor         - Actors whose orgasm values should be updated
        aiDuration      - duration of effect
        afOrgasmRate    - by how much is orgasm rate increased while effect is on
        afForcing       - how much is orgasm forcing increased (0.0 = masturbation / 1.0> = forced orgasm) while effect is on
        afArousalRate   - how much is arousal rate increased while effect is on
/;
        Function    UpdateBaseOrgasmVals(Actor akActor, int aiDuration, float afOrgasmRate, float afForcing = 0.0, float afArousalRate = 0.0)
    UDmain.GetUDOM(akActor).UpdateBaseOrgasmVals(akActor, aiDuration, afOrgasmRate, afForcing, afArousalRate)
EndFunction

;/  Function: GetOrgasmExhaustion

    Parameters:
        akActor - Actors whose value will be returned
        
    Returns:
    
        Returns actors number of current orgasm exhaustions
/;
Int     Function    GetOrgasmExhaustion(Actor akActor)
    return UDmain.GetUDOM(akActor).GetOrgasmExhaustion(akActor)
EndFunction

;/  Function: GetOrgasmRate

    Note: Actual orgasm rate can be calculated as OrgasmRate - AntiOrgasmRate

    Parameters:
        akActor - Actors whose value will be returned
        aiMode  - 0 = returns value affected by modifier. 1 = returns raw value

    Returns:

        Return current orgasm rate of actor
/;
Float   Function    GetOrgasmRate(Actor akActor, Int aiMode = 0)
    if aiMode == 0
        return UDmain.GetUDOM(akActor).getActorAfterMultOrgasmRate(akActor)
    else
        return UDmain.GetUDOM(akActor).getActorOrgasmRate(akActor)
    endif
EndFunction


;/  Function: GetArousal

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors current arousal
/;
Int     Function    GetArousal(Actor akActor)
    return UDmain.GetUDOM(akActor).getArousal(akActor)
EndFunction

;/  Function: GetArousalRate

    Parameters:
        akActor - Actors whose value will be returned
        aiMode  - 0 = returns value affected by modifier. 1 = returns raw value

    Returns:

        Return actors current arousal rate
/;
Float   Function    GetArousalRate(Actor akActor,int abMode = 0)
    if abMode == 0
        return UDmain.GetUDOM(akActor).getArousalRateM(akActor)
    else
        return UDmain.GetUDOM(akActor).getArousalRate(akActor)
    endif
EndFunction

;/  Function: GetAntiOrgasmRate

    Returns anti orgasm rate. This value is used in orgasm calculation in following way
    
    ---code
        OrgasmRate - AntiOrgasmRate
    ---

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors current anti arousal rate
/;
Float   Function    GetAntiOrgasmRate(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorAfterMultAntiOrgasmRate(akActor)
EndFunction

;/  Function: GetActorOrgasmForcing

    Orgasm forcing value specify if actor is masturbating or being forced to orgasm

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors orgasm forcing
/;
Float   Function    GetActorOrgasmForcing(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmForcing(akActor)
EndFunction

;/  Function: GetOrgasmRateMultiplier

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors orgasm rate multiplier
/;
Float   Function    GetOrgasmRateMultiplier(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmRateMultiplier(akActor)
EndFunction

;/  Function: GetOrgasmResist

    Parameters:
        akActor - Actors whose value will be returned
        aiMode  - 0 = returns value affected by modifier. 1 = returns raw value

    Returns:

        Return actors current orgasm resistence
/;
Float   Function    GetOrgasmResist(Actor akActor, Int aiMode = 0)
    if aiMode == 0
        return UDmain.GetUDOM(akActor).getActorOrgasmResistM(akActor)
    else
        return UDmain.GetUDOM(akActor).getActorOrgasmResist(akActor)
    endif
EndFunction

;/  Function: GetOrgasmResistMultiplier

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors current orgasm resistence multiplier
/;
Float   Function    GetOrgasmResistMultiplier(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmResistMultiplier(akActor)
EndFunction

;/  Function: GetArousalRateMultiplier

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors current arousal rate multiplier
/;
Float   Function    GetArousalRateMultiplier(Actor akActor)
    return UDmain.GetUDOM(akActor).getArousalRateMultiplier(akActor)
EndFunction

;/  Function: GetOrgasmProgress

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors current orgasm progress
/;
Float   Function    GetOrgasmProgress(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmProgress(akActor)
EndFunction

;/  Function: GetOrgasmProgressPerc

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors current orgasm progress as relative value [0.0-1.0]
/;
Float   Function    GetOrgasmProgressPerc(Actor akActor)
    return UDmain.GetUDOM(akActor).getOrgasmProgressPerc(akActor)
EndFunction

;/  Function: GetActorOrgasmCapacity

    Parameters:
        akActor - Actors whose value will be returned

    Returns:

        Return actors orgasm capacity
/;
Float   Function    GetActorOrgasmCapacity(Actor akActor)
    return UDmain.GetUDOM(akActor).getActorOrgasmCapacity(akActor)
EndFunction

;/  Function: UpdateOrgasmRate

    NOTE: The value will be not changed back. Allways change the value back to original values !!!!!
    WARNING: Both afOrgasmRate and afForcing are recalculated for storage. Because of that, precision is 0.01. All smaller information will be lost.
    
    Parameters:
        akActor         - Actors whose value will be updated
        afOrgasmRate    - By how much should be orgasm rate updated. Can be both positive and negative
        afOrgasmForcing - By how much should be orgasm forcing updated. Can be both positive and negative

    Returns:

        Return actors new orgasm rate after update
/;
Float   Function    UpdateOrgasmRate(Actor akActor ,float afOrgasmRate,float afOrgasmForcing)
    return UDmain.GetUDOM(akActor).UpdateOrgasmRate(akActor,afOrgasmRate,afOrgasmForcing)
EndFunction

;/  Function: UpdateArousalRate

    NOTE: The value will be not changed back. Allways change the value back to original values !!!!!
    WARNING: afArousalRate is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
    
    Parameters:
        akActor         - Actors whose value will be updated
        afArousalRate   - By how much should be arousal rate updated. Can be both positive and negative

    Returns:

        Return actors new arousal rate after update
/;
Float   Function    UpdateArousalRate(Actor akActor ,float afArousalRate)
    return UDmain.GetUDOM(akActor).UpdateArousalRate(akActor, afArousalRate)
EndFunction

;/  Function: UpdateOrgasmRateMultiplier

    NOTE: The value will be not changed back. Allways change the value back to original values !!!!!
    WARNING: afOrgasmRateMultiplier is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
    
    Parameters:
        akActor                     - Actors whose value will be updated
        afOrgasmRateMultiplier      - By how much should be orgasm rate multiplier updated. Can be both positive and negative

    Returns:

        Return actors new orgasm rate multiplier after update
/;
Float   Function    UpdateOrgasmRateMultiplier(Actor akActor ,float afOrgasmRateMultiplier)
    return UDmain.GetUDOM(akActor).UpdateOrgasmRateMultiplier(akActor, afOrgasmRateMultiplier)
EndFunction

;updates orgasm rate resistence. The value will be not changed back. Allways change the value back to original values !!!!!
;WARNING: afOrgasmResist is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.

;/  Function: UpdateOrgasmResist

    NOTE: The value will be not changed back. Allways change the value back to original values !!!!!
    WARNING: afOrgasmResist is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
    
    Parameters:
        akActor         - Actors whose value will be updated
        afOrgasmResist  - By how much should be orgasm resistence updated. Can be both positive and negative

    Returns:

        Return actors new orgasm resistence after update
/;
Float   Function    UpdateOrgasmResist(Actor akActor ,float afOrgasmResist)
    return UDmain.GetUDOM(akActor).UpdateOrgasmResist(akActor ,afOrgasmResist)
EndFunction

;/  Function: UpdateOrgasmResistMultiplier

    NOTE: The value will be not changed back. Allways change the value back to original values !!!!!
    WARNING: afOrgasmResistMultiplier is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
    
    Parameters:
        akActor                     - Actors whose value will be updated
        afOrgasmResistMultiplier    - By how much should be orgasm resistence multiplier updated. Can be both positive and negative

    Returns:

        Return actors new orgasm resistence multiplier after update
/;
Float   Function    UpdateOrgasmResistMultiplier(Actor akActor ,float afOrgasmResistMultiplier)
    return UDmain.GetUDOM(akActor).UpdateOrgasmResistMultiplier(akActor, afOrgasmResistMultiplier)
EndFunction

;/  Function: UpdateArousalRateMultiplier

    NOTE: The value will be not changed back. Allways change the value back to original values !!!!!
    WARNING: afArousalRateMultiplier is recalculated for storage. Because of that, precision is 0.01.All smaller information will be lost.
    
    Parameters:
        akActor                     - Actors whose value will be updated
        afArousalRateMultiplier     - By how much should be arousal rate multiplier updated. Can be both positive and negative

    Returns:

        Return actors new arousal rate multiplier after update
/;
Float   Function    UpdateArousalRateMultiplier(Actor akActor ,Float afArousalRateMultiplier)
    return UDmain.GetUDOM(akActor).UpdateArousalRateMultiplier(akActor, afArousalRateMultiplier)
EndFunction

;/  Function: UpdatetActorOrgasmCapacity

    NOTE: The value will be not changed back. Allways change the value back to original values !!!!!
    
    Parameters:
        akActor     - Actors whose value will be updated
        aiValue     - By how much should be orgasm capacity updated. Can be both positive and negative

    Returns:

        Return actors new orgasm capacity after update
/;
Int     Function    UpdatetActorOrgasmCapacity(Actor akActor,Int aiValue)
    return UDmain.GetUDOM(akActor).UpdatetActorOrgasmCapacity(akActor, aiValue)
EndFunction

;/  Function: Orgasm

    NOTE: The value will be not changed back. Allways change the value back to original values !!!!!
    WARNING: Some animations might look weird if duration is different then 20 seconds

    Parameters:

        akActor             - Actors who will orgasm
        aiDuration          - How long will actor orgasm
        aiArousalDecrease   - By how much will be arousal decreased over time. Duration is set in MCM
        aiForce             - 0 = Self caused orgasm, 2 = Forced orgasm , 1 = Something between
        abBlocking          - If function should be blocked untill orgasm fully start

    Returns:

        Return actors new orgasm capacity after update
/;
        Function    Orgasm(Actor akActor,int aiDuration,int aiArousalDecrease = 10,int aiForce = 0, bool abBlocking = true)
    UDmain.GetUDOM(akActor).startOrgasm(akActor,aiDuration,aiArousalDecrease,aiForce, abBlocking)
EndFUnction

;==========================================================================================
;                                     INPUT FUNCTIONS
;==========================================================================================

;/  Function: GetUserTextInput

    Opens text input menu, and returns its result

    NOTE: User needs to have UI Extensions installed for this to work!

    Returns:

        Return string written to text menu
/;
string  Function    GetUserTextInput()
    return UDmain.GetUserTextInput()
EndFunction

;/  Function: GetUserListInput

    Opens list menu and returns index of selected line. Top is 0, bottom is max index

    NOTE: User needs to have UI Extensions installed for this to work!

    Parameters:

        apList  - String array of list elements which will be shown in menu

    Returns:

        Index of selected line
/;
Int     Function    GetUserListInput(string[] apList)
    return UDmain.GetUserListInput(apList)
EndFunction