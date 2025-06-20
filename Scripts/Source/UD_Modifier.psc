;   File: UD_Modifier
;   This is base scripts of all modifiers
Scriptname UD_Modifier extends ReferenceAlias Hidden

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty
UD_Libs Property UDlibs Hidden
    UD_Libs Function Get()
        return UDmain.UDlibs
    EndFunction
EndProperty
UDCustomDeviceMain Property UDCDmain Hidden
    UDCustomDeviceMain Function Get()
        return UDmain.UDCDmain
    EndFunction
EndProperty
UD_CustomDevices_NPCSlotsManager Property UDNPCM
    UD_CustomDevices_NPCSlotsManager Function get()
        return UDmain.UDNPCM
    EndFunction
EndProperty
zadlibs Property libs
    zadlibs Function get()
        return UDmain.libs
    EndFunction
EndProperty

;/  Group: Variables
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: NameFull
    Full name of the modifier which is shown to the player
/;
String      Property NameFull               Auto

;/  Variable: NameAlias
    Short name of the modifier which is used internaly (MAO for example if full name if Manifest At Orgasm)
/;
String      Property NameAlias              Auto

;/  Variable: Description
    Additional info shown to player when selecting modifier on device
/;
String      Property Description            Auto

;/  Variable: ConcealmentPower

    Value between 0 and 100

    TODO PR195:
    
    The degree to which the modifier resists recognition.
    If the degree is 0, the character will easily reveal the modifier's properties.
    If the degree of concealment is higher than the character's abilities, then 
    information about the modifier will not be visible.
/;
Int         Property ConcealmentPower  = 0  Auto

;/  Variable: HideInUI

    TODO PR195:
    
    Indicates that this modifier should be hidden in UI
/;
Bool        Property HideInUI       = False Auto

;/  Variable: Tags
    An array of tags
    Tags assigned to a modifier to specify the nature of its action to avoid conflicts with other modifiers
/;
String[]    Property Tags                   Auto

;/  Variable: MultProbabilities

    Multiplier which can be used to allow user to change difficulty of modifier.
    
    Have to be implemented manually at a correct place
    
    Changes all probabilities for the modifier
    
    This will affect even equipped devices
/;
Float       Property MultProbabilities          = 1.0       Auto Hidden

;/  Variable: MultInputQuantities

    Multiplier which can be used to allow user to change difficulty of modifier.
    
    Have to be implemented manually at a correct place
    
    Changes all input quantitative values
    
    This will affect even equipped devices
/;
Float       Property MultInputQuantities        = 1.0       Auto Hidden

;/  Variable: MultOutputQuantities

    Multiplier which can be used to allow user to change difficulty of modifier.
    
    Have to be implemented manually at a correct place
    
    Changes all output quantitative values
    
    This will affect even equipped devices
/;
Float       Property MultOutputQuantities       = 1.0       Auto Hidden

Int         Property PrintFormsMax              = 3         AutoReadOnly Hidden


Float Function GetOutputFloat(String aiDataStr, Int aiIndex)
    Return MultFloat(UD_Native.GetStringParamFloat(aiDataStr, 0, 0.0), MultInputQuantities)
EndFunction

Int Function GetOutputInt(String aiDataStr, Int aiIndex)
    Return MultInt(UD_Native.GetStringParamInt(aiDataStr, 0, 0), MultInputQuantities)
EndFunction

Int Function MultInt(Float afValue, Float afMult)
    Return UD_Native.Round(afValue * afMult)
EndFunction

Float Function MultFloat(Float afValue, Float afMult)
    Return afValue * afMult
