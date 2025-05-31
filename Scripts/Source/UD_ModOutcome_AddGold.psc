;/  File: UD_ModOutcome_AddGold
    Summons gold (or any other currency)

    NameFull: Add Gold

    Parameters in DataStr (indices relative to DataStrOffset property):
        [+0]    Int         (optional) Minimum value of coefficient A (absolute value)
                            Default value: 0
                        
        [+1]    Int         (optional) Maximum value of coefficient A (absolute value)
                            Default value: [+0]
                        
        [+2]    Int         (optional) Minimum value of coefficient B (proportional to level)
                            Default value: 0
                        
        [+3]    Int         (optional) Maximum value of coefficient B (proportional to level)
                            Default value: [+2]

    Form arguments:
        Form2               If not None then it is used as currency to add
        
    Example:
        GoldVaue = A + B * <level>
        where A and B are in ranges defined by parameters above
/;
Scriptname UD_ModOutcome_AddGold extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Actor loc_actor = akDevice.GetWearer()
    if !loc_actor || !IsPlayer(loc_actor) ;should only work for the player
        return
    endif
    
    Int loc_A_min = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 0, 0), akModifier.MultOutputQuantities)
    Int loc_A_max = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_A_min), akModifier.MultOutputQuantities)
    Int loc_B_min = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 2, 0), akModifier.MultOutputQuantities)
    Int loc_B_max = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 3, loc_B_min), akModifier.MultOutputQuantities)

    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_AddGold::Outcome() akForm2 = " + akForm2 + ", loc_A_min = " + loc_A_min + ", loc_A_max = " + loc_A_max + ", loc_B_min = " + loc_B_min + ", loc_B_max = " + loc_B_max, 3)
    EndIf

    Int loc_gold = RandomInt(loc_A_min, loc_A_max) + RandomInt(loc_B_min, loc_B_max) * akDevice.UD_Level
    
    Form loc_currency = UDlibs.Gold
    If akForm2 != None
        loc_currency = akForm2
    EndIf
    
    if loc_gold > 0
        PrintNotification(akDevice, ;/changed/; "and filled your purse with " + loc_currency.GetName())
        loc_actor.addItem(loc_currency, loc_gold)
    endif
    
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""
    Form loc_currency = UDlibs.Gold
    Int loc_A_min = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 0, 0), akModifier.MultOutputQuantities)
    Int loc_A_max = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 1, loc_A_min), akModifier.MultOutputQuantities)
    Int loc_B_min = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 2, 0), akModifier.MultOutputQuantities)
    Int loc_B_max = MultInt(GetStringParamInt(aiDataStr, DataStrOffset + 3, loc_B_min), akModifier.MultOutputQuantities)
    If akForm2 != None
        loc_currency = akForm2
    EndIf

    loc_res += UDmain.UDMTF.TableRowDetails("Currency:", loc_currency.GetName())
    loc_res += UDmain.UDMTF.TableRowDetails("Amount:", "[" + loc_A_min + "; " + loc_A_max + "] + " + akDevice.UD_Level + " * [" + loc_B_min + "; " + loc_B_max + "]")

    Return loc_res
EndFunction