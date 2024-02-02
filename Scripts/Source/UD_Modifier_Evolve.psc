;/  File: UD_Modifier_Evolve
    Device will evolve after certain condition is fullfiled

    NameFull: Evolve
    NameAlias: EVL

    Parameters:
        0 = (optional) Type of monitored value
            0 - Hours
            1 - Orgasms
            Default = 0
        1 = (optional) Amount of value required to evolve
            Hours -> Float
            Orgasms -> Int
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

Function Evolve(UD_CustomDevice_RenderScript akDevice, Form akForm1, Form akForm2, Form akForm3)
    Actor loc_actor = akDevice.GetWearer()
    
    Armor loc_device = none
    
    if akForm1 || akForm2 || akForm3
        Form[] loc_forms
        if akForm1
            loc_forms = PapyrusUtil.PushForm(loc_forms,akForm1)
        endif
        if akForm2
            loc_forms = PapyrusUtil.PushForm(loc_forms,akForm2)
        endif
        if akForm3
            loc_forms = PapyrusUtil.PushForm(loc_forms,akForm3)
        endif
        
        Int loc_size = loc_forms.length
        Form loc_evolveto = loc_forms[RandomInt(0,loc_size - 1)]
        if loc_evolveto as Armor
            loc_device = loc_evolveto as Armor
        elseif loc_evolveto as FormList
            Formlist loc_list = loc_evolveto as FormList
            Int loc_listsize = loc_list.GetSize()
            loc_device = loc_list.GetAt(RandomInt(0,loc_listsize - 1)) as Armor
        endif
        
    endif
    akDevice.editStringModifier(NameAlias,1,-1)
    akDevice.unlockRestrain(true)
    if loc_device
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
    endif

    loc_msg += "===Description===\n"
    loc_msg += Description + "\n"

    UDmain.ShowMessageBox(loc_msg)
EndFunction