Scriptname UD_ControlablePlug_RenderScript extends UD_CustomPlug_RenderScript  

import UnforgivingDevicesMain
import UD_Native

float Property UD_DischargeRate = 1.0 auto

bool turned_on = false
int selected_strenght = 0
int current_strenght = 0
int selected_mod = 0

Function InitPost()
    parent.InitPost()
    UD_ActiveEffectName = "Long Vib"
    UD_DeviceType = "Controllable Plug"
EndFunction

Function safeCheck()
    if !UD_SpecialMenuInteraction
        UD_SpecialMenuInteraction = UDCDmain.DefaultCTRPlugSpecialMsg
    endif
    if !UD_SpecialMenuInteractionWH
        UD_SpecialMenuInteractionWH = UDCDmain.DefaultCTRPlugSpecialMsgWH
    endif
    parent.safeCheck()
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    if isVibrating()
        UDCDmain.currentDeviceMenu_switch4 = True
    elseif wearerFreeHands(True)
        UDCDmain.currentDeviceMenu_switch3 = True
    endif
    UDCDmain.currentDeviceMenu_switch1 = False
    UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    if isVibrating()
        UDCDmain.currentDeviceMenu_switch4 = True
    elseif (wearerFreeHands(True) || helperFreeHands(True))
        UDCDmain.currentDeviceMenu_switch3 = True
    endif
    UDCDmain.currentDeviceMenu_switch1 = False
    UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
    bool res = parent.proccesSpecialMenu(msgChoice)
    if msgChoice == 1
        turnOnPlug(UDCDmain.ControlablePlugVibMessage.show() + 1,UDCDmain.ControlablePlugModMessage.show())
        res = True
    elseif msgChoice == 2
        if wearerFreeHands(True,False) || !WearerIsPlayer()
            turnOffPlug()
            res = True
        else
            turnOffPlugMinigame()
            res = True
        endif
    endif
    return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
    if msgChoice == 1
        turnOnPlug(UDCDmain.ControlablePlugVibMessage.show() + 1,UDCDmain.ControlablePlugModMessage.show())
        return false
    elseif msgChoice == 2
        if wearerFreeHands(True,False) || HelperFreeHands(True,False)
            turnOffPlug()
            return false
        else
            return turnOffPlugMinigame()
        endif
    endif
    return res
EndFunction

Function turnOnPlug(int strenght, int mod)
    ;if !turned_on
    ;turned_on = True
    selected_mod = mod
    
    if isVibrating()
        stopVibratingAndWait()
    endif
    
    selected_strenght = strenght
    if selected_strenght == 6
        forceStrength(RandomInt(1,100))
    else
        forceStrength(selected_strenght*RandomInt(18,20))
    endif
    forceEdgingMode(selected_mod)
    UDCDmain.startVibFunction(self,true)
    ;endif
EndFunction

Function turnOffPlug()
    stopVibratingAndWait()
    resetCooldown(2.0)
EndFunction

bool turnOffPlugMinigame_on = false
bool Function turnOffPlugMinigame(Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return false
    endif
    resetMinigameValues()
    
    setMinigameOffensiveVar(False,0.0,0.0)
    setMinigameCustomCrit(40,0.75)
    setMinigameWearerVar(True,UD_base_stat_drain)
    setMinigameEffectVar(True,True,0.5)
    setMinigameWidgetVar(True, True, False, 0xe21db5, -1, -1, "icon-meter-turn-off")
    setMinigameMinStats(0.3)
    float mult = 1.0
    
    if haveHelper()
        setMinigameHelperVar(True,UD_base_stat_drain)
        setMinigameEffectHelperVar(True,True,0.75)
        mult += 0.15
        if HelperFreeHands(True,True)
            mult += 0.15
        endif
    endif
    ;setMinigameMult(1,mult*UD_DischargeRate)
    
    if minigamePostCheck(abSilent)
        turnOffPlugMinigame_on = True
        minigame()
        turnOffPlugMinigame_on = False
        return true
    else
        return false
    endif
EndFunction

Function OnCritFailure()
    if turnOffPlugMinigame_on
        addVibStrength(10)
        addVibDuration(45)
    endif
    parent.OnCritFailure()
EndFunction

bool Function OnCritDevicePre()
    if turnOffPlugMinigame_on
        int loc_duration = Round(30*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1))
        if getWearer().getItemCount(UDCDmain.UDlibs.EmptySoulgem_Common)
            getWearer().removeItem(UDCDmain.UDlibs.EmptySoulgem_Common,1)
            getWearer().addItem(UDCDmain.UDlibs.FilledSoulgem_Common,1,true)
            loc_duration = Math.floor(loc_duration*5.0)
        elseif getWearer().getItemCount(UDCDmain.UDlibs.EmptySoulgem_Lesser)
            getWearer().removeItem(UDCDmain.UDlibs.EmptySoulgem_Lesser,1)
            getWearer().addItem(UDCDmain.UDlibs.FilledSoulgem_Lesser,1,true)
            loc_duration = Math.floor(loc_duration*3.5)
        elseif getWearer().getItemCount(UDCDmain.UDlibs.EmptySoulgem_Petty)
            getWearer().removeItem(UDCDmain.UDlibs.EmptySoulgem_Petty,1)
            getWearer().addItem(UDCDmain.UDlibs.FilledSoulgem_Petty,1,true)
            loc_duration = Math.floor(loc_duration*2.0)
        endif
        removeVibDuration(loc_duration)
        
        if isVibrating()
            if RandomInt() < 15 ;25% chance
                removeVibStrength(10)
                if WearerIsPlayer()
                    UDmain.Print("You notice that the " + getDeviceName() + " vibrates weaker than before",2)
                endif
            endif
        endif
        return True
    else
        return parent.OnCritDevicePre()
    endif
