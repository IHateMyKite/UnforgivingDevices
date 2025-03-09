;/  File: UD_Modifier_Armor
    This device is sturdy enough to provide some protection to the wearer

    NameFull:   Armor
    NameAlias:  ARM

    Parameters in DataStr:
        [0]     String      Armor Type (Light, Heavy)
        
        [1]     String      Armor Material (Ebony, Leather, Iron, Steel, etc)
        
        [2]     Int         Armor Value

    Example:
        Light,Leather,12    After equipping, the device forms gain keywords corresponding to leather light armor and armor value of 12.

/;
Scriptname UD_Modifier_Armor extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    SetArmorValues(akDevice, aiDataStr)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    SetArmorValues(akDevice, aiDataStr)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Armor Type:", UD_Native.GetStringParamString(aiDataStr, 0, "Light"))
    loc_res += UDmain.UDMTF.TableRowDetails("Material:", UD_Native.GetStringParamString(aiDataStr, 1, "Leather"))
    loc_res += UDmain.UDMTF.TableRowDetails("Armor Value:", MultInt(UD_Native.GetStringParamInt(aiDataStr, 2, 0), MultOutputQuantities))
    Return loc_res
EndFunction


;/  Group: Protected Methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function SetArmorValues(UD_CustomDevice_RenderScript akDevice, String aiDataStr)
    String loc_armor_type = UD_Native.GetStringParamString(aiDataStr, 0, "Light")
    String loc_armor_material = UD_Native.GetStringParamString(aiDataStr, 1, "Leather")
    Int loc_armor_value = MultInt(UD_Native.GetStringParamInt(aiDataStr, 2, 0), MultOutputQuantities)

    If loc_armor_value < 1
        UDmain.Error("UD_Modifier_Armor::SetArmorValues() Armor value is invalid. loc_armor_value = " + loc_armor_value)
        Return
    EndIf
    
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
    ; TODO PR195: modify base health of the device to make it impossible to struggle out, only to destroy
EndFunction
