;   File: UD_ModOutcome
;   This is base script of all outcomes
Scriptname UD_ModOutcome extends MiscObject Hidden

import UnforgivingDevicesMain
import UD_Native

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

;/  Variable: NameFull
    Full name of the outcome which is shown to the player
/;
String      Property NameFull               Auto

;/  Variable: Description
    Additional info shown to player when selecting modifier on device
/;
String      Property Description            Auto

;/  Variable: DataStrOffset
    Index of the first parameter in DataStr used in the outcome configuration
/;
Int         Property DataStrOffset              = 7     AutoReadOnly Hidden

;/  Group: Outcome Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
EndFunction

Bool Function MinigameAllowed(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Return True
EndFunction

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
; Handlers to implement additional logic that is tied to the device lifecycle. 
; 
Function OnDeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
EndFunction

; Handlers to implement additional logic that is tied to the device lifecycle. 
; For example, unconditional deletion of all effects after device removal.
Function OnDeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
EndFunction

; Handlers to implement additional logic that is tied to the device lifecycle.
; 
Function OnGameLoaded(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""
    If Description
        loc_res += UDmain.UDMTF.Paragraph(Description, asAlign = "center")
    EndIf
    loc_res += UDmain.UDMTF.TableBegin(aiLeftMargin = 40, aiColumn1Width = 150)
    loc_res += GetParamsTableRows(akModifier, akDevice, aiDataStr, akForm2, akForm3)
    loc_res += UDmain.UDMTF.TableEnd()
    loc_res += UDmain.UDMTF.LineGap()
    Return loc_res
EndFunction

String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""
;    loc_res += UDmain.UDMTF.TableRowDetails("Name:", NameFull)
;    loc_res += UDmain.UDMTF.TableRowDetails("Param:", Param)
    Return loc_res
EndFunction

; A message in the device description to explain the minigame prohibition
String Function MinigameProhibitedMessage(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Return akModifier.Description
EndFunction

;/  Group: Protected methods
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function PrintNotification(UD_CustomDevice_RenderScript akDevice, String asOutcome, Int aiEffectId = -1)
    String loc_wearer = "Someone's "
    If akDevice.WearerIsPlayer()
        loc_wearer = "Yours "
    Else
        loc_wearer = akDevice.GetWearer().GetActorBase().GetName() + "'s "
    EndIf

    String loc_effect = ""
    If aiEffectId < 0 || aiEffectId > 4
        aiEffectId = RandomInt(1, 4)
    EndIf
    If aiEffectId == 0
        loc_effect = ""
    ElseIf aiEffectId == 1
        loc_effect = loc_wearer + akDevice.UD_DeviceType + " just got warmer "
    ElseIf aiEffectId == 2
        loc_effect = loc_wearer + akDevice.UD_DeviceType + " has warmed up noticeably "
    ElseIf aiEffectId == 3
        loc_effect = loc_wearer + akDevice.UD_DeviceType + " began to emit electrical discharges "
    ElseIf aiEffectId == 4
        loc_effect = loc_wearer + akDevice.UD_DeviceType + " squeezed your body harder "
    EndIf
    UDMain.Print(loc_effect + asOutcome)
EndFunction

Int Function MultInt(Float afValue, Float afMult)
    Return UD_Native.Round(afValue * afMult)
EndFunction

Float Function MultFloat(Float afValue, Float afMult)
    Return afValue * afMult
EndFunction

UD_CustomDevice_RenderScript[] Function GetEquippedDevicesWithSelectionMethod(UD_CustomDevice_RenderScript akDevice, Int aiNumber, Form akForm1, String asSelectionMethod1 = "R", Form akForm2 = None, String asSelectionMethod2 = "", Form akForm3 = None, String asSelectionMethod3 = "")
    Actor loc_wearer = akDevice.GetWearer()
    
    If asSelectionMethod1 == "A" || asSelectionMethod1 == "ALL"
        UD_CustomDevice_RenderScript[] loc_all_devices = UDCDmain.getNPCDevices(loc_wearer)
        Return loc_all_devices
    EndIf

    
    If asSelectionMethod1 == "S" || asSelectionMethod1 == "SELF"
        UD_CustomDevice_RenderScript[] loc_devices = new UD_CustomDevice_RenderScript[1]
        loc_devices[0] = akDevice
        Return loc_devices
    EndIf
    
    UD_CustomDevice_RenderScript[] loc_devices = UDCDmain.MakeNewDeviceSlots()
    Int loc_i
    Int loc_index = 0
    Int loc_remain = aiNumber
    String loc_method = asSelectionMethod1
    
    Form[] loc_forms
    Form loc_kw

    If (akForm1 as FormList) != None
        loc_i = (akForm1 as FormList).GetSize()
        While loc_i > 0
            loc_i -= 1
            loc_forms = PapyrusUtil.PushForm(loc_forms, (akForm1 as FormList).GetAt(loc_i))
        EndWhile
    ElseIf akForm1 != None
        loc_forms = PapyrusUtil.PushForm(loc_forms, akForm1)
    EndIf

    If asSelectionMethod2 != ""
        While loc_forms.Length > 0 && loc_remain > 0
            If loc_method == "R" || loc_method == "RANDOM"
                loc_kw = loc_forms[RandomInt(0, loc_forms.Length - 1)]
            Else
                loc_kw = loc_forms[0]
            EndIf
            loc_forms = PapyrusUtil.RemoveForm(loc_forms, loc_kw)
            If loc_kw as Keyword != None
                UD_CustomDevice_RenderScript loc_device = UDCDmain.getDeviceByKeyword(loc_wearer, loc_kw as Keyword)
                If loc_device != None
                    loc_devices[loc_index] = loc_device
                    loc_index += 1
                    loc_remain -= 1
                EndIf
            EndIf
        EndWhile
        loc_forms = Utility.ResizeFormArray(loc_forms, 0)
        loc_method = asSelectionMethod2
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
    
    If asSelectionMethod3 != ""
        While loc_forms.Length > 0 && loc_remain > 0
            If loc_method == "R" || loc_method == "RANDOM"
                loc_kw = loc_forms[RandomInt(0, loc_forms.Length - 1)]
            Else
                loc_kw = loc_forms[0]
            EndIf
            loc_forms = PapyrusUtil.RemoveForm(loc_forms, loc_kw)
            If loc_kw as Keyword != None
                UD_CustomDevice_RenderScript loc_device = UDCDmain.getDeviceByKeyword(loc_wearer, loc_kw as Keyword)
                If loc_device != None
                    loc_devices[loc_index] = loc_device
                    loc_index += 1
                    loc_remain -= 1
                EndIf
            EndIf
        EndWhile
        loc_forms = Utility.ResizeFormArray(loc_forms, 0)
        loc_method = asSelectionMethod3
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

    While loc_forms.Length > 0 && loc_remain > 0
        If loc_method == "R" || loc_method == "RANDOM"
            loc_kw = loc_forms[RandomInt(0, loc_forms.Length - 1)]
        Else
            loc_kw = loc_forms[0]
        EndIf
        loc_forms = PapyrusUtil.RemoveForm(loc_forms, loc_kw)
        If loc_kw as Keyword != None
            UD_CustomDevice_RenderScript loc_device = UDCDmain.getDeviceByKeyword(loc_wearer, loc_kw as Keyword)
            If loc_device != None
                loc_devices[loc_index] = loc_device
                loc_index += 1
                loc_remain -= 1
            EndIf
        EndIf
    EndWhile
    Return loc_devices
EndFunction