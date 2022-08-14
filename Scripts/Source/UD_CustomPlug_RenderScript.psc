Scriptname UD_CustomPlug_RenderScript extends UD_CustomVibratorBase_RenderScript  

import UnforgivingDevicesMain

Float Property UD_PlugRemovePressMult = 0.3 autoreadonly

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Plug"
EndFunction

Function safeCheck()
    if !UD_MessageDeviceInteraction
        UD_MessageDeviceInteraction = UDCDmain.DefaultInteractionPlugMessage
    endif
    if !UD_MessageDeviceInteractionWH
        UD_MessageDeviceInteractionWH = UDCDmain.DefaultInteractionPlugMessageWH
    endif
    parent.safeCheck()
EndFunction

Function patchDevice()
    UDCDmain.UDPatcher.patchPlug(self)
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    ;UDCDmain.currentDeviceMenu_allowcutting = false
    if !UDCDmain.currentDeviceMenu_allowstruggling ;canBeStruggled()
        UDCDMain.disableStruggleCondVar(false)
    endif
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    ;UDCDmain.currentDeviceMenu_allowcutting = false
    if !UDCDmain.currentDeviceMenu_allowstruggling;canBeStruggled()
        UDCDMain.disableStruggleCondVar(false)
    endif
EndFunction

bool Function struggleMinigame(int type = -1)
    if isSentient() || !WearerFreeHands(True)
        forceOutPlugMinigame()
    else
        unlockRestrain()
        if WearerIsPlayer()
            UDmain.Print("You succefully forced out " + deviceInventory.getName(),1)
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "s "+ getDeviceName() +" got removed!",1)
        endif
    endif
    return true
EndFunction

bool Function struggleMinigameWH(Actor akSource)
    if isSentient() || !WearerFreeHands(True)
        forceOutPlugMinigameWH(akSource)
    else
        unlockRestrain()
        if WearerIsPlayer()
            UDmain.Print("With help of "+ getHelperName() +", you succefully forced out " + deviceInventory.getName() + " !",1)
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "s "+ getDeviceName() +" got removed!",1)
        endif
    endif
    return true
EndFunction

float Function getAccesibility()
    float loc_res = 1.0
    int loc_beltstate = UDCDmain.ActorBelted(getWearer()) 
    bool loc_hashelper = HasHelper()
    
    if !wearerFreeHands() && (!loc_hashelper || !HelperFreeHands())
        loc_res *= 0.25
    elseif !wearerFreeHands(true) && (!loc_hashelper || !HelperFreeHands(true))
        loc_res *= 0.5
    endif
    
    if getWearer().wornhaskeyword(libs.zad_DeviousHobbleSkirt)
        loc_res *= 0.7
    elseif getWearer().wornhaskeyword(libs.zad_DeviousHobbleSkirtRelaxed)
        loc_res *= 0.8
    elseif getWearer().wornhaskeyword(libs.zad_DeviousSuit)
        loc_res *= 0.9
    endif
    
    if loc_beltstate > 0 ;belted
        if loc_beltstate == 1 ;all holes belted
            loc_res = 0.0
        elseif loc_beltstate == 2 && getPlugType() == 0 ;anal hole not belted but plug is vaginal
            loc_res = 0.0
        endif
    endif
    
    return fRange(loc_res,0.0,1.0)
EndFunction

;returns plug type
;0 -> Vaginal plug
;1 -> Anal plug
;2 -> Multi plug (Vaginal + Anal)
int Function getPlugType()
    if deviceRendered.haskeyword(libs.zad_DeviousPlugAnal) && deviceRendered.haskeyword(libs.zad_DeviousPlugVaginal)
        return 2
    endif
    If UD_DeviceKeyword == libs.zad_DeviousPlugAnal
        return 1
    Else    
        return 0
    EndIf
EndFunction



bool forceOutPlugMinigame_on = false
Function forceOutPlugMinigame()
    resetMinigameValues()
    
    setMinigameOffensiveVar(False,0.0,0.0,True)
    setMinigameWearerVar(True,UD_base_stat_drain + getMaxActorValue(getWearer(),"Stamina",0.05))
    setMinigameEffectVar(True,True,1.25)
    setMinigameWidgetVar(True)
    setMinigameMinStats(0.8)
    setMinigameDmgMult(getAccesibility())
    
    forceOutPlugMinigame_on = True
    minigame()
    forceOutPlugMinigame_on = False
EndFunction

Function forceOutPlugMinigameWH(Actor akHelper)
    resetMinigameValues()
    
    setHelper(akHelper)
    setMinigameOffensiveVar(False,0.0,0.0,True)
    setMinigameDmgMult(getAccesibility()*2.0)
    setMinigameWearerVar(True,UD_base_stat_drain         + getMaxActorValue(getWearer(),"Stamina",0.025))
    setMinigameHelperVar(True,UD_base_stat_drain*0.25     + getMaxActorValue(getWearer(),"Stamina",0.025))
    setMinigameEffectVar(True,True,1.25)
    setMinigameEffectHelperVar(False,False)
    setMinigameWidgetVar(True)
    setMinigameMinStats(0.8)
    
    forceOutPlugMinigame_on = True
    minigame()
    forceOutPlugMinigame_on = False
    
    setHelper(none)
EndFunction

Function updateWidget(bool force = false)
    if forceOutPlugMinigame_on && PlayerInMinigame() && UDCDmain.UD_UseWidget && UD_UseWidget && UD_AllowWidgetUpdate
        setWidgetVal(getRelativeDurability(),force)    
    else
        parent.updateWidget(force)
    endif
EndFunction

Function onSpecialButtonPressed(float fMult)
    if forceOutPlugMinigame_on
        decreaseDurabilityAndCheckUnlock(fMult*getDurabilityDmgMod()*UD_PlugRemovePressMult,0.0)
    else
        parent.onSpecialButtonPressed(fMult)
    endif
EndFunction

Function OnCritDevicePost()
    if forceOutPlugMinigame_on
        decreaseDurabilityAndCheckUnlock(getDurabilityDmgMod()*UD_StruggleCritMul,0.0)
    else
        parent.OnCritDevicePost()
    endif
EndFunction

bool Function Details_CanShowResist()
    return false
EndFunction 

bool Function Details_CanShowHitResist()
    return false
EndFunction 

Function OnMinigameTick1() ;called every 1s of minigame
    if forceOutPlugMinigame_on && !PlayerInMinigame()
        decreaseDurabilityAndCheckUnlock(getDurabilityDmgMod()*4.0*UD_PlugRemovePressMult,0.0) ;simulate 4 presses per second
    endif
    parent.OnMinigameTick1()
EndFunction

;======================================================================
;Place new override functions here, do not forget to check override functions in parent if its not base script (UD_CustomDevice_RenderScript)
;======================================================================
Function OnVibrationStart()
    parent.OnVibrationStart()
EndFunction
Function OnVibrationEnd()
    parent.OnVibrationStart()
EndFunction
float Function getVibOrgasmRate(float afMult = 1.0)
    return parent.getVibOrgasmRate(afMult)
EndFunction
float Function getVibArousalRate(float afMult = 1.0)
    return parent.getVibArousalRate(afMult)
EndFunction
;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
Function activateDevice() ;Device custom activate effect. You need to create it yourself. Don't forget to remove parent.activateDevice() if you don't want parent effect
    parent.activateDevice()
EndFunction
bool Function canBeActivated() ;Switch. Used to determinate if device can be currently activated
    return parent.canBeActivated()
EndFunction
bool Function OnMendPre(float mult) ;called on device mend (regain durability)
    return parent.OnMendPre(mult)
EndFunction
Function OnMendPost(float mult) ;called on device mend (regain durability). Only called if OnMendPre returns true
    parent.OnMendPost(mult)
EndFunction
bool Function OnCritDevicePre() ;called on minigame crit
    return parent.OnCritDevicePre()
EndFunction
bool Function OnOrgasmPre(bool sexlab = false) ;called on wearer orgasm. Is only called if wearer is registered
    return parent.OnOrgasmPre(sexlab)
EndFunction
Function OnMinigameOrgasm(bool sexlab = false) ;called on wearer orgasm while in minigame. Is only called if wearer is registered
    parent.OnMinigameOrgasm(sexlab)
EndFunction
Function OnMinigameOrgasmPost() ;called on wearer orgasm while in minigame. Is only called after OnMinigameOrgasm. Is only called if wearer is registered
    parent.OnMinigameOrgasmPost()
EndFunction
Function OnOrgasmPost(bool sexlab = false) ;called on wearer orgasm. Is only called if OnOrgasmPre returns true. Is only called if wearer is registered
    parent.OnOrgasmPost(sexlab)
EndFunction
Function OnMinigameStart() ;called when minigame start
    parent.OnMinigameStart()
EndFunction
Function OnMinigameEnd() ;called when minigame end
    parent.OnMinigameEnd()
EndFunction
Function OnMinigameTick(Float abUpdateTime) ;called on every tick of minigame. Uses MCM performance setting
    parent.OnMinigameTick(abUpdateTime)
EndFunction
Function OnMinigameTick3() ;called every 3s of minigame
    parent.OnMinigameTick3()
EndFunction
Function OnCritFailure() ;called on crit failure (wrong key pressed)
    parent.OnCritFailure()
EndFunction
Function OnDeviceCutted() ;called when device is cutted
    parent.OnDeviceCutted()
EndFunction
Function OnDeviceLockpicked() ;called when device is lockpicked
    parent.OnDeviceLockpicked()
EndFunction
Function OnLockReached() ;called when device lock is reached
    parent.OnLockReached()
EndFunction
Function OnLockJammed() ;called when device lock is jammed
    parent.OnLockJammed()
EndFunction
Function OnDeviceUnlockedWithKey() ;called when device is unlocked with key
    parent.OnDeviceUnlockedWithKey()
EndFunction
Function OnUpdatePre(float timePassed) ;called on update. Is only called if wearer is registered
    parent.OnUpdatePre(timePassed)
EndFunction
Function OnUpdatePost(float timePassed) ;called on update. Is only called if wearer is registered
    parent.OnUpdatePost(timePassed)
EndFunction
bool Function OnCooldownActivatePre()
    return parent.OnCooldownActivatePre()
EndFunction
Function OnCooldownActivatePost()
    parent.OnCooldownActivatePost()
EndFunction
Function DeviceMenuExt(int msgChoice)
    parent.DeviceMenuExt(msgChoice)
EndFunction
Function DeviceMenuExtWH(int msgChoice)
    parent.DeviceMenuExtWH(msgChoice)
EndFunction
bool Function OnUpdateHourPre()
    return parent.OnUpdateHourPre()
EndFunction
bool Function OnUpdateHourPost()
    return parent.OnUpdateHourPost()
EndFunction
Function InitPostPost()
    parent.InitPostPost()
EndFunction
Function OnRemoveDevicePre(Actor akActor)
    parent.OnRemoveDevicePre(akActor)
EndFunction
Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
EndFunction
Function onLockUnlocked(bool lockpick = false)
    parent.onLockUnlocked(lockpick)
EndFunction
Function onSpecialButtonReleased(Float fHoldTime)
    parent.onSpecialButtonReleased(fHoldTime)
EndFunction
bool Function onWeaponHitPre(Weapon source)
    return parent.onWeaponHitPre(source)
EndFunction
Function onWeaponHitPost(Weapon source)
    parent.onWeaponHitPost(source)
EndFunction
bool Function onSpellHitPre(Spell source)
    return parent.onSpellHitPre(source)
EndFunction
Function onSpellHitPost(Spell source)
    parent.onSpellHitPost(source)
EndFunction
string Function addInfoString(string str = "")
    return parent.addInfoString(str)
EndFunction
Function updateWidgetColor()
    parent.updateWidgetColor()
EndFunction
bool Function proccesSpecialMenu(int msgChoice)
    return parent.proccesSpecialMenu(msgChoice)
EndFunction
bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    return parent.proccesSpecialMenuWH(akSource,msgChoice)
EndFunction
float Function getStruggleOrgasmRate()
    return parent.getStruggleOrgasmRate()
EndFunction
int Function getArousalRate()
    return parent.getArousalRate()
EndFunction
Float[] Function GetCurrentMinigameExpression()
	return parent.GetCurrentMinigameExpression()
EndFunction
