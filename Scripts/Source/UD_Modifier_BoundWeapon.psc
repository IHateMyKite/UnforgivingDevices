;/  File: UD_Modifier_BoundWeapon
    When actor unsheathes a weapon, the specified form is summoned instead

    NameFull:   Bound Weapon
    NameAlias:  BWE

    Parameters in DataStr:
        None
        
    Form arguments:
        Form1   Weapon/Spell/FormList   Bound Weapon or Spell to force equip (or FormList with possible spells/weapons) to the right hand

        Form2   Weapon/Spell/FormList   Bound Weapon or Spell to force equip (or FormList with possible spells/weapons) to the left hand
        
        Form3   Spell                   (optional) Spell that summons bound weapon specified in Form1

    Example:
        
/;
Scriptname UD_Modifier_BoundWeapon extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Int aiEquipSlot, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_BoundWeapon::ActorAction() akDevice = " + akDevice + ", aiActorAction = " + aiActorAction + ", aiEquipSlot = " + aiEquipSlot + ", akSource = " + akSource + ", aiDataStr = " + aiDataStr + ", akForm1 = " + akForm1 + ", akForm2 = " + akForm2 + ", akForm3 = " + akForm3, 3)
    EndIf
    If aiEquipSlot != 1
    ; due to some internal error, events from the left hand slot never happen. But we should ignore them just in case
        Return
    EndIf
    Actor loc_wearer = akDevice.GetWearer()
    If akForm3 as Spell
    ; if the weapon (from akForm1) is summoned with a conjuration spell
        If aiActorAction == 8 && UD_Modifier.IsInForms(akSource, akForm1, akForm2) == False
            (akForm3 as Spell).Cast(loc_wearer, loc_wearer)
        ElseIf aiActorAction == 10 && UD_Modifier.IsInForms(akSource, akForm1, akForm2) == True
            loc_wearer.DispelSpell(akForm3 as Spell)
        EndIf
    Else
    ; we summon weapon/spell
        If aiActorAction == 8
        ; Unsheathe End
        ; And we're only checking the right hand slot.
            If akForm1 && UD_Modifier.IsInForms(akSource, akForm1) == False
            ; Right hand
                Form loc_form = UD_Modifier.GetRandomForm(akForm1)
                If loc_form as Spell
                    akDevice.GetWearer().EquipSpell(loc_form as Spell, 1)
                ElseIf loc_form as Weapon
                    akDevice.GetWearer().EquipItem(loc_form as Weapon)
                EndIf            
            ; Left hand
                loc_form = UD_Modifier.GetRandomForm(akForm2)
                If loc_form as Spell
                    akDevice.GetWearer().EquipSpell(loc_form as Spell, 0)
                ElseIf loc_form as Weapon
                    akDevice.GetWearer().EquipItem(loc_form as Weapon)
                EndIf
            EndIf
        ElseIf aiActorAction == 10
        ; Sheathe End
            ; TODO PR195: remove weapon from inventory?
            ; Right hand
            If UD_Modifier.IsInForms(akSource, akForm1) == True
            EndIf
        EndIf
    EndIf
EndFunction

;/  Group: User Interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    String loc_res = ""
    loc_res += UDmain.UDMTF.TableRowDetails("Weapon:", akForm1.GetName())
    loc_res += UDmain.UDMTF.TableRowDetails("Summon Spell:", akForm2.GetName())
    Return loc_res
EndFunction