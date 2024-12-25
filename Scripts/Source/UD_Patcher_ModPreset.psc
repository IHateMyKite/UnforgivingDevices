;/  File: UD_Patcher_ModPreset
    
/;  
Scriptname UD_Patcher_ModPreset extends ReferenceAlias Hidden

import UnforgivingDevicesMain
import UD_Native

;/  Variable: DisplayName
    Name of the preset visible on the MCM page
/;
String      Property DisplayName = "General Preset"     Auto

;/  Variable: DataStr_Easy
    Easiest DataStr configuration when adding a modifier with the Patcher
/;
String      Property DataStr_Easy                       Auto

;/  Variable: DataStr_Ground
    Medium DataStr configuration when adding a modifier with the Patcher
    (Silly name to be displayed in the correct order)
/;
String      Property DataStr_Ground                     Auto

;/  Variable: DataStr_Hard
    Hardest DataStr configuration when adding a modifier with the Patcher
/;
String      Property DataStr_Hard                       Auto

;/  Variable: DataStr_Types
    Types of the parameters in configurations
/;
String      Property DataStr_Types                      Auto

;/  Variable: Form1_Variants
    List of possible values for the DataForm1 when adding a modifier with the Patcher.
    The easiest options come first.
/;
FormList    Property Form1_Variants                     Auto

;/  Variable: Form2_Variants
    List of possible values for the DataForm2 when adding a modifier with the Patcher.
    The easiest options come first.
/;
FormList    Property Form2_Variants                     Auto

;/  Variable: Form3_Variants
    List of possible values for the DataForm3 when adding a modifier with the Patcher.
    The easiest options come first.
/;
FormList    Property Form3_Variants                     Auto

;/  Variable: Form4_Variants
    List of possible values for the DataForm4 when adding a modifier with the Patcher.
    The easiest options come first.
/;
FormList    Property Form4_Variants                     Auto

;/  Variable: Form5_Variants
    List of possible values for the DataForm5 when adding a modifier with the Patcher.
    The easiest options come first.
/;
FormList    Property Form5_Variants                     Auto

;/  Variable: PreferredDevices
    This preset is exclusive to devices with any of the specified keywords
/;
Keyword[]   Property PreferredDevices                   Auto

;/  Variable: ForbiddenDevices
    This preset is not compatible with devices with any of the specified keywords
/;
Keyword[]   Property ForbiddenDevices                   Auto

;/  Variable: ConflictedDeviceModTags
    Modifier tags on the device that conflict with this preset
/;
String[]    Property ConflictedDeviceModTags            Auto

;/  Variable: ConflictedGlobalModTags
    Modifier tags on all worn devices that conflict with this preset
/;
String[]    Property ConflictedGlobalModTags            Auto

;/  Variable: RequiredDeviceModTags
    Modifier tags on the device that needed by this preset
/;
String[]    Property RequiredDeviceModTags              Auto

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

;/  Function: GetModifier

    Returns modifier for this patcher preset. The preset is bound to the same alias as the modifier
            
    Returns:
        Modifier
/;
UD_Modifier Function GetModifier()
    Return (Self as ReferenceAlias) as UD_Modifier
EndFunction

;/  Function: GetDataStr

    Forms a string with parameters for the modifier. Takes into account global difficulty settings and difficulty variance settings.
    It uses values from DataStr_Easy, DataStr_Ground and DataStr_Hard as references.
    
    Parameters:
        afGlobalSeverityShift               - Difficulty shift.
        afGlobalSeverityDispersionMult      - Difficulty dispersion multiplier.
        
    Returns:
        String with parameters
