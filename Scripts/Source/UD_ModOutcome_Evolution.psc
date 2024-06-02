;/  File: UD_ModOutcome_Evolution
    Evolution outcome

    NameFull: 
    NameAlias:  OEV

    Parameters:

    Form arguments:
        Form1 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form2 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form3 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    In case more then one FormX is filled, random one will be choosen

    Example:
        
/;
ScriptName UD_ModOutcome_Evolution extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

Explosion Property EvolveExplosion Auto

Function Outcome(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2 = None, Form akForm3 = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_Evolution::Outcome() akDevice = " + akDevice + ", akForm1 = " + akForm1 + ", akForm2 = " + akForm2 + ", akForm3 = " + akForm3, 3)
    EndIf
    Actor loc_actor = akDevice.GetWearer()
    Armor loc_device = none
    
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
        
    if loc_forms.Length > 0
        Int loc_size = loc_forms.length
        Form loc_evolveto = loc_forms[RandomInt(0,loc_size - 1)]
        if loc_evolveto as Armor
            loc_device = loc_evolveto as Armor
        endif
    endif
    akDevice.unlockRestrain(abForceDestroy = True, bEvolution = True)
    if loc_device
        If EvolveExplosion != None
            akDevice.GetWearer().PlaceAtMe(EvolveExplosion)
        EndIf
        libs.LockDevice(loc_actor,loc_device)
        UDmain.Print(akDevice.GetDeviceName() + " have evolved into " + loc_device.GetName() +"!")
    endif
EndFunction
