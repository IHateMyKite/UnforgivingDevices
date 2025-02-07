;/  File: UD_Modifier_GoldBase
    Abstract class for gold-related modifiers

    NameFull:   ABSTRACT!
    NameAlias:  ABSTRACT!

    Parameters in DataStr:
        [0]     Int         (optional) Minimum value of coefficient A (absolute value)
                            Default value: 0
                        
        [1]     Int         (optional) Maximum value of coefficient A (absolute value)
                            Default value: Parameter [0]
                        
        [2]     Int         (optional) Minimum value of coefficient B (proportional to level)
                            Default value: 0
                        
        [3]     Int         (optional) Maximum value of coefficient B (proportional to level)
                            Default value: Parameter [2]
    
    Example:
        GoldVaue = A + B * <level>
        where A and B are in ranges defined by parameters above
/;
ScriptName UD_Modifier_GoldBase extends UD_Modifier Hidden

import UnforgivingDevicesMain
import UD_Native

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Form loc_currency = UDlibs.Gold
    Int loc_A_min = MultInt(GetStringParamInt(aiDataStr, 0, 0), MultOutputQuantities)
    Int loc_A_max = MultInt(GetStringParamInt(aiDataStr, 1, loc_A_min), MultOutputQuantities)
    Int loc_B_min = MultInt(GetStringParamInt(aiDataStr, 2, 0), MultOutputQuantities)
    Int loc_B_max = MultInt(GetStringParamInt(aiDataStr, 3, loc_B_min), MultOutputQuantities)
    If akForm3 != None
        loc_currency = akForm3
    EndIf

    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Currency:", loc_currency.GetName())
    loc_res += UDmain.UDMTF.TableRowDetails("Amount:", "[" + loc_A_min + "; " + loc_A_max + "] + " + akDevice.UD_Level + " * [" + loc_B_min + "; " + loc_B_max + "]")
    Return loc_res
EndFunction

;/  Group: Protected Methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
Int Function CalculateGold2(String aiDataStr, int aiLevel, Bool abRandom = true)
    ; para 0 = min A
    ; para 1 = max A
    ; para 2 = min B
    ; para 3 = max B
    ; result = A + B * Level

    Int loc_A_min = MultInt(GetStringParamInt(aiDataStr, 0, 0), MultOutputQuantities)
    Int loc_A_max = MultInt(GetStringParamInt(aiDataStr, 1, loc_A_min), MultOutputQuantities)
    Int loc_B_min = MultInt(GetStringParamInt(aiDataStr, 2, 0), MultOutputQuantities)
    Int loc_B_max = MultInt(GetStringParamInt(aiDataStr, 3, loc_B_min), MultOutputQuantities)
    
    If abRandom
        Return RandomInt(loc_A_min, loc_A_max) + RandomInt(loc_B_min, loc_B_max) * aiLevel
    Else
        Return loc_A_max + loc_B_max * aiLevel
    EndIf
EndFunction
