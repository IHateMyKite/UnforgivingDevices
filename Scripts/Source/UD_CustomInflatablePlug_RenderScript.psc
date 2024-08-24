Scriptname UD_CustomInflatablePlug_RenderScript extends UD_CustomPlug_RenderScript  

import UnforgivingDevicesMain
import UD_Native

float Property UD_PumpDifficulty    = 50.0      auto ;deflation required to deflate plug by one lvel
float Property UD_DeflateRate       = 200.0     auto ;inflation lost per one day
int _inflateLevel = 0 ;for npcs

String  _InflationEffectSlot
String  Property     InflationEffectSlot                        Hidden
    String Function Get()
        If _InflationEffectSlot == ""
            If UD_DeviceKeyword == libs.zad_DeviousPlugVaginal
                _InflationEffectSlot = "dd-plug-vag-inflation"
            ElseIf UD_DeviceKeyword == libs.zad_DeviousPlugAnal
                _InflationEffectSlot = "dd-plug-anal-inflation"
            EndIf
        EndIf
        Return _InflationEffectSlot
    EndFunction
EndProperty

Function InitPost()
    parent.InitPost()
    if UD_ActiveEffectName == "Share"
        UD_ActiveEffectName = "Inflate"
    else
        UD_ActiveEffectName = "Inflate & " + UD_ActiveEffectName
    endif
    UD_DeviceType = "Inflatable Plug"
EndFunction

Function safeCheck()
    if !UD_SpecialMenuInteraction
        UD_SpecialMenuInteraction = UDCDmain.DefaultINFPlugSpecialMsg
    endif
    if !UD_SpecialMenuInteractionWH
        UD_SpecialMenuInteractionWH = UDCDmain.DefaultINFPlugSpecialMsgWH
    endif
    parent.safeCheck()
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    int pump_level = getPlugInflateLevel()
    if pump_level < 5
        UDCDmain.currentDeviceMenu_switch3 = True
        if wearerFreeHands(True)
            UDCDmain.currentDeviceMenu_switch5 = True
        endif
    endif
    if pump_level > 0 && pump_level != 5
        UDCDmain.currentDeviceMenu_switch4 = True
    endif
    UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    int pump_level = getPlugInflateLevel()
    if pump_level < 5
        UDCDmain.currentDeviceMenu_switch3 = True
        if wearerFreeHands(True) || helperFreeHands(True)
            UDCDmain.currentDeviceMenu_switch5 = True
        endif
    endif
    if pump_level > 0 && pump_level != 5
        UDCDmain.currentDeviceMenu_switch4 = True
    endif
    UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
    bool res = parent.proccesSpecialMenu(msgChoice)
    if msgChoice == 1
        if wearerFreeHands(True)
            inflate()
            return false
        else
            return inflateMinigame()
        endif
    elseif msgChoice == 2
        if wearerFreeHands(True)
            inflate(false,5)
            return true
        endif
    elseif msgChoice == 3
        if wearerFreeHands(True) && canDeflate() 
            deflate()
            return false
        else
            return deflateMinigame()
        endif    
    endif
    return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
    if msgChoice == 1
        if wearerFreeHands(True) || helperFreeHands(True)
            inflate()
            return false
        else
            return inflateMinigame()
        endif
    elseif msgChoice == 2
        inflate(false,5)
        return true
    elseif msgChoice == 3
        if (wearerFreeHands(True) || helperFreeHands(True)) && canDeflate() 
            deflate()
            return false
        else
            return deflateMinigame()
        endif    
    endif
    return res
EndFunction

string Function addInfoString(string str = "")
    ;string res = str
    str += "Inflate level: " + getPlugInflateLevel() + "\n"
    if getPlugInflateLevel() > 0
        str += "Plug pressure: " + Math.Ceiling(100.0 - 100.0*deflateprogress/UD_PumpDifficulty) + " %\n"
    endif
    return parent.addInfoString(str)
EndFunction

bool Function struggleMinigame(int type = -1, Bool abSilent = False)
    if isSentient() || !WearerFreeHands(True) || getPlugInflateLevel() > 0
        return forceOutPlugMinigame(abSilent)
    else
        unlockRestrain()
        if WearerIsPlayer()
            UDmain.Print("You succefully forced out " + deviceInventory.getName(),1)
        elseif UDCDmain.AllowNPCMessage(GetWearer())
            UDmain.Print(getWearerName() + "s "+ getDeviceName() +" got removed!",1)
        endif
    endif
    return true
EndFunction

bool Function struggleMinigameWH(Actor akHelper,int aiType = -1)
    if isSentient() || (!WearerFreeHands(True) && !HelperFreeHands(True)) || getPlugInflateLevel() > 0
        return forceOutPlugMinigameWH(akHelper)
    else
        unlockRestrain()
        if WearerIsPlayer()
            UDmain.Print("With help of "+ getHelperName() +", you succefully forced out " + deviceInventory.getName() + " !",1)
        elseif UDCDmain.AllowNPCMessage(GetWearer())
            UDmain.Print(getWearerName() + "s "+ getDeviceName() +" got removed!",1)
        endif
    endif
    return true
EndFunction

float Function getAccesibility()
    float loc_res = parent.getAccesibility()
    if loc_res
        loc_res *= (1.0 - getPlugInflateLevel()*0.2)
    endif
    return ValidateAccessibility(loc_res)
EndFunction

float inflateprogress = 0.0

bool inflateMinigame_on = false
bool Function inflateMinigame()
    if !minigamePrecheck()
        return false
    endif

    resetMinigameValues()
    
    setMinigameOffensiveVar(False,0.0,0.0,True)
    setMinigameWearerVar(True,UD_base_stat_drain*0.6)
    setMinigameEffectVar(True,True,0.5)
    setMinigameWidgetVar(True, True, False, 0x7c9cfb, 0x7c2cfd, -1, "icon-meter-air")
    setMinigameMinStats(0.3)
    float mult = 1.0
    if haveHelper()
        setMinigameHelperVar(True,UD_base_stat_drain*0.75)
        setMinigameEffectHelperVar(True,True,0.75)    
        mult += 0.25
        if HelperFreeHands(True,True)
            mult += 0.15
        endif
    endif
    if minigamePostcheck()
        setMinigameMult(1,mult)
        inflateMinigame_on = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"IflatablePlug_Inflate")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"IflatablePlug_Inflate")
        inflateMinigame_on = False
        return true
    else
        return false
    endif
EndFunction

float deflateprogress = 0.0

bool deflateMinigame_on = false
bool Function deflateMinigame()
    if !minigamePrecheck()
        return false
    endif

    resetMinigameValues()
    
    setMinigameOffensiveVar(False,0.0,0.0,True)
    setMinigameWearerVar(True,UD_base_stat_drain*0.8)
    setMinigameEffectVar(True,True,0.8)
    setMinigameWidgetVar(True, True, False, 0x7c9cfb, 0x7c2cfd, -1, "icon-meter-air")
    setMinigameMinStats(0.6)
    float mult = 1.0
    if haveHelper()
        setMinigameHelperVar(True,UD_base_stat_drain*0.75)
        setMinigameEffectHelperVar(True,True,0.75)    
        mult += 0.15
        if HelperFreeHands(True,True)
            mult += 0.10
        endif        
    endif
    setMinigameMult(1,mult)
    
    if minigamePostcheck()
        deflateMinigame_on = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"IflatablePlug_Deflate")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"IflatablePlug_Deflate")
        deflateMinigame_on = False
        return true
    else
        return false
    endif
EndFunction

Function inflate(bool silent = false,int iInflateNum = 1)
        int currentVal = getPlugInflateLevel() + iInflateNum
        if !silent
            if haveHelper()
                if WearerIsPlayer()
                    UDmain.Print(getHelperName() + " helped you to inflate your " + getDeviceName() + "!",1)
                elseif WearerIsFollower() && HelperIsPlayer()
                    UDmain.Print("You helped to inflate " + getWearerName() + "s " + getDeviceName() + "!",1)
                elseif WearerIsFollower()
                    UDmain.Print(getHelperName() + " helped to inflate " + getWearerName() + "s " + getDeviceName() + "!",1)
                endif
            else
                if WearerIsPlayer()
                    UDmain.Print("You succesfully inflated yours " + getDeviceName(),1)
                    
                    if currentVal == 0
                        libs.notify("Your plug is completely deflated and doesn't stimulate you very much. You could slide it out of you, if you wish. That or you could give the pump a healthy squeeze and make it more fun!", messagebox = true)
                    elseif currentVal == 1
                        libs.notify("Your plug is a bit inflated but doesn't stimulate you too much - just enough to make you long for more. You could give the pump a healthy squeeze!", messagebox = true)
                    elseif currentVal == 2
                        libs.notify("Your plug is inflated. Its gentle movements inside you please you without causing you discomfort. You are getting more horny and wonder if you should inflate it even more?", messagebox = true)
                    elseif currentVal == 3
                        libs.notify("Your fairly inflated plug is impossible to ignore as it moves around inside of you, constantly pleasing you and making you more horny as you already are.", messagebox = true)
                    elseif currentVal == 4
                        libs.notify("Your plug is almost inflated to capacity. You cannot move at all without shifting it around inside of you, making you squeal in an odd sensation of pleasurable pain.", messagebox = true)
                    else
                        libs.notify("Your plug is fully inflated and almost bursting inside you. It's causing you more discomfort than anything. But no matter what - you won't be able to remove it from your body anytime soon.", messagebox = true)        
                    EndIf    
                elseif WearerIsFollower()
                    UDmain.Print(getWearerName() + "s " + getDeviceName() + " inflated!",2)
                endif
            endif
        endif
        inflatePlug(iInflateNum)
        inflateprogress = 0.0
EndFunction

Function deflate(bool silent = False)
    if !silent
        if haveHelper()
            if WearerIsPlayer()
                UDmain.Print(getHelperName() + " helped you to deflate yours " + getDeviceName() + "!",1)
            elseif PlayerInMinigame()
                UDmain.Print("You helped to deflate " + getWearerName() + "s " + getDeviceName() + "!",1)
            endif
        else
            if WearerIsPlayer()
                UDmain.Print("You succesfully deflated your "+getDeviceName()+" plug!",1)
            elseif PlayerInMinigame()
                UDmain.Print(getWearerName() + "s " + getDeviceName()+ " deflated!",1)
            endif
        endif
    endif
    deflatePlug(1)
    If WearerIsPlayer()
        UDmain.UDWC.StatusEffect_SetMagnitude(InflationEffectSlot, getPlugInflateLevel() * 20)
    EndIf
    return
EndFunction

bool Function canDeflate()
    if iInRange(getPlugInflateLevel(),1,4)
        return True
    else
        if WearerIsPlayer()
            debug.MessageBox("Plug is already deflated")
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "s "+ getDeviceName() + " is already deflated",1)
        endif
        return False
    endif
    if WearerIsPlayer()
        debug.MessageBox("Plug is too big to be deflated at the moment!")
    elseif WearerIsFollower()
        UDmain.Print(getWearerName() + "s "+ getDeviceName() + " is too big to be deflated at the moment!",1)
    endif
    return False
EndFunction

int Function getPlugInflateLevel()
    return _inflateLevel
EndFunction

