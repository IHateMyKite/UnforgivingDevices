;   File: UD_Patcher_ComboPreset
;   
Scriptname UD_Patcher_ComboPreset extends ReferenceAlias

import UnforgivingDevicesMain
import UD_Native

String Property DataStr_Easy Auto
String Property DataStr_Hard Auto
String Property DataStr_Types Auto
; Int Property DataStr_Length Auto

FormList Property Form3_Variants Auto
FormList Property Form4_Variants Auto

Float Property MultEasing = 0.25 Auto


Float Function BiasedRandom(Float afMultiplier = 1.0, Float afEasing = 1.0)
; TODO: elaborate better function
; Now it is a bijective function [0.0; 1.0] => [0.0; 1.0]. It moves random generation left or right depending on the multiplier.
; But there is always a chance to get the easiest or the hardest mod.
; Maybe that is not right.

    Return Math.Pow(RandomFloat(0.0, 1.0), Math.Pow(afMultiplier, afEasing))
EndFunction

String Function GetDataStr(Float afMultiplier = 1.0)
    Int i = 0
    Int loc_size = UD_Native.GetStringParamAll(DataStr_Easy).Length
    String loc_datastr = ""
    While i < loc_size
        String loc_type = GetStringParamString(DataStr_Types, i, "")
        String loc_rnd_str = ""
        If GetStringParamString(DataStr_Easy, i, "") != ""
            Float loc_rnd_1 = BiasedRandom(afMultiplier, MultEasing)
            If loc_type == "I"
                Int loc_min = GetStringParamInt(DataStr_Easy, i, 0)
                Int loc_max = GetStringParamInt(DataStr_Hard, i, loc_min)
                loc_rnd_str = ((loc_rnd_1 * (loc_max - loc_min) + loc_min) as Int) as String
            ElseIf loc_type == "F"
                Float loc_min = GetStringParamFloat(DataStr_Easy, i, 0.0)
                Float loc_max = GetStringParamFloat(DataStr_Hard, i, loc_min)
                loc_rnd_str = FormatFloat(loc_rnd_1 * (loc_max - loc_min) + loc_min, 3)
            Else
                String loc_val1 = GetStringParamString(DataStr_Easy, i, "")
                String loc_val2 = GetStringParamString(DataStr_Hard, i, loc_val1)
                If loc_rnd_1 > 0.5
                    loc_rnd_str = loc_val2
                Else
                    loc_rnd_str = loc_val1
                EndIf
            EndIf
        EndIf
        loc_datastr += loc_rnd_str + ","
        i += 1
    EndWhile
    
    Return loc_datastr
EndFunction

Form Function GetForm3(Float afMultiplier = 1.0)
    If Form3_Variants && Form3_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom(afMultiplier, MultEasing)
        Int loc_i = (loc_rnd_1 * (Form3_Variants.GetSize() - 1)) as Int
        Return Form3_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Form Function GetForm4(Float afMultiplier = 1.0)
    If Form4_Variants && Form4_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom(afMultiplier, MultEasing)
        Int loc_i = (loc_rnd_1 * (Form3_Variants.GetSize() - 1)) as Int
        Return Form4_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction
