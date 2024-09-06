;   File: UD_Patcher_ModPreset
;   
Scriptname UD_Patcher_ModPreset extends ReferenceAlias Hidden

import UnforgivingDevicesMain
import UD_Native

String      Property DisplayName = "General Preset"     Auto

String      Property DataStr_Easy                       Auto
String      Property DataStr_Hard                       Auto
String      Property DataStr_Types                      Auto

FormList    Property Form1_Variants                     Auto
FormList    Property Form2_Variants                     Auto
FormList    Property Form3_Variants                     Auto
FormList    Property Form4_Variants                     Auto
FormList    Property Form5_Variants                     Auto


Keyword[]   Property PreferredDevices                   Auto
Keyword[]   Property ForbiddenDevices                   Auto
String[]    Property ConflictedModTags                  Auto

;/  Variable: ApplicableToNPC
    Indicates that this modifier can be applied to devices on NPCs
/;
Bool        Property ApplicableToNPC            = True  Auto
{Default value: True}

;/  Variable: ApplicableToPlayer
    Indicates that this modifier can be applied to devices on the Player
/;
Bool        Property ApplicableToPlayer         = True  Auto
{Default value: True}

;/  Variable: BaseProbability
    Base probability of applying this modifier
/;
Float       Property BaseProbability            = 100.0 Auto
{Default value: 100.0}

;/  Variable: IsNormalizedProbability
    Indicates that the probability is normalized to the allowed number of modifiers (softcap)
/;
Bool        Property IsNormalizedProbability    = True  Auto
{Default value: True}

;/  Variable: BaseSeverity
    Average modifier severity (mathematical expectation of the random variable on which the configuration is generated)
/;
Float       Property BaseSeverity               = 0.0   Auto

;/  Variable: SeverityDispersion
    Severity dispersion
/;
Float       Property SeverityDispersion         = 0.20  Auto
{Default value: 0.20}

; Obsolete before it was even born
Float Function BiasedRandom(Float afMultiplier = 1.0, Float afEasing = 1.0)
; TODO: elaborate better function
; Now it is a bijective function [0.0; 1.0] => [0.0; 1.0]. It moves random generation left or right depending on the multiplier.
; But there is always a chance to get the easiest or the hardest mod.
; Maybe that is not right.

    Return Math.Pow(RandomFloat(0.0, 1.0), Math.Pow(afMultiplier, afEasing))
EndFunction

; The Box–Muller transform to generate normally distributed numbers
; 
Float Function _GetNormalRandom(Float afMu = 0.0, Float afSigma = 1.0)
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

; returns normally distributed number in interval -1.0 .. 1.0 with center shifted by BaseSeverity and sigma equals to SeverityDispersion
; see documentation for reference
Float Function BiasedRandom3(Float afGlobalMuShift = 0.0, Float afGlobalSigmaMult = 1.0)
    Float loc_mu = fRange(afGlobalMuShift, -1.0, 1.0)
    Float loc_mu_d = fRange(BaseSeverity, -1.0, 1.0)
    Float loc_sigma = fRange(SeverityDispersion * afGlobalSigmaMult, 0.01, 10.0)
    Float loc_nrand
    
    ; correction on global severity shift
    ; needs improvement because the current algorithm is not commutative
    If loc_mu_d > 0
        loc_mu += (1.0 - loc_mu) * loc_mu_d
    ElseIf loc_mu_d < 0
        loc_mu -= (-1.0 - loc_mu) * loc_mu_d
    EndIf
    
    While True
        loc_nrand = _GetNormalRandom(loc_mu, loc_sigma)
        If loc_nrand >= -1.0 && loc_nrand <= 1.0
            Return loc_nrand
        EndIf
    EndWhile
EndFunction