EndFunction

float minutes_updated = 0.0
Function OnUpdatePost(float timePassed)
    minutes_updated += timePassed*(24*60)
    if isVibrating() && selected_strenght == 6
        if minutes_updated >= 15.0
            int loc_newStrength = RandomInt(25,100)
            if WearerIsPlayer()
                UDmain.Print("Your " + getDeviceName() + " changes its vibration strength!",2)
            elseif WearerIsFollower()
                UDmain.Print(getWearerName() + "s " + getDeviceName() + " changes its vibration strength!",2)
            endif
            forceStrength(loc_newStrength)
            minutes_updated = 0.0
        endif
    endif
    parent.OnUpdatePost(timePassed)
EndFunction

bool Function canVibrate()
    return true
EndFunction

Function activateDevice()
    resetCooldown(3.0)
    if !isVibrating()
        if WearerIsPlayer()
            UDmain.Print("Your "+ getDeviceName() +" suddenly turns itself on!",1)
        elseif UDmain.ActorInCloseRange(getWearer())
            UDmain.Print(getWearerName() + "s "+ getDeviceName() +" suddenly turns itself on!",2)
        endif
        turnOnPlug(3,0)
    else
        if getCurrentVibStrenth() < 100
            if WearerIsPlayer()
                UDmain.Print("Your controllable "+getPlugType()+" plug suddenly starts to vibrate stronger!",2)
            elseif UDmain.ActorInCloseRange(getWearer())            
                UDmain.Print(getWearerName() + "s "+getDeviceName()+" suddenly starts to vibrate stronger!",3)
            endif
            addVibStrength(10)
        endif
        if RandomInt() < 50
            addVibDuration(300)
            if WearerIsPlayer()
                UDmain.Print("Your controllable "+getPlugType()+" plug regains some of its charge!",2)
            elseif UDmain.ActorInCloseRange(getWearer())            
                UDmain.Print(getWearerName() + "s "+getDeviceName()+" regains some of its charge!",3)
            endif
        endif
    endif
EndFunction

Function updateWidget(bool force = false)
    if turnOffPlugMinigame_on
        setWidgetVal(getRemainingVibrationDurationPer(),force)
    else
        parent.updateWidget(force)
    endif
EndFunction

Function updateWidgetColor()
    if turnOffPlugMinigame_on
        if getRemainingVibrationDurationPer() > 0.8
            setMainWidgetAppearance(0xdd66c2)
        elseif getRemainingVibrationDurationPer() > 0.5
            setMainWidgetAppearance(0xde84ca)
        elseif getRemainingVibrationDurationPer() > 0.25
            setMainWidgetAppearance(0xdfa3d2)
        else
            setMainWidgetAppearance(0xdec5d8)
        endif
    else
        parent.updateWidgetColor()
    endif
EndFunction

Function OnVibrationEnd()
    if turnOffPlugMinigame_on
        StopMinigame()
    else
        
    endif
    parent.OnVibrationEnd()
EndFunction

;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
Function patchDevice() ;called on init. Should call patcher. Can also be dirrectly modified but should still use Patcher MCM variables
    parent.patchDevice()
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
Function OnCritDevicePost() ;called on minigame crit. Is only called if OnCritDevicePre returns true 
    parent.OnCritDevicePost()
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
Function OnMinigameTick(Float abUpdateTime) ;called every on every tick of minigame. Uses MCM performance setting
    parent.OnMinigameTick(abUpdateTime)
EndFunction
Function OnMinigameTick1() ;called every 1s of minigame
    parent.OnMinigameTick1()
EndFunction
Function OnMinigameTick3() ;called every 3s of minigame
    parent.OnMinigameTick3()
EndFunction
float Function getAccesibility() ;return accesibility of device in range 0.0 - 1.0
    return parent.getAccesibility()
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
Function onSpecialButtonPressed(float fMult)
    parent.onSpecialButtonPressed(fMult)
EndFunction
Function onSpecialButtonReleased(Float fHoldTime)
    parent.onSpecialButtonReleased(fHoldTime)
EndFunction
bool Function onWeaponHitPre(Weapon source, Float afDamage = -1.0)
    return parent.onWeaponHitPre(source, afDamage)
EndFunction
Function onWeaponHitPost(Weapon source, Float afDamage = -1.0)
    parent.onWeaponHitPost(source, afDamage)
EndFunction
bool Function onSpellHitPre(Form source, Float afDamage = -1.0)
    return parent.onSpellHitPre(source, afDamage)
EndFunction
Function onSpellHitPost(Form source, Float afDamage = -1.0)
    parent.onSpellHitPost(source, afDamage)
EndFunction
int Function getArousalRate()
    return parent.getArousalRate()
EndFunction
Float[] Function GetCurrentMinigameExpression()
    return parent.GetCurrentMinigameExpression()
EndFunction
string Function addInfoString(string str = "")
    return parent.addInfoString(str)
EndFunction