;/  File: UD_Modifier_BoundWeapon
    When actor unsheathes a weapon, the specified form is summoned instead

    NameFull:   Bound Weapon
    NameAlias:  BWE

    Parameters:
        None
        
    Form arguments:
        Form1   Weapon/Spell/FormList   Bound Weapon or Spell to force equip (or FormList with possible spells/weapons)
        
        Form2   Spell                  (optional) Spell that summons bound weapon specified in Form1
/;
Scriptname UD_Modifier_BoundWeapon extends UD_Modifier

import UnforgivingDevicesMain
import UD_Native

;/  Group: Overrides
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function Update()
    ; To update this value without starting a new game
    EventProcessingMask = 0x00000800
EndFunction

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Function ActorAction(UD_CustomDevice_RenderScript akDevice, Int aiActorAction, Form akSource, String aiDataStr, Form akForm1, Form akForm2, Form akForm3, Form akForm4, Form akForm5)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_Modifier_BoundWeapon::ActorAction() akDevice = " + akDevice + ", aiActorAction = " + aiActorAction + ", akSource = " + akSource + ", aiDataStr = " + aiDataStr + ", akForm1 = " + akForm1 + ", akForm2 = " + akForm2 + ", akForm3 = " + akForm3, 3)
    EndIf
    ; we effectively ignore "Unsheathe End" event that send from form(s) in akForm1
    If aiActorAction == 8 && ((akForm1 as FormList == None && akForm1 != akSource) || (akForm1 as FormList && (akForm1 as FormList).Find(akSource) < 0))
    ; Unsheathe End
        If akForm2 as Spell
            (akForm2 as Spell).Cast(akDevice.GetWearer(), akDevice.GetWearer())
        Else
            Form loc_form = akForm1
            If akForm1 as FormList
                loc_form = (akForm1 as FormList).GetAt(RandomInt(0, (akForm1 as FormList).GetSize() - 1))
            EndIf
            If loc_form as Spell
                akDevice.GetWearer().EquipSpell(loc_form as Spell, 0)
                ;akDevice.GetWearer().EquipSpell(akForm1 as Spell, 1)
            ElseIf loc_form as Weapon
                akDevice.GetWearer().EquipItem(loc_form as Weapon)
            EndIf
        EndIf
    ElseIf aiActorAction == 10 && (akForm1 == akSource || (akForm1 as FormList && (akForm1 as FormList).Find(akSource) >= 0))
    ; Sheathe End
        If akForm2 as Spell
            akDevice.GetWearer().DispelSpell(akForm2 as Spell)
        ElseIf akForm2 as Weapon
        ; TODO PR195: remove weapon from inventory?
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