String Function GetDataStr(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    Int i = 0
    Int loc_size = UD_Native.GetStringParamAll(DataStr_Easy).Length
    String loc_datastr = ""
    While i < loc_size
        String loc_type = GetStringParamString(DataStr_Types, i, "")
        String loc_rnd_str = ""
        If GetStringParamString(DataStr_Easy, i, "") != ""
            Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
            Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
            If loc_type == "I"
                Int loc_min = GetStringParamInt(DataStr_Easy, i, 0)
                Int loc_max = GetStringParamInt(DataStr_Hard, i, loc_min)
                loc_rnd_str = ((loc_rnd_01 * (loc_max - loc_min) + loc_min) as Int) as String
            ElseIf loc_type == "F"
                Float loc_min = GetStringParamFloat(DataStr_Easy, i, 0.0)
                Float loc_max = GetStringParamFloat(DataStr_Hard, i, loc_min)
                loc_rnd_str = FormatFloat(loc_rnd_01 * (loc_max - loc_min) + loc_min, 3)
            Else
                String loc_val1 = GetStringParamString(DataStr_Easy, i, "")
                String loc_val2 = GetStringParamString(DataStr_Hard, i, loc_val1)
                If loc_rnd_01 > 0.5
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

Form Function GetForm1(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form1_Variants && Form1_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form1_Variants.GetSize() - 1)) as Int
        Return Form1_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Form Function GetForm2(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form2_Variants && Form2_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form2_Variants.GetSize() - 1)) as Int
        Return Form2_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Form Function GetForm3(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form3_Variants && Form3_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form3_Variants.GetSize() - 1)) as Int
        Return Form3_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Form Function GetForm4(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form4_Variants && Form4_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form4_Variants.GetSize() - 1)) as Int
        Return Form4_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Form Function GetForm5(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form5_Variants && Form5_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form5_Variants.GetSize() - 1)) as Int
        Return Form5_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

Int Function CheckDevice(UD_CustomDevice_RenderScript akDevice)
    If !FastCheckDevice(akDevice)
        Return -3               ; fast check failed
    EndIf
    
    Armor loc_inventory_armor = akDevice.DeviceInventory
    Int loc_i
    If ForbiddenDevices.Length > 0
        loc_i = ForbiddenDevices.Length
        While loc_i > 0
            loc_i -= 1
            If loc_inventory_armor.HasKeyword(ForbiddenDevices[loc_i])
                Return -1       ; device is fobidden for this mod
            EndIf
        EndWhile
    EndIf
        
    If ConflictedModTags.Length > 0
        loc_i = ConflictedModTags.Length
        While loc_i > 0
            loc_i -= 1
            If akDevice.ModifiersHasTag(ConflictedModTags[loc_i])
                Return -2       ; device has conflicted mod
            EndIf
        EndWhile        
    EndIf
    
    If PreferredDevices.Length > 0
        loc_i = PreferredDevices.Length
        While loc_i > 0
            loc_i -= 1
            If loc_inventory_armor.HasKeyword(PreferredDevices[loc_i])
                Return 2        ; device is preferred for this mod
            EndIf
        EndWhile
        Return 0                ; mod has prefferred devices but this device is not one of them
    EndIf
    Return 1                    ; just ok
EndFunction

Bool Function FastCheckDevice(UD_CustomDevice_RenderScript akDevice)
    Return ((UD_Native.IsPlayer(akDevice.getWearer()) && ApplicableToPlayer) || (!UD_Native.IsPlayer(akDevice.getWearer()) && ApplicableToNPC)) && BaseProbability > 0.0
EndFunction

Function SaveToJSON(String asFile, String asObjectPath)
    String loc_path = asObjectPath + "_"
    
    JsonUtil.SetIntValue(asFile, loc_path + "ApplicableToNPC", ApplicableToNPC As Int)
    JsonUtil.SetIntValue(asFile, loc_path + "ApplicableToPlayer", ApplicableToPlayer As Int)
    JsonUtil.SetFloatValue(asFile, loc_path + "BaseProbability", BaseProbability)
    JsonUtil.SetIntValue(asFile, loc_path + "IsNormalizedProbability", IsNormalizedProbability As Int)
    JsonUtil.SetFloatValue(asFile, loc_path + "BaseSeverity", BaseSeverity)
    JsonUtil.SetFloatValue(asFile, loc_path + "SeverityDispersion", SeverityDispersion)
    
EndFunction

Function LoadFromJSON(String asFile, String asObjectPath)
    String loc_path = asObjectPath + "_"
    
    ApplicableToNPC = JsonUtil.GetIntValue(asFile, loc_path + "ApplicableToNPC", ApplicableToNPC As Int) != 0
    ApplicableToPlayer = JsonUtil.GetIntValue(asFile, loc_path + "ApplicableToPlayer", ApplicableToPlayer As Int) != 0
    BaseProbability = JsonUtil.GetFloatValue(asFile, loc_path + "BaseProbability", BaseProbability)
    IsNormalizedProbability = JsonUtil.GetIntValue(asFile, loc_path + "IsNormalizedProbability", IsNormalizedProbability As Int) != 0
    BaseSeverity = JsonUtil.GetFloatValue(asFile, loc_path + "BaseSeverity", BaseSeverity)
    SeverityDispersion = JsonUtil.GetFloatValue(asFile, loc_path + "SeverityDispersion", SeverityDispersion)
EndFunction
