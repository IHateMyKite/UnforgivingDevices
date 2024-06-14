;/  File: UD_Modifier_BoundWeapon
    Equips bound weapon

    NameFull:   Bound Weapon
    NameAlias:  BWE

    Parameters:

    Form arguments:
        Form1 - Bound Weapon or Spell to force equip
        
        Form2 - (optional) Spell that summons bound weapon specified in Form1
        
        Form3 - not used

/;
Scriptname UD_Modifier_BoundWeapon extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_BoundWeapon::ActorAction() akDevice = " + akDevice + ", aiActorAction = " + aiActorAction + ", akSource = " + akSource + ", aiDataStr = " + aiDataStr + ", akForm1 = " + akForm1 + ", akForm2 = " + akForm2 + ", akForm3 = " + akForm3, 3)
    EndIf
    If aiActorAction == 8 && akSource != akForm1
    ; Unsheathe End
        If akForm2 as Spell
            (akForm2 as Spell).Cast(akDevice.GetWearer(), akDevice.GetWearer())
        Else
            If akForm1 as Spell
                akDevice.GetWearer().EquipSpell(akForm1 as Spell, 0)
                ;akDevice.GetWearer().EquipSpell(akForm1 as Spell, 1)
            ElseIf akForm1 as Weapon
                
            EndIf
        EndIf
    ElseIf aiActorAction == 10 && akSource == akForm1
    ; Sheathe End
        If akForm2 as Spell
            akDevice.GetWearer().DispelSpell(akForm2 as Spell)
        Else
        EndIf
    EndIf
EndFunction

Function ShowDetails(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4)
    String loc_msg = ""
    
    loc_msg += "==== " + NameFull + " ====\n"
    
    if Description
        loc_msg += "=== Description ===" + "\n"
        loc_msg += Description
    endif
    
    UDmain.ShowMessageBox(loc_msg)
EndFunction