/;
String Function GetDataStr(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    Int i = 0
    Int loc_size = UD_Native.GetStringParamAll(DataStr_Ground).Length
    String loc_datastr = ""
    While i < loc_size
        String loc_type = GetStringParamString(DataStr_Types, i, "")
        String loc_rnd_str = ""
        If GetStringParamString(DataStr_Ground, i, "") != ""
            Float loc_rnd = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
            Float loc_rnd_01 = (loc_rnd + 1.0) / 2.0          ; scaling to interval (0; 1)
            If loc_type == "I"
                Int loc_zero = GetStringParamInt(DataStr_Ground, i, 0)
                Int loc_min = GetStringParamInt(DataStr_Easy, i, loc_zero)
                Int loc_max = GetStringParamInt(DataStr_Hard, i, loc_zero)
                If loc_rnd < 0
                    loc_rnd_str = ((loc_rnd * (loc_zero - loc_min) + loc_zero) as Int) as String
                Else
                    loc_rnd_str = ((loc_rnd * (loc_max - loc_zero) + loc_zero) as Int) as String
                EndIf
            ElseIf loc_type == "F"
                Float loc_zero = GetStringParamFloat(DataStr_Ground, i, 0.0)
                Float loc_min = GetStringParamFloat(DataStr_Easy, i, loc_zero)
                Float loc_max = GetStringParamFloat(DataStr_Hard, i, loc_zero)
                If loc_rnd < 0
                    loc_rnd_str = FormatFloat(loc_rnd * (loc_zero - loc_min) + loc_zero, 2)
                Else
                    loc_rnd_str = FormatFloat(loc_rnd * (loc_max - loc_zero) + loc_zero, 2)
                EndIf
            Else
                String loc_val_0 = GetStringParamString(DataStr_Ground, i, "")
                String loc_val_min = GetStringParamString(DataStr_Easy, i, loc_val_0)
                String loc_val_max = GetStringParamString(DataStr_Hard, i, loc_val_0)
                If loc_rnd < -0.33
                    loc_rnd_str = loc_val_min
                ElseIf loc_rnd > 0.33
                    loc_rnd_str = loc_val_max
                Else 
                    loc_rnd_str = loc_val_0
                EndIf
            EndIf
        EndIf
        loc_datastr += loc_rnd_str + ","
        i += 1
    EndWhile
    
    Return loc_datastr
EndFunction

;/  Function: GetForm1

    Returns DataForm1 value for the modifier. Takes into account global difficulty settings and difficulty variance settings.
    It uses values from Form1_Variants.
    
    Parameters:
        afGlobalSeverityShift               - Difficulty shift.
        afGlobalSeverityDispersionMult      - Difficulty dispersion multiplier.
        
    Returns:
        Form from Form1_Variants
/;
Form Function GetForm1(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form1_Variants && Form1_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form1_Variants.GetSize() - 1)) as Int
        Return Form1_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

;/  Function: GetForm2

    Returns DataForm2 value for the modifier. Takes into account global difficulty settings and difficulty variance settings.
    It uses values from Form2_Variants.
    
    Parameters:
        afGlobalSeverityShift               - Difficulty shift.
        afGlobalSeverityDispersionMult      - Difficulty dispersion multiplier.
        
    Returns:
        Form from Form2_Variants
/;
Form Function GetForm2(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form2_Variants && Form2_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form2_Variants.GetSize() - 1)) as Int
        Return Form2_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

;/  Function: GetForm3

    Returns DataForm3 value for the modifier. Takes into account global difficulty settings and difficulty variance settings.
    It uses values from Form3_Variants.
    
    Parameters:
        afGlobalSeverityShift               - Difficulty shift.
        afGlobalSeverityDispersionMult      - Difficulty dispersion multiplier.
        
    Returns:
        Form from Form3_Variants
/;
Form Function GetForm3(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form3_Variants && Form3_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form3_Variants.GetSize() - 1)) as Int
        Return Form3_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

;/  Function: GetForm4

    Returns DataForm4 value for the modifier. Takes into account global difficulty settings and difficulty variance settings.
    It uses values from Form4_Variants.
    
    Parameters:
        afGlobalSeverityShift               - Difficulty shift.
        afGlobalSeverityDispersionMult      - Difficulty dispersion multiplier.
        
    Returns:
        Form from Form4_Variants
/;
Form Function GetForm4(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form4_Variants && Form4_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form4_Variants.GetSize() - 1)) as Int
        Return Form4_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

;/  Function: GetForm5

    Returns DataForm5 value for the modifier. Takes into account global difficulty settings and difficulty variance settings.
    It uses values from Form5_Variants.
    
    Parameters:
        afGlobalSeverityShift               - Difficulty shift.
        afGlobalSeverityDispersionMult      - Difficulty dispersion multiplier.
        
    Returns:
        Form from Form5_Variants
/;
Form Function GetForm5(Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    If Form5_Variants && Form5_Variants.GetSize() > 0
        Float loc_rnd_1 = BiasedRandom3(afGlobalSeverityShift, afGlobalSeverityDispersionMult)
        Float loc_rnd_01 = (loc_rnd_1 + 1.0) / 2.0          ; scaling to interval (0; 1)
        Int loc_i = (loc_rnd_01 * (Form5_Variants.GetSize() - 1)) as Int
        Return Form5_Variants.GetAt(loc_i)
    EndIf
    Return None
EndFunction

;/  Group: Patcher
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: CheckWearerCompatibility

    Checks the actor against the requirements of the preset.
    
    Parameters:
        akActor                             - Actor

    Returns:
        -1      - the actor does not meet the requirements
         1      - the actor meets the requirements
/;
Int Function CheckWearerCompatibility(Actor akActor)
    Bool loc_is_player = UD_Native.IsPlayer(akActor)
    If ((loc_is_player && ApplicableToPlayer) || (!loc_is_player && ApplicableToNPC)) && BaseProbability > 0.0
        Return 1
    Else
        Return -1
    EndIf
EndFunction

;/  Function: CheckDeviceCompatibility

    Checks the device against the requirements of the preset.
    
    Parameters:
        akDevice                            - Device
        abCheckWearer                       - To check out wearer

    Returns:
        -3      - wearer does not meet the requirements
        -2      - device is forbidden for this preset
        -1      - preset has prefferred devices but this device is not one of them
         1      - device is compatible
         2      - device is preferred for this preset
/;
Int Function CheckDeviceCompatibility(UD_CustomDevice_RenderScript akDevice, Bool abCheckWearer = True)
    If abCheckWearer
        If !CheckWearerCompatibility(akDevice.GetWearer())
            Return -3          ; wearer is not compatible
        EndIf
    EndIf
    Armor loc_inventory_armor = akDevice.DeviceInventory
    Armor loc_rendered_armor = akDevice.DeviceRendered
    Int loc_i
    If ForbiddenDevices.Length > 0
        loc_i = ForbiddenDevices.Length
        While loc_i > 0
            loc_i -= 1
            If loc_inventory_armor.HasKeyword(ForbiddenDevices[loc_i]) || loc_rendered_armor.HasKeyword(ForbiddenDevices[loc_i])
                Return -2       ; device is forbidden for this preset
            EndIf
        EndWhile
    EndIf

    If PreferredDevices.Length > 0
        loc_i = PreferredDevices.Length
        While loc_i > 0
            loc_i -= 1
            If loc_inventory_armor.HasKeyword(PreferredDevices[loc_i]) || loc_rendered_armor.HasKeyword(PreferredDevices[loc_i])
                Return 2        ; device is preferred for this preset
            EndIf
        EndWhile
        Return -1               ; preset has prefferred devices but this device is not one of them
    EndIf
    Return 1                    ; device is compatible
EndFunction

;/  Function: CheckTagsCompatibility

    Checks if the preset is compatible with tags (from existing modifiers) on the device or wearer
    
    Parameters:
        aasDeviceModsTags                   - tags of modifiers on this device
        aasWearerModsTags                   - tags of all worn devices modifiers

    Returns:
        -2      - device has a conflicting modifier
        -1      - wearer has a devcie with conflicting modifier
         0      - device does not have the required tag
         1      - preset is compatible
/;
Int Function CheckTagsCompatibility(String[] aasDeviceModsTags, String[] aasWearerModsTags)
    If ConflictedDeviceModTags.Length > 0 && aasDeviceModsTags.Length > 0
        String[] loc_temp_arr = PapyrusUtil.GetMatchingString(ConflictedDeviceModTags, aasDeviceModsTags)
        If loc_temp_arr.Length > 0 
            Return -2           ; device has a conflicting modifier
        endIf
    EndIf

    If ConflictedGlobalModTags.Length > 0 && aasWearerModsTags.Length > 0
        String[] loc_temp_arr = PapyrusUtil.GetMatchingString(ConflictedGlobalModTags, aasWearerModsTags)
        If loc_temp_arr.Length > 0 
            Return -1           ; wearer has a devcie with conflicting modifier
        endIf
    EndIf
    
    If RequiredDeviceModTags.Length > 0
        String[] loc_temp_arr = PapyrusUtil.GetMatchingString(RequiredDeviceModTags, aasDeviceModsTags)
        If loc_temp_arr.Length < RequiredDeviceModTags.Length
            Return 0            ; device does not have the necessary tag
        endIf
    EndIf

    Return 1                    ; OK
EndFunction


Float Function GetProbability(UD_CustomDevice_RenderScript akDevice, Float afNormMult, Float afGlobalProbabilityMult)
    Float loc_prob = BaseProbability
    If IsNormalizedProbability
        loc_prob *= afNormMult
    EndIf
    loc_prob *= afGlobalProbabilityMult
    
    Return loc_prob
EndFunction

Function AddModifierWithPreset(UD_CustomDevice_RenderScript akDevice, UD_Modifier akModifier, Float afGlobalSeverityShift = 0.0, Float afGlobalSeverityDispersionMult = 1.0)
    akDevice.AddModifier(akModifier, GetDataStr(afGlobalSeverityShift, afGlobalSeverityDispersionMult), GetForm1(afGlobalSeverityShift, afGlobalSeverityDispersionMult), GetForm2(afGlobalSeverityShift, afGlobalSeverityDispersionMult), GetForm3(afGlobalSeverityShift, afGlobalSeverityDispersionMult), GetForm4(afGlobalSeverityShift, afGlobalSeverityDispersionMult), GetForm5(afGlobalSeverityShift, afGlobalSeverityDispersionMult))
EndFunction

UD_Patcher_ModPreset Function GetCompatiblePatcherPreset(UD_CustomDevice_RenderScript akDevice, Bool abCheckWearer = True)
    UD_Patcher_ModPreset loc_preset = None
    UD_Patcher_ModPreset loc_preset1 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset1) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset2 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset2) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset3 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset3) as UD_Patcher_ModPreset
    
    Int loc_priority = -10
    If loc_preset1
        Int loc_temp = loc_preset1.CheckDeviceCompatibility(akDevice, abCheckWearer)
        If loc_temp > loc_priority
            loc_priority = loc_temp
            loc_preset = loc_preset1
        EndIf
    EndIf
    If loc_preset2
        Int loc_temp = loc_preset2.CheckDeviceCompatibility(akDevice, abCheckWearer)
        If loc_temp > loc_priority
            loc_priority = loc_temp
            loc_preset = loc_preset2
        EndIf
    EndIf
    If loc_preset3
        Int loc_temp = loc_preset3.CheckDeviceCompatibility(akDevice, abCheckWearer)
        If loc_temp > loc_priority
            loc_priority = loc_temp
            loc_preset = loc_preset3
        EndIf
    EndIf

    If loc_priority < 0 || loc_preset == None
        Return None
    EndIf
    Return loc_preset
EndFunction

;/  Group: MCM
===========================================================================================
===========================================================================================
===========================================================================================
/;

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
