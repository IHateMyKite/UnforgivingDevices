;/  File: UD_ModOutcome_Evolution
    Device evolves

    NameFull: Evolution

    Parameters in DataStr (indices relative to DataStrOffset property):
        None

    Form arguments:
        Form2               Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.

        Form3               Device in to which will current device evolve. In case this is formlist, random device from formlist will be used.
    
        In case more then one FormX is filled, random one will be choosen

    Example:
        
/;
ScriptName UD_ModOutcome_Evolution extends UD_ModOutcome

import UnforgivingDevicesMain
import UD_Native

Explosion Property EvolveExplosion Auto

Function Outcome(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    Actor loc_actor = akDevice.GetWearer()  
    Armor loc_device = UD_Modifier.GetRandomForm(akForm2, akForm3) as Armor

    akDevice.unlockRestrain(abForceDestroy = True, bEvolution = True)
    if loc_device
        If EvolveExplosion != None
            akDevice.GetWearer().PlaceAtMe(EvolveExplosion)
        EndIf
        libs.LockDevice(loc_actor,loc_device)
        UDmain.Print(akDevice.GetDeviceName() + " have evolved into " + loc_device.GetName() +"!")
    endif
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm2, Form akForm3)
    String loc_res = ""
    If akForm2
        loc_res += akModifier.PrintFormListSelectionDetails(akForm2, "R")
    EndIf
    If akForm3
        loc_res += akModifier.PrintFormListSelectionDetails(akForm3, "R")
    EndIf
    Return loc_res
EndFunction