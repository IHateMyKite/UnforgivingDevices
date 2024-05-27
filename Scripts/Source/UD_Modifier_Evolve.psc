;/  File: UD_Modifier_Evolve
    Device will evolve after certain condition is fullfiled

    NameFull: Evolve
    NameAlias: EVL

    Parameters:
        0 = (optional) Type of monitored value
            0 - Hours
            1 - Orgasms
            2 - Weapon hit (proportional to base damage)
            3 - Condition loss
           -1 - Device have already evolved
            Default = 0
        1 = (optional) Amount of value required to evolve
            Hours -> Float
            Orgasms -> Int
            Weapon hit -> Chance in % to evolve in proportion to the damage taken (weapon base damage) [default 0.1]
            Condition lost -> Chance to evolve in % after device condition loss [default 10.0]
            Default = 6.0

    Form arguments:
        Form1 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form2 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form3 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    In case more then one FormX is filled, random one will be choosen

    Example:
        0,24.5  = Evolves after 1 day and half a hour
        1,3     = Evolves after 3 actor orgasms
/;
ScriptName UD_Modifier_Evolve extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Explosion Property EvolveExplosion Auto

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afMult, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    int loc_type = UD_Native.GetStringParamInt(aiDataStr,0,0)
    if loc_type == 0
        Float loc_value = UD_Native.GetStringParamFloat(aiDataStr,1,6.0) - 1.0*afMult
        if loc_value > 0
            akDevice.editStringModifier(NameAlias,1,FormatFloat(loc_value,2))
        else
            Evolve(akDevice,akForm1,akForm2,akForm3)
        endif
    endif
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    int loc_type = UD_Native.GetStringParamInt(aiDataStr,0,0)
    if loc_type == 1
        int loc_value = UD_Native.GetStringParamInt(aiDataStr,1,3) - 1
        if loc_value > 0
            akDevice.editStringModifier(NameAlias,1,loc_value)
        else
            Evolve(akDevice,akForm1,akForm2,akForm3)
        endif
    endif
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_Evolve::WeaponHit() akDevice = " + akDevice + ", akWeapon = " + akWeapon + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    int loc_type = UD_Native.GetStringParamInt(aiDataStr, 0, -1)
    if loc_type == 2
        Float loc_value = UD_Native.GetStringParamFloat(aiDataStr, 1, 0.1)
        Float loc_damage = iRange(akWeapon.GetBaseDamage(), 5, 100)
        If UDmain.TraceAllowed()
            UDmain.Log("UD_Modifier_Evolve::WeaponHit() loc_value = " + loc_value + ", loc_damage = " + loc_damage, 3)
        EndIf
        If RandomFloat(0.0, 10.0) < loc_value * loc_damage
            Evolve(akDevice, akForm1, akForm2, akForm3)
        EndIf
    endif
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_Evolve::ConditionLoss() akDevice = " + akDevice + ", aiCondition = " + aiCondition + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    int loc_type = UD_Native.GetStringParamInt(aiDataStr, 0, -1)
    if loc_type == 3
    ; TODO: (as an option) worse condition, better odds
        If RandomFloat(0.0, 100.0) < aiCondition
            Evolve(akDevice, akForm1, akForm2, akForm3)
        EndIf
    endif
EndFunction

Function Evolve(UD_CustomDevice_RenderScript akDevice, Form akForm1, Form akForm2, Form akForm3)
    Actor loc_actor = akDevice.GetWearer()
    
    Armor loc_device = none
    
    Form[] loc_forms
    Int loc_i

    If (akForm1 as FormList) != None
        loc_i = (akForm1 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm1 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm1 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm1)
    EndIf
    
    If (akForm2 as FormList) != None
        loc_i = (akForm2 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm2 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm2 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm2)
    EndIf
    
    If (akForm3 as FormList) != None
        loc_i = (akForm3 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm3 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm3 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm3)
    EndIf
        
    if loc_forms.Length > 0
        Int loc_size = loc_forms.length
        Form loc_evolveto = loc_forms[RandomInt(0,loc_size - 1)]
        if loc_evolveto as Armor
            loc_device = loc_evolveto as Armor
        endif
    endif
    akDevice.editStringModifier(NameAlias,0,-1)
    akDevice.unlockRestrain(true)
    if loc_device
        If EvolveExplosion != None
            akDevice.GetWearer().PlaceAtMe(EvolveExplosion)
        EndIf
        libs.LockDevice(loc_actor,loc_device)
        UDmain.Print(akDevice.GetDeviceName() + " have evolved in to " + loc_device.GetName() +"!")
    endif
EndFunction

; Do not use for patched devices. Instead it have to be added manually
Bool Function PatchModifierCondition(UD_CustomDevice_RenderScript akDevice)
    return false
EndFunction
Function PatchAddModifier(UD_CustomDevice_RenderScript akDevice)
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3)
    String loc_msg = ""
    
    loc_msg += "=== " + NameFull + " ===\n"
    int loc_type = UD_Native.GetStringParamInt(aiDataStr,0,0)
    if loc_type == 0
        loc_msg += "Hours to evolve: " + FormatFloat(GetStringParamFloat(aiDataStr,1,6.0),2) + "\n"
    elseif loc_type == 1
        loc_msg += "Orgasms to evolve: " + GetStringParamInt(aiDataStr,1,3) + "\n"
    elseif loc_type == 2
        loc_msg += "Chance to evolve after one point of damage: " + FormatFloat(GetStringParamFloat(aiDataStr,1,0.1), 2) + "%\n"
    elseif loc_type == 3
        loc_msg += "Chance to evolve after condition loss: " + FormatFloat(GetStringParamFloat(aiDataStr,1,0.1), 1) + "%\n"
    endif

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction