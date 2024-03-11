ScriptName UD_Modifier_CheapLocks extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    if !akDevice.HaveUnlockableLocks()
        return
    endif
    int loc_chance = Round(UD_Native.GetStringParamInt(aiDataStr,0)*Multiplier)
    if loc_chance
        akDevice.AddJammedLock(loc_chance)
    endif
EndFunction

Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return (akDevice.GetLockNumber() > 0) && (RandomInt(1,100) < Round(25*PatchChanceMultiplier))
EndFunction

Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
    akDevice.addModifier(self,iRange(Round(RandomInt(5,15)*PatchPowerMultiplier),0,100))
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    loc_msg += "Chance: " + iRange(Round(UD_Native.GetStringParamInt(aiDataStr,0,0)*Multiplier),0,100) + " % per hour\n"

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction