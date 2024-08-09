;   File: UD_Patcher_ComboPreset
;   
Scriptname UD_Patcher_ComboPreset extends ReferenceAlias

import UnforgivingDevicesMain
import UD_Native

String      Property DataStr_Easy                   Auto
String      Property DataStr_Hard                   Auto
String      Property DataStr_Types                  Auto

FormList    Property Form1_Variants                 Auto
FormList    Property Form2_Variants                 Auto
FormList    Property Form3_Variants                 Auto
FormList    Property Form4_Variants                 Auto

Float       Property MultEasing = 0.25              Auto

Keyword[]   Property PreferredDevices               Auto
Keyword[]   Property ForbiddenDevices               Auto
String[]    Property ConflictedMods                 Auto

Float Function BiasedRandom(Float afMultiplier = 1.0, Float afEasing = 1.0)
; TODO: elaborate better function
; Now it is a bijective function [0.0; 1.0] => [0.0; 1.0]. It moves random generation left or right depending on the multiplier.
; But there is always a chance to get the easiest or the hardest mod.
; Maybe that is not right.

    Return Math.Pow(RandomFloat(0.0, 1.0), Math.Pow(afMultiplier, afEasing))
EndFunction

Float Function _GetNormalRandom(Float afMu = 0.0, Float afSigma = 1.0)
; The Box–Muller transform to generate normally distributed numbers
    While True
        Float loc_x = RandomFloat(-1.0, 1.0)
        Float loc_y = RandomFloat(-1.0, 1.0)
        Float loc_s = loc_x * loc_x + loc_y * loc_y
        If loc_s > 0 && loc_s <= 1
        ; normally distributed number
            Return (loc_x * Math.Sqrt(-2.0 * Math.Log(loc_s) / loc_s)) * afSigma + afMu
        EndIf
    EndWhile
EndFunction

; more natural distribution
Float Function BiasedRandom2(Float afMultiplier = 1.0, Float afEasing = 0.25)
    Float loc_k = 2.0
    Float loc_mu = Math.Log(afMultiplier) / Math.Log(10)        ; [0.1; 100] -> [-1.0; 2.0]
    loc_mu = loc_mu * 0.5 + 0.5                                 ; [-1.0; 2.0] -> [0.0; 1.5]
    Float loc_sigma = afEasing
    ; if the mathematical expectation is outside the interval [0; 1], then we start reducing sigma
    If loc_mu < 0.0
        loc_sigma = loc_sigma / (1.0 + (0.0 - loc_mu) * loc_k)
        loc_mu = 0.0
    ElseIf loc_mu > 1.0
    ; If the multiplier is 100, sigma becomes 2 times smaller
        loc_sigma = loc_sigma / (1.0 + (loc_mu - 1.0) * loc_k)
        loc_mu = 1.0
    EndIf
    While True
        Float loc_nrand = _GetNormalRandom(loc_mu, loc_sigma)
        If loc_nrand >= 0.0 && loc_nrand <= 1.0
            Return loc_nrand
        EndIf
    EndWhile
EndFunction

String Function GetDataStr(Float afMultiplier = 1.0)
    Int i = 0
    Int loc_size = UD_Native.GetStringParamAll(DataStr_Easy).Length
    String loc_datastr = ""
    While i < loc_size
        String loc_type = GetStringParamString(DataStr_Types, i, "")
        String loc_rnd_str = ""
        If GetStringParamString(DataStr_Easy, i, "") != ""
            Float loc_rnd_1 = BiasedRandom2(afMultiplier, MultEasing)
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

Form Function GetForm1(Float afMultiplier = 1.0)
    If Form1_Variants && Form1_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom2(afMultiplier, MultEasing)
        Int loc_i = (loc_rnd_1 * (Form1_Variants.GetSize() - 1)) as Int
        Return Form1_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Form Function GetForm2(Float afMultiplier = 1.0)
    If Form2_Variants && Form2_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom2(afMultiplier, MultEasing)
        Int loc_i = (loc_rnd_1 * (Form2_Variants.GetSize() - 1)) as Int
        Return Form2_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Form Function GetForm3(Float afMultiplier = 1.0)
    If Form3_Variants && Form3_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom2(afMultiplier, MultEasing)
        Int loc_i = (loc_rnd_1 * (Form3_Variants.GetSize() - 1)) as Int
        Return Form3_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Form Function GetForm4(Float afMultiplier = 1.0)
    If Form4_Variants && Form4_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom2(afMultiplier, MultEasing)
        Int loc_i = (loc_rnd_1 * (Form4_Variants.GetSize() - 1)) as Int
        Return Form4_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Bool Function CheckDevice(UD_CustomDevice_RenderScript akDevice)
    Int loc_i
    If ForbiddenDevices.Length > 0
        loc_i = ForbiddenDevices.Length
        While loc_i > 0
            loc_i -= 1
            If ForbiddenDevices[loc_i] == akDevice.UD_DeviceKeyword
                Return False
            EndIf
        EndWhile
    EndIf
        
    If ConflictedMods.Length > 0
        String[] loc_mods = akDevice.GetModifierAliases()
        If PapyrusUtil.GetMatchingString(loc_mods, ConflictedMods).Length > 0
            Return False
        EndIf
    EndIf
    
    If PreferredDevices.Length > 0
        loc_i = PreferredDevices.Length
        While loc_i > 0
            loc_i -= 1
            If PreferredDevices[loc_i] == akDevice.UD_DeviceKeyword
                Return True
            EndIf
        EndWhile
        Return False
    EndIf
    Return True
EndFunction
