Scriptname UD_CustomInflatablePlug_RenderScript extends UD_CustomPlug_RenderScript

import UnforgivingDevicesMain
import UD_Native

; <DOCUSTR(name,Inflatable plug)>

;<LUA>
;   local _GetTags = GetTags
;   function GetTags(C)
;       local loc_res = json.parse(_GetTags(C))
;       loc_res["inflatable_plug"] = true
;       return json.stringify(loc_res)
;   end
;   local _GetAccessibility = GetAccessibility
;   function GetAccessibility(C,checkHB)
;       Log("GetAccessibility(InflatablePlug) called")
;       local loc_res = _GetAccessibility(C,checkHB)
;       local loc_infllvl = GetVariableValue(C,"thisdevice::_inflateLevel(A)")
;       Log("inflate level = "..tostring(loc_infllvl))
;       loc_res = loc_res*(1.0 - 0.2*loc_infllvl)
;       return loc_res
;   end
;<\LUA>

float Property UD_PumpDifficulty    = 50.0      auto ;deflation required to deflate plug by one level
float Property UD_DeflateRate       = 200.0     auto ;inflation lost per one day ;/ <EXPORT(name:Deflate rate)> /;
int _inflateLevel = 0 ;/ <EXPORT(name:Infalte level,conv:enum{0=Deflated;1=Barely inflated;2=Sligtly inflated;3=Almost Inflated;4=Inflated;5=Overinflated})> /;

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

float Function getAccesibility()
    float loc_res = parent.getAccesibility()
    if loc_res
        loc_res *= (1.0 - getPlugInflateLevel()*0.2)
    endif
    return ValidateAccessibility(loc_res)
EndFunction

float inflateprogress = 0.0
float deflateprogress = 0.0

Function inflate(bool silent = false,int iInflateNum = 1)
        int currentVal = getPlugInflateLevel() + iInflateNum
        if !silent
            if haveHelper()
                if WearerIsPlayer()
                    UDmain.Print(getHelperName() + " helped you to inflate your " + getDeviceName() + "!",1)
                elseif WearerIsFollower() && HelperIsPlayer()
                    UDmain.Print("You helped to inflate " + getWearerName() + "'s " + getDeviceName() + "!",1)
                elseif WearerIsFollower()
                    UDmain.Print(getHelperName() + " helped to inflate " + getWearerName() + "'s " + getDeviceName() + "!",1)
                endif
            else
                if WearerIsPlayer()
                    UDmain.Print("You succesfully inflated your " + getDeviceName(),1)
                    
                    if currentVal == 0
                        libs.notify("Your plug is completely deflated and doesn't stimulate you very much. You could slide it out of you, if you wish. That or you could give the pump a healthy squeeze and make it more fun!", messagebox = true)
                    elseif currentVal == 1
                        libs.notify("Your plug is slightly inflated but doesn't stimulate you too much - just enough to make you long for more. You could give the pump a healthy squeeze!", messagebox = true)
                    elseif currentVal == 2
                        libs.notify("Your plug is inflated. Its gentle movements inside you please you without causing you discomfort. You are getting hornier and wonder if you should inflate it even more?", messagebox = true)
                    elseif currentVal == 3
                        libs.notify("Your fairly inflated plug is impossible to ignore as it moves around inside of you, constantly pleasing you and making you even hornier than you already are.", messagebox = true)
                    elseif currentVal == 4
                        libs.notify("Your plug is almost inflated to capacity. You cannot move at all without it shifting around inside of you, making you squeal in an odd sensation of pleasurable pain.", messagebox = true)
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

Function deflate(bool silent = False,int iDeflateNum = 1)
    if !silent
        if haveHelper()
            if WearerIsPlayer()
                UDmain.Print(getHelperName() + " helped you to deflate your " + getDeviceName() + "!",1)
            elseif PlayerInMinigame()
                UDmain.Print("You helped to deflate " + getWearerName() + "'s " + getDeviceName() + "!",1)
            endif
        else
            if WearerIsPlayer()
                UDmain.Print("You succesfully deflated your "+getDeviceName()+" plug!",1)
            elseif PlayerInMinigame()
                UDmain.Print(getWearerName() + "'s " + getDeviceName()+ " deflated!",1)
            endif
        endif
    endif
    deflatePlug(iDeflateNum)
    return
EndFunction

int Function getPlugInflateLevel()
    return _inflateLevel
EndFunction

String Function getPlugInflateLevelString(Bool abDecorate = False)
    String loc_str = ""
    If _inflateLevel >= 5
        loc_str = "Bursting"
    ElseIf _inflateLevel >= 4
        loc_str = "Overblown"
    ElseIf _inflateLevel >= 3
        loc_str = "Over-inflated"
    ElseIf _inflateLevel >= 2
        loc_str = "Inflated"
    ElseIf _inflateLevel >= 1
        loc_str = "Slightly puffed up"
    Else
        loc_str = "Deflated"
    EndIf
    If abDecorate
        Return UDMTF.Text(loc_str, asColor = UDMTF.PercentToRainbow(100 - _inflateLevel * 20))
    Else
        Return loc_str
    EndIf
EndFunction

Function inflatePlug(int increase)
    _inflateLevel += increase
    if _inflateLevel > 5
        _inflateLevel = 5
    endif
    
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

Function activateDevice()
    resetCooldown(1.0)
    bool loc_canInflate = _inflateLevel <= 4
    bool loc_canVibrate = canVibrate() && !isVibrating()
    if loc_canInflate
        if WearerIsPlayer()
            UDmain.Print("Your "+ getDeviceName()+" suddenly inflates itself!",1)
        elseif WearerIsFollower()
            UDmain.Print(getWearerName() + "'s "+ getDeviceName() + " suddenly inflates itself!",3)
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
                UDmain.Print("You feel that your "+getDeviceName()+" lost some of its pressure.",2)
            elseif WearerIsFollower()
                UDmain.Print(getWearerName() + "'s "+ getDeviceName() + " lost some of its pressure.",3)
            endif
            resetCooldown(1.25)
            deflate(True)
        endif
    endif    
    parent.onUpdatePost(timePassed)
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
float Function getStruggleOrgasmRate()
    return parent.getStruggleOrgasmRate()
EndFunction
Float[] Function GetCurrentMinigameExpression()
	return parent.GetCurrentMinigameExpression()
EndFunction
