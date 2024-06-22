;/  File: UD_ModOutcome_Evolution
    Device evolves

    NameFull: Evolution

    Parameters in DataStr (indices relative to DataStrOffset property):
        

    Form arguments:
        Form3 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
        Form4 - Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    In case more then one FormX is filled, random one will be choosen

    Example:
        
/;
ScriptName UD_ModOutcome_Evolution extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

Explosion Property EvolveExplosion Auto

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_ModOutcome_Evolution::Outcome() akDevice = " + akDevice + ", akForm3 = " + akForm3 + ", akForm4 = " + akForm4, 3)
    EndIf
    Actor loc_actor = akDevice.GetWearer()
    Armor loc_device = none
    
    Form[] loc_forms = CombineForms(akForm3, akForm4)
        
    if loc_forms.Length > 0
        Int loc_size = loc_forms.length
        Form loc_evolveto = loc_forms[RandomInt(0, loc_size - 1)]
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

String Function GetDetails(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm3, Form akForm4 = None)
    String loc_str = ""
    loc_str += "Replaces device"
    loc_str += "\n"
    loc_str += "Source: " + akForm3 + ", " + akForm4
    Return loc_str
EndFunction
