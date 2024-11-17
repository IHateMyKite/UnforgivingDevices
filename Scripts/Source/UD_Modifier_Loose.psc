;/  File: UD_Modifier_Loose
    Device is loose, allowing to wearer to struggle from it even when they have tied hands

    NameFull:   Loose
    NameAlias:  LOS

    Parameters:
        [0]     Float   (optional) The accessibility of the device (0.0 - 1.0). Used to check accessibility in UD_CustomDevice_RenderScript::getAccesibility
                        Default value: 0.0
/;
ScriptName UD_Modifier_Loose extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Update()
    EventProcessingMask = 0x00000000
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Looseness:", iRange(Round(GetStringParamFloat(aiDataStr, 0, 0.0) * 100.0), 0, 100))
    Return loc_res
EndFunction

;/  Group: Patcher Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function PatchModifierFastCheckOverride(UD_CustomDevice_RenderScript akDevice)
    if !akDevice.CanBeStruggled(1.0) || akDevice.CanBeStruggled(0.0) || akDevice.IsPlug()
        return False
    endif
    Return True
EndFunction

Float Function PatchModifierCheckAndAddOverride(UD_CustomDevice_RenderScript akDevice)
    if akDevice.UD_DeviceKeyword == libs.zad_DeviousBlindfold
        return 0.70
    elseif akDevice.UD_DeviceKeyword == libs.zad_DeviousGag
        return 0.30
    elseif akDevice.UD_DeviceKeyword == libs.zad_DeviousHood || akDevice.isMittens()
        return 1.0
    else
        return 0.50
    endif
EndFunction