EndFunction

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function ValidateModifier(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return True
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function GameLoaded(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function TimeUpdateSeconds(UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, Float afRealSecondsSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function TimeUpdateHour(UD_CustomDevice_RenderScript akDevice, Float afGameHoursSinceLastCall, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function Orgasm(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function DeviceLocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function DeviceUnlocked(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Bool Function MinigameAllowed(UD_CustomDevice_RenderScript akModDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    return true
EndFunction

Function MinigameStarted(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function MinigameEnded(UD_CustomDevice_RenderScript akModDevice, UD_CustomDevice_RenderScript akMinigameDevice,String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function WeaponHit(UD_CustomDevice_RenderScript akDevice, Weapon akWeapon, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function SpellHit(UD_CustomDevice_RenderScript akDevice, Form akSpell, Float afDamage, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function SpellCast(UD_CustomDevice_RenderScript akDevice, Spell akSpell, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function ConditionLoss(UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function StatEvent(UD_CustomDevice_RenderScript akDevice, String asStatName, Int aiStatValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function Sleep(UD_CustomDevice_RenderScript akDevice, Float afDuration, Bool abInterrupted, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Int aiEquipSlot, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function KillMonitor(UD_CustomDevice_RenderScript akDevice, ObjectReference akVictim, Int aiCrimeStatus, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function ItemAdded(UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akSourceContainer, Bool abIsStolen, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function ItemRemoved(UD_CustomDevice_RenderScript akDevice, Form akItemForm, Int aiItemCount, ObjectReference akDestContainer, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

Function SkillIncreased(UD_CustomDevice_RenderScript akDevice, String asSkill, Int aiValue, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""

    ; TODO PR195: ConcealmentPower
    ; "You are unable to recognize this enchantment"

    loc_res += UDmain.UDMTF.Header(NameFull, UDMain.UDMTF.FontSize + 4)
    loc_res += UDmain.UDMTF.FontBegin(aiFontSize = UDmain.UDMTF.FontSize, asColor = UDmain.UDMTF.TextColorDefault)
    loc_res += UDmain.UDMTF.TableBegin(aiLeftMargin = 30, aiColumn1Width = 160)
    loc_res += UDmain.UDMTF.HeaderSplit()

    If Description
        loc_res += UDmain.UDMTF.Paragraph(Description, asAlign = "center")
        loc_res += UDmain.UDMTF.LineGap()
    EndIf
    loc_res += UDmain.UDMTF.PageSplit(abForce = False)
    loc_res += UDmain.UDMTF.Header("Parameters")
    loc_res += GetParamsTableRows(akDevice, aiDataStr, akForm1, akForm2, akForm3, akForm4, akForm5)
    loc_res += UDmain.UDMTF.FooterSplit()
    loc_res += UDmain.UDMTF.TableEnd()
    loc_res += UDmain.UDMTF.FontEnd()

    Return loc_res
EndFunction

String Function GetCaption(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    ; TODO PR195: implement proper use of the ConcealmentPower
    If ConcealmentPower > 50
        Return "???"
    Else
        Return NameFull
    EndIf
EndFunction

String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
;    loc_res += UDmain.UDMTF.TableRowDetails("Name:", NameFull)
;    loc_res += UDmain.UDMTF.TableRowDetails("Param:", Param)
    Return loc_res
EndFunction

String Function GetSelectionMethodString(String asMethod)
    If asMethod == "A" || asMethod == "ALL"
        Return "All"
    ElseIf asMethod == "S" || asMethod == "SELF"
        Return "Self"
    ElseIf asMethod == "R" || asMethod == "RANDOM"
        Return "Random"
    ElseIf asMethod == "F" || asMethod == "FIRST"
        Return "First"
    Else
        Return asMethod
    EndIf
EndFunction

String Function PrintFormListSelectionDetails(Form akForm, String asMethod)
    String loc_res = ""
    String loc_padding = " "
    String loc_name = ""
    If UDmain.UDMTF.HasHtmlMarkup()
        loc_padding = " "
    Else
        loc_padding = "              "
    EndIF
    loc_res += UDmain.UDMTF.TableRowDetails("Selected Forms:", GetSelectionMethodString(asMethod))
    If akForm as FormList 
        FormList loc_fl = akForm as FormList
        Int loc_i = 0
        Int loc_n = loc_fl.GetSize()
        If loc_n > PrintFormsMax
            loc_n = PrintFormsMax
        EndIf
        While loc_i < loc_n
            loc_name = loc_fl.GetAt(loc_i).GetName()
            If loc_name == ""
                loc_name = "<Unnamed form>"
            EndIf
            If StringUtil.GetLength(loc_name) > 20
                loc_name = StringUtil.Substring(loc_name, 0, 18) + "..."
            EndIf
            loc_res += UDmain.UDMTF.TableRowDetails(loc_padding, loc_name)
            loc_i += 1
        EndWhile
        If loc_i == 0
            loc_res += UDmain.UDMTF.TableRowDetails(loc_padding, "<Empty List>")
        EndIf
    ElseIf akForm
        loc_name = akForm.GetName()
        If loc_name == ""
            loc_name = "<Unnamed form>"
        EndIf
        If StringUtil.GetLength(loc_name) > 20
            loc_name = StringUtil.Substring(loc_name, 0, 18) + "..."
        EndIf
        loc_res += UDmain.UDMTF.TableRowDetails(loc_padding, loc_name)
    Else 
        loc_res += UDmain.UDMTF.TableRowDetails(loc_padding, "<None>")
    EndIf

    Return loc_res
EndFunction

; A message in the device description to explain the minigame prohibition
String Function MinigameProhibitedMessage(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    Return ""
EndFunction

;/  Group: Global
===========================================================================================
===========================================================================================
===========================================================================================
/;
Form Function GetRandomForm(Form akForm1, Form akForm2 = None, Form akForm3 = None) global
    Form[] loc_forms = GetAllForms(akForm1, akForm2, akForm3)
    If loc_forms.length > 0
        Return loc_forms[UD_Native.RandomInt(0, loc_forms.length - 1)]
    Else
        Return None
    EndIf
EndFunction

Form[] Function GetAllForms(Form akForm1, Form akForm2 = None, Form akForm3 = None) global
    Form[] loc_forms
    Int loc_i

    If (akForm1 as FormList) != None
        loc_i = (akForm1 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm1 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm1 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm1)
    EndIf
    
    If (akForm2 as FormList) != None
        loc_i = (akForm2 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm2 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm2 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm2)
    EndIf
    
    If (akForm3 as FormList) != None
        loc_i = (akForm3 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm3 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm3 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm3)
    EndIf

    Return loc_forms
EndFunction

Bool Function IsInForms(Form akFormToFind, Form akForm1, Form akForm2 = None, Form akForm3 = None) global
    Form[] loc_forms = GetAllForms(akForm1, akForm2, akForm3)
    If loc_forms.length > 0
        Return PapyrusUtil.CountForm(loc_forms, akFormToFind) > 0
    Else
        Return False
    EndIf
EndFunction

;/  Group: Patcher
===========================================================================================
===========================================================================================
===========================================================================================
/;

Bool Function CheckModifierCompatibility(String[] aasForbiddenModTags)
    If Tags.Length > 0 && aasForbiddenModTags.Length > 0
        String[] loc_temp_arr = PapyrusUtil.GetMatchingString(Tags, aasForbiddenModTags)
        If loc_temp_arr.Length > 0 
            Return False           ; this modifier has a forbidden tag
        endIf
    EndIf
    Return True
EndFunction

;/  Group: MCM
===========================================================================================
===========================================================================================
===========================================================================================
/;
String[] _PresetsNames

String[] Function GetPatcherPresetsNames()
    If _PresetsNames.Length == 0
        UD_Patcher_ModPreset loc_preset1 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset1) as UD_Patcher_ModPreset
        UD_Patcher_ModPreset loc_preset2 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset2) as UD_Patcher_ModPreset
        UD_Patcher_ModPreset loc_preset3 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset3) as UD_Patcher_ModPreset
        If loc_preset1
            _PresetsNames = PapyrusUtil.PushString(_PresetsNames, loc_preset1.DisplayName)
        EndIf
        If loc_preset2
            _PresetsNames = PapyrusUtil.PushString(_PresetsNames, loc_preset2.DisplayName)
        EndIf
        If loc_preset3
            _PresetsNames = PapyrusUtil.PushString(_PresetsNames, loc_preset3.DisplayName)
        EndIf
    EndIf
    Return _PresetsNames
EndFunction

UD_Patcher_ModPreset Function GetPatcherPreset(Int aiIndex)
    UD_Patcher_ModPreset loc_preset1 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset1) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset2 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset2) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset3 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset3) as UD_Patcher_ModPreset
    Int loc_i = 0
    If loc_preset1
        If aiIndex == loc_i
            Return loc_preset1
        Else
            loc_i += 1
        EndIf
    EndIf
    If loc_preset2
        If aiIndex == loc_i
            Return loc_preset2
        Else
            loc_i += 1
        EndIf
    EndIf
    If loc_preset3
        If aiIndex == loc_i
            Return loc_preset3
        EndIf
    EndIf
    Return None
EndFunction

Function SaveToJSON(String asFile)
    String loc_path = "Modifier_" + NameAlias + "_"
    
    JsonUtil.SetFloatValue(asFile, loc_path + "MultProbabilities", MultProbabilities)
    JsonUtil.SetFloatValue(asFile, loc_path + "MultInputQuantities", MultInputQuantities)
    JsonUtil.SetFloatValue(asFile, loc_path + "MultOutputQuantities", MultOutputQuantities)

    UD_Patcher_ModPreset loc_preset1 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset1) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset2 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset2) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset3 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset3) as UD_Patcher_ModPreset
    
    If loc_preset1 != None
        loc_preset1.SaveToJSON(asFile, loc_path + "Preset1")
    EndIf
    If loc_preset2 != None
        loc_preset2.SaveToJSON(asFile, loc_path + "Preset2")
    EndIf
    If loc_preset3 != None
        loc_preset3.SaveToJSON(asFile, loc_path + "Preset3")
    EndIf
    
EndFunction

Function LoadFromJSON(String asFile)
    String loc_path = "Modifier_" + NameAlias + "_"
    
    MultProbabilities = JsonUtil.GetFloatValue(asFile, loc_path + "MultProbabilities", MultProbabilities)
    MultInputQuantities = JsonUtil.GetFloatValue(asFile, loc_path + "MultInputQuantities", MultInputQuantities)
    MultOutputQuantities = JsonUtil.GetFloatValue(asFile, loc_path + "MultOutputQuantities", MultOutputQuantities)

    UD_Patcher_ModPreset loc_preset1 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset1) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset2 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset2) as UD_Patcher_ModPreset
    UD_Patcher_ModPreset loc_preset3 = ((Self as ReferenceAlias) as UD_Patcher_ModPreset3) as UD_Patcher_ModPreset
    
    If loc_preset1 != None
        loc_preset1.LoadFromJSON(asFile, loc_path + "Preset1")
    EndIf
    If loc_preset2 != None
        loc_preset2.LoadFromJSON(asFile, loc_path + "Preset2")
    EndIf
    If loc_preset3 != None
        loc_preset3.LoadFromJSON(asFile, loc_path + "Preset3")
    EndIf
EndFunction
