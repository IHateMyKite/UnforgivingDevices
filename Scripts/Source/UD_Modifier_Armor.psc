;/  File: UD_Modifier_Armor
    This device is sturdy enough to provide some protection to the wearer

    NameFull:   Armor
    NameAlias:  ARM

    Parameters:
        [0]     String      Armor Type          (Light, Heavy)
        
        [1]     String      Armor Material      (Ebony, Leather, Iron, Steel, etc)
        
        [2]     Int         Armor Value         ##

/;
Scriptname UD_Modifier_Armor extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    SetArmorValues(akDevice, aiDataStr)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    SetArmorValues(akDevice, aiDataStr)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_msg = ""
    
    loc_msg += "==== " + NameFull + " ====\n"
    loc_msg += "Armor Type: \t" + UD_Native.GetStringParamString(aiDataStr, 0, "Light") + "\n"
    loc_msg += "Material: \t" + UD_Native.GetStringParamString(aiDataStr, 1, "Leather") + "\n"
    loc_msg += "Armor Value: \t\t" + UD_Native.GetStringParamInt(aiDataStr, 2, 0) + "\n"
    
    if Description
        loc_msg += "=== Description ===" + "\n"
        loc_msg += Description
    endif
    
    UDmain.ShowMessageBox(loc_msg)
EndFunction

Function SetArmorValues(UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_Armor::SetArmorValues() akDevice = " + akDevice + ", aiDataStr = " + aiDataStr, 3)
    EndIf
    String loc_armor_type = UD_Native.GetStringParamString(aiDataStr, 0, "Light")
    String loc_armor_material = UD_Native.GetStringParamString(aiDataStr, 1, "Leather")
    Int loc_armor_value = UD_Native.GetStringParamInt(aiDataStr, 2, 1)
    
    Keyword loc_kw_type = Keyword.GetKeyword("Armor" + loc_armor_type)
    Keyword loc_kw_material = Keyword.GetKeyword("ArmorMaterial" + loc_armor_material)
        
    If loc_kw_type == None
        UDmain.Error("UD_Modifier_Armor::SetArmorValues() Can't find keyword for the provided armor type. Invalid argument aiDataStr = " + aiDataStr)
        Return
    EndIf
    If loc_kw_material == None
        UDmain.Warning("UD_Modifier_Armor::SetArmorValues() Can't find keyword for the provided armor material. Invalid argument aiDataStr = " + aiDataStr)
    EndIf
    
    Armor loc_device_inventory = akDevice.DeviceInventory
    Armor loc_device_rendered = akDevice.DeviceRendered
    
    If UDMain.PO3Installed
        If !loc_device_rendered.HasKeyword(loc_kw_type)
            PO3_SKSEFunctions.AddKeywordToForm(loc_device_rendered, loc_kw_type)
            ; what if it has another armor keyword?
        EndIf
        If !loc_device_rendered.HasKeyword(loc_kw_material)
            PO3_SKSEFunctions.AddKeywordToForm(loc_device_rendered, loc_kw_material)
            ; what if it has another material keyword?
        EndIf
    EndIf
    
    loc_device_inventory.SetArmorRating(loc_armor_value)
    loc_device_rendered.SetArmorRating(loc_armor_value)
    If loc_armor_type == "heavy"
        loc_device_inventory.SetWeightClass(1)
        loc_device_rendered.SetWeightClass(1)
    ElseIf loc_armor_type == "light"
        loc_device_inventory.SetWeightClass(0)
        loc_device_rendered.SetWeightClass(0)
    Else
        loc_device_inventory.SetWeightClass(2)
        loc_device_rendered.SetWeightClass(2)
    EndIf
    ; TODO: modify base health of the device to make it impossible to struggle out, only to destroy
EndFunction