Function inflatePlug(int increase)
    _inflateLevel += increase
    if _inflateLevel > 5
        _inflateLevel = 5
    endif
    
    If WearerIsPlayer()
        UDmain.UDWC.StatusEffect_SetMagnitude(InflationEffectSlot, _inflateLevel * 20)
    EndIf
    
    OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),UD_ArMovKey,1,0.25,2)
    OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),UD_ArMovKey,9,0.25,2)
    
    If UD_DeviceKeyword == libs.zad_DeviousPlugAnal
        string loc_key = OrgasmSystem.MakeUniqueKey(GetWearer(),"VaginalPlugInflate")
        OrgasmSystem.AddOrgasmChange(GetWearer(),loc_key, 0x6000C,0x0003, 13.5*_inflateLevel,afOrgasmForcing = 0.5)
        OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),loc_key,9,6.0*_inflateLevel,1)
    else
        string loc_key = OrgasmSystem.MakeUniqueKey(GetWearer(),"AnalPlugInflate")
        OrgasmSystem.AddOrgasmChange(GetWearer(),loc_key, 0x6000C,0x0180, 7.5*_inflateLevel,afOrgasmForcing = 0.5)
        OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),loc_key,9,3.0*_inflateLevel,1)
    endif

    deflateprogress = 0.0
    
    ; Update DD Inflation variables for player
    if WearerIsPlayer()
        If UD_DeviceKeyword == libs.zad_DeviousPlugAnal
            libs.zadInflatablePlugStateAnal.SetValueInt(_inflateLevel)
        Else    
            libs.zadInflatablePlugStateVaginal.SetValueInt(_inflateLevel)
        EndIf
        libs.LastInflationAdjustmentVaginal = Utility.GetCurrentGameTime()
    endif
    libs.SendInflationEvent(GetWearer(), True, True, _inflateLevel)
    
    UD_Events.SendEvent_InflatablePlugInflate(self)
    
    OnInflated()
EndFunction

Function deflatePlug(int decrease)
    
    _inflateLevel -= decrease
    if _inflateLevel < 0
        _inflateLevel = 0
    endif
    
    If WearerIsPlayer()
        UDmain.UDWC.StatusEffect_SetMagnitude(InflationEffectSlot, _inflateLevel * 20)
    EndIf
    
    OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),UD_ArMovKey,1,-0.25,2)
    OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),UD_ArMovKey,9,-0.25,2)
    
    deflateprogress = 0.0
    
    ; Update DD Inflation variables for player
    if WearerIsPlayer()
        If UD_DeviceKeyword == libs.zad_DeviousPlugAnal
            libs.zadInflatablePlugStateAnal.SetValueInt(_inflateLevel)
        Else    
            libs.zadInflatablePlugStateVaginal.SetValueInt(_inflateLevel)
        EndIf
        libs.LastInflationAdjustmentVaginal = Utility.GetCurrentGameTime()
    endif
    libs.SendInflationEvent(GetWearer(), True, True, _inflateLevel)
    
    UD_Events.SendEvent_InflatablePlugDeflate(self)
    
    OnDeflated()
EndFunction

Function patchDevice()
    UDCDmain.UDPatcher.patchPlug(self)
EndFunction

Function OnMinigameTick(Float abUpdateTime)
    if inflateMinigame_on
        inflateprogress += RandomFloat(8.2,12.0)*UDCDmain.getStruggleDifficultyModifier()*abUpdateTime*getMinigameMult(1)
        if inflateprogress > UD_PumpDifficulty
            stopMinigame()
        endif
    endif
    
    if deflateMinigame_on
        deflateprogress += RandomFloat(3.5,8.0)*UDCDmain.getStruggleDifficultyModifier()*abUpdateTime*getMinigameMult(1)
        if deflateprogress > UD_PumpDifficulty
            stopMinigame()
        endif
    endif
    
    parent.OnMinigameTick(abUpdateTime)
EndFunction

Function OnMinigameEnd()
    if inflateMinigame_on && inflateprogress >= UD_PumpDifficulty
        inflate()
    endif
    if deflateMinigame_on && deflateprogress >= UD_PumpDifficulty
        deflate()
    endif
    parent.OnMinigameEnd()
EndFunction

Function OnCritFailure()
    if inflateMinigame_on
        inflateprogress -= 10.0
        if inflateprogress < 0.0
            inflateprogress = 0.0
        endif    
    elseif deflateMinigame_on
        deflateprogress -= 20.0
        if deflateprogress < 0.0
            deflateprogress = 0.0
        endif
    endif
    parent.OnCritFailure()
EndFunction

bool Function OnCritDevicePre()
    if inflateMinigame_on
        inflateprogress += RandomFloat(20.2,30.0)*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1)
        if inflateprogress >= UD_PumpDifficulty
            stopMinigame()
        endif    
    elseif deflateMinigame_on
        deflateprogress += RandomFloat(15.5,25.0)*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1)
        if deflateprogress >= UD_PumpDifficulty
            stopMinigame()
        endif
    else
        return parent.OnCritDevicePre()
    endif
    return True
EndFunction

Function activateDevice()
    resetCooldown(1.0)
    bool loc_canInflate = _inflateLevel <= 4
    bool loc_canVibrate = canVibrate() && !isVibrating()
    if loc_canInflate
        if WearerIsPlayer()
            UDmain.Print("Your "+ getDeviceName()+" suddenly inflates itself!",1)
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "s "+ getDeviceName() + " suddenly inflates itself!",3)
        endif
        inflatePlug(1)
    endif
    if loc_canVibrate
        vibrate()
    endif
EndFunction

Function onUpdatePost(float timePassed)
    if getPlugInflateLevel() > 0
        deflateprogress += timePassed*UD_DeflateRate*RandomFloat(0.75,1.25)*UDCDmain.getStruggleDifficultyModifier()
        if deflateprogress > UD_PumpDifficulty
            if WearerIsPlayer()
                UDmain.Print("You feel that your "+getDeviceName()+" lost some of its pressure",2)
            elseif WearerIsFollower()
                UDmain.Print(getWearerName() + "s "+ getDeviceName() + " lost some of its pressure",3)
            endif
            resetCooldown(1.25)
            deflate(True)
        endif
    endif    
    parent.onUpdatePost(timePassed)
EndFunction

Function updateWidget(bool force = false)
    if inflateMinigame_on
        setWidgetVal(inflateprogress/UD_PumpDifficulty,force)
    elseif deflateMinigame_on
        setWidgetVal(deflateprogress/UD_PumpDifficulty,force)
    else
        parent.updateWidget(force)
    endif
EndFunction

bool Function canBeActivated()
    if parent.canBeActivated() || (_inflateLevel <= 4 && getRelativeElapsedCooldownTime() >= 0.75)
        return true
    else
        return false
    endif
EndFunction
;======================================================================
;Place new override functions here, do not forget to check override functions in parent if its not base script (UD_CustomDevice_RenderScript)
;======================================================================
Function OnInflated()
EndFunction
Function OnDeflated()
EndFunction

;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
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
Function OnMinigameTick1() ;called every 1s of minigame
    parent.OnMinigameTick1()
EndFunction
Function OnMinigameTick3() ;called every 3s of minigame
    parent.OnMinigameTick3()
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
    If WearerIsPlayer()
        UDMain.UDWC.StatusEffect_SetVisible(InflationEffectSlot)
        UDmain.UDWC.StatusEffect_SetMagnitude(InflationEffectSlot, _inflateLevel * 20)
    EndIf
EndFunction
Function OnRemoveDevicePre(Actor akActor)
    parent.OnRemoveDevicePre(akActor)
EndFunction
Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    If IsPlayer(akActor)
        UDMain.UDWC.StatusEffect_SetVisible(InflationEffectSlot, False)
        UDmain.UDWC.StatusEffect_SetMagnitude(InflationEffectSlot, _inflateLevel * 20)
    EndIf
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
Function updateWidgetColor()
    parent.updateWidgetColor()
EndFunction
int Function getArousalRate()
    return parent.getArousalRate()
EndFunction
float Function getStruggleOrgasmRate()
    return parent.getStruggleOrgasmRate()
EndFunction
Float[] Function GetCurrentMinigameExpression()
	return parent.GetCurrentMinigameExpression()
EndFunction