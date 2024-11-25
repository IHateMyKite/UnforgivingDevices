;/  File: UD_Modifier_GoldBase
    Abstract class for gold-related modifiers

    NameFull:   ABSTRACT!
    NameAlias:  ABSTRACT!

    Parameters:
        [0]     Int     (optional) Minimum value of coefficient A (absolute value)
                        Default value: 0
                        
        [1]     Int     (optional) Maximum value of coefficient A (absolute value)
                        Default value: Parameter [0]
                        
        [2]     Int     (optional) Minimum value of coefficient B (proportional to level)
                        Default value: 0
                        
        [3]     Int     (optional) Maximum value of coefficient B (proportional to level)
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
    Int loc_A_min = GetStringParamInt(aiDataStr, 0, 0)
    Int loc_A_max = GetStringParamInt(aiDataStr, 1, loc_A_min)
    Int loc_B_min = GetStringParamInt(aiDataStr, 2, 0)
    Int loc_B_max = GetStringParamInt(aiDataStr, 3, loc_B_min)
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
Int Function CalculateGold(String aiDataStr, int aiLevel, Bool abRandom = true)
    ; para 0 = min
    ; para 1 = max
    ; para 2 = mode
    ; para 3 = mode modfier

    int goldNumMin = Round(UD_Native.GetStringParamInt(aiDataStr,0,0)*Multiplier)
    int goldMode   = UD_Native.GetStringParamInt(aiDataStr,2,0)
    
    if UD_Native.GetStringParamAll(aiDataStr).length > 1
        int goldNumMax = Round(UD_Native.GetStringParamInt(aiDataStr,1,0)*Multiplier)
        if goldNumMax < goldNumMin
            goldNumMax = goldNumMin
        endif
        int goldNumMin2    = goldNumMin ;modified value
        int goldNumMax2    = goldNumMax ;modified value
        
        float goldModeParam = 0.0
        
        if goldMode == 0
            ;nothink
        elseif goldMode == 1 ;increase % gold based on level per parameter
            goldModeParam   = UD_Native.GetStringParamFloat(aiDataStr,3,0.05)
            goldNumMin2     = Round(goldNumMin2*(1.0 + goldModeParam*aiLevel))
            goldNumMax2     = Round(goldNumMax2*(1.0 + goldModeParam*aiLevel))
        elseif goldMode == 2 ;increase ABS gold based on level per parameter
            goldModeParam   = UD_Native.GetStringParamFloat(aiDataStr,3,10.0)*Multiplier
            goldNumMin2     = Round(goldNumMin2 + (goldModeParam*aiLevel))
            goldNumMax2     = Round(goldNumMax2 + (goldModeParam*aiLevel))
        else    ;unused
        endif
        
        int randomNum = 0
        if abRandom
            randomNum = RandomInt(goldNumMin2,goldNumMax2)
        else
            randomNum = goldNumMax2
        endif
        
        return randomNum
    else
        return goldNumMin
    endif
EndFunction

Int Function CalculateGold2(String aiDataStr, int aiLevel, Bool abRandom = true)
    ; para 0 = min A
    ; para 1 = max A
    ; para 2 = min B
    ; para 3 = max B
    ; result = A + B * Level

    Int loc_A_min = GetStringParamInt(aiDataStr, 0, 0)
    Int loc_A_max = GetStringParamInt(aiDataStr, 1, loc_A_min)
    Int loc_B_min = GetStringParamInt(aiDataStr, 2, 0)
    Int loc_B_max = GetStringParamInt(aiDataStr, 3, loc_B_min)
    
    If abRandom
        Return RandomInt(loc_A_min, loc_A_max) + RandomInt(loc_B_min, loc_B_max) * aiLevel
    Else
        Return loc_A_max + loc_B_max * aiLevel
    EndIf
EndFunction